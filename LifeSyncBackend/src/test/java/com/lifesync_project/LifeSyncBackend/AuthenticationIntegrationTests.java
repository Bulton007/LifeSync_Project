package com.lifesync_project.LifeSyncBackend;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.lifesync_project.LifeSyncBackend.entity.Users;
import com.lifesync_project.LifeSyncBackend.repository.UserRepository;
import com.lifesync_project.LifeSyncBackend.security.JwtService;
import com.lifesync_project.LifeSyncBackend.services.EmailService;
import jakarta.transaction.Transactional;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.multipart;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@Transactional
class AuthenticationIntegrationTests {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtService jwtService;

    @MockitoBean
    private EmailService emailService;

    @Test
    void registerVerifyAndLoginFollowThePublishedContract() throws Exception {
        String email = "batch1-registration@lifesync.test";

        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "fullName": "Batch One",
                                  "email": "%s",
                                  "password": "safe-password-2026"
                                }
                                """.formatted(email)))
                .andExpect(status().isOk());

        Users registered = userRepository.findByEmail(email).orElseThrow();
        assertThat(registered.getOtpCode()).matches("^[0-9]{6}$");
        assertThat(registered.getVerified()).isFalse();

        mockMvc.perform(post("/api/auth/verify-otp")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"email":"%s","otpCode":"%s"}
                                """.formatted(email, registered.getOtpCode())))
                .andExpect(status().isOk());

        String loginBody = mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"email":"%s","password":"safe-password-2026"}
                                """.formatted(email)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.tokenType").value("Bearer"))
                .andExpect(jsonPath("$.userId").value(registered.getId()))
                .andReturn()
                .getResponse()
                .getContentAsString();

        JsonNode login = objectMapper.readTree(loginBody);
        assertThat(login.path("accessToken").asText()).isNotBlank();
        assertThat(login.path("fullName").asText()).isEqualTo("Batch One");
        assertThat(login.path("email").asText()).isEqualTo(email);
    }

    @Test
    void authenticatedUserCannotReadAnotherUsersProfile() throws Exception {
        Users owner = saveVerifiedUser("batch1-owner@lifesync.test");
        Users other = saveVerifiedUser("batch1-other@lifesync.test");

        mockMvc.perform(get("/api/users/{id}", other.getId())
                        .header("Authorization", bearer(owner)))
                .andExpect(status().isForbidden());

        mockMvc.perform(get("/api/users/{id}", owner.getId())
                        .header("Authorization", bearer(owner)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(owner.getId()));
    }

    @Test
    void profileImageCanBeUploadedReadAndDeletedByItsOwner() throws Exception {
        Users owner = saveVerifiedUser("batch1-image@lifesync.test");
        MockMultipartFile image = new MockMultipartFile(
                "file",
                "avatar.png",
                MediaType.IMAGE_PNG_VALUE,
                new byte[]{(byte) 0x89, 0x50, 0x4E, 0x47});

        mockMvc.perform(multipart("/api/users/{id}/profile-image", owner.getId())
                        .file(image)
                        .header("Authorization", bearer(owner)))
                .andExpect(status().isOk());

        String storedFileName = userRepository.findById(owner.getId()).orElseThrow().getProfileImage();
        assertThat(storedFileName).endsWith(".png");

        mockMvc.perform(get("/api/users/{id}/profile-image", owner.getId())
                        .header("Authorization", bearer(owner)))
                .andExpect(status().isOk());

        mockMvc.perform(delete("/api/users/{id}/profile-image", owner.getId())
                        .header("Authorization", bearer(owner)))
                .andExpect(status().isOk());

        assertThat(userRepository.findById(owner.getId()).orElseThrow().getProfileImage()).isNull();
    }

    @Test
    void changePasswordRequiresAuthenticationAndOwnership() throws Exception {
        Users owner = saveVerifiedUser("batch1-password@lifesync.test");
        Users other = saveVerifiedUser("batch1-password-other@lifesync.test");
        String request = """
                {"currentPassword":"safe-password-2026","newPassword":"new-password-2026"}
                """;

        mockMvc.perform(put("/api/auth/change-password/{id}", owner.getId())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(request))
                .andExpect(status().isUnauthorized());

        mockMvc.perform(put("/api/auth/change-password/{id}", other.getId())
                        .header("Authorization", bearer(owner))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(request))
                .andExpect(status().isForbidden());
    }

    @Test
    void malformedJwtIsRejectedAsUnauthorized() throws Exception {
        mockMvc.perform(get("/api/tasks")
                        .header("Authorization", "Bearer not-a-valid-jwt"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void taskAndSubTaskCrudIsScopedToTheAuthenticatedOwner() throws Exception {
        Users owner = saveVerifiedUser("batch2-owner@lifesync.test");
        Users other = saveVerifiedUser("batch2-other@lifesync.test");

        String taskBody = mockMvc.perform(post("/api/tasks")
                        .header("Authorization", bearer(owner))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "title":"Ship Batch 2",
                                  "description":"Task integration",
                                  "dueDate":"2030-01-02",
                                  "priority":"HIGH"
                                }
                                """))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("PENDING"))
                .andExpect(jsonPath("$.priority").value("HIGH"))
                .andExpect(jsonPath("$.createdAt").exists())
                .andReturn().getResponse().getContentAsString();

        long taskId = objectMapper.readTree(taskBody).path("id").asLong();

        mockMvc.perform(get("/api/tasks")
                        .header("Authorization", bearer(owner)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].id").value(taskId));

        mockMvc.perform(get("/api/tasks/{id}", taskId)
                        .header("Authorization", bearer(other)))
                .andExpect(status().isNotFound());

        String subTaskBody = mockMvc.perform(post("/api/subtasks/{taskId}", taskId)
                        .header("Authorization", bearer(owner))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"title\":\"Verify ownership\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.taskId").value(taskId))
                .andReturn().getResponse().getContentAsString();

        long subTaskId = objectMapper.readTree(subTaskBody).path("id").asLong();

        mockMvc.perform(get("/api/subtasks/{id}", subTaskId)
                        .header("Authorization", bearer(other)))
                .andExpect(status().isNotFound());

        mockMvc.perform(put("/api/tasks/{id}", taskId)
                        .header("Authorization", bearer(owner))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "title":"Ship Batch 2 safely",
                                  "description":"Task integration",
                                  "dueDate":"2030-01-03",
                                  "priority":"URGENT",
                                  "status":"IN_PROGRESS"
                                }
                                """))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("IN_PROGRESS"));

        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders
                        .patch("/api/subtasks/{id}/complete", subTaskId)
                        .header("Authorization", bearer(owner)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.completed").value(true));

        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders
                        .patch("/api/tasks/{id}/complete", taskId)
                        .header("Authorization", bearer(owner)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("COMPLETED"));

        mockMvc.perform(delete("/api/tasks/{id}", taskId)
                        .header("Authorization", bearer(owner)))
                .andExpect(status().isNoContent());

        mockMvc.perform(get("/api/subtasks/{id}", subTaskId)
                        .header("Authorization", bearer(owner)))
                .andExpect(status().isNotFound());
    }

    @Test
    void habitAndCompletionHistoryAreScopedToTheAuthenticatedOwner() throws Exception {
        Users owner = saveVerifiedUser("batch3-owner@lifesync.test");
        Users other = saveVerifiedUser("batch3-other@lifesync.test");

        String habitBody = mockMvc.perform(post("/api/habits")
                        .header("Authorization", bearer(owner))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "userId":%d,
                                  "name":"Drink water",
                                  "description":"Stay hydrated",
                                  "frequency":"DAILY",
                                  "startDate":"2026-08-01",
                                  "endDate":"2030-08-01"
                                }
                                """.formatted(other.getId())))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.userId").value(owner.getId()))
                .andExpect(jsonPath("$.active").value(true))
                .andExpect(jsonPath("$.streak").value(0))
                .andReturn().getResponse().getContentAsString();

        long habitId = objectMapper.readTree(habitBody).path("habitId").asLong();

        mockMvc.perform(get("/api/habits")
                        .header("Authorization", bearer(other)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isEmpty());

        mockMvc.perform(get("/api/habits/{id}", habitId)
                        .header("Authorization", bearer(other)))
                .andExpect(status().isNotFound());

        String logBody = mockMvc.perform(post("/api/habit-logs/complete")
                        .param("habitId", Long.toString(habitId))
                        .param("userId", Long.toString(other.getId()))
                        .header("Authorization", bearer(owner)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.userId").value(owner.getId()))
                .andExpect(jsonPath("$.completed").value(true))
                .andReturn().getResponse().getContentAsString();

        long logId = objectMapper.readTree(logBody).path("habitLogId").asLong();

        mockMvc.perform(post("/api/habit-logs/complete")
                        .param("habitId", Long.toString(habitId))
                        .header("Authorization", bearer(owner)))
                .andExpect(status().isConflict());

        mockMvc.perform(get("/api/habit-logs/habit/{habitId}", habitId)
                        .header("Authorization", bearer(owner)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].habitLogId").value(logId));

        mockMvc.perform(get("/api/habit-logs/{id}", logId)
                        .header("Authorization", bearer(other)))
                .andExpect(status().isNotFound());

        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders
                        .patch("/api/habits/{id}/pause", habitId)
                        .header("Authorization", bearer(owner)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.active").value(false));

        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders
                        .patch("/api/habits/{id}/resume", habitId)
                        .header("Authorization", bearer(owner)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.active").value(true));

        mockMvc.perform(put("/api/habits/{id}", habitId)
                        .header("Authorization", bearer(owner))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "name":"Drink more water",
                                  "description":"Updated",
                                  "frequency":"WEEKDAYS",
                                  "startDate":"2026-08-02"
                                }
                                """))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.frequency").value("WEEKDAYS"));

        mockMvc.perform(delete("/api/habits/{id}", habitId)
                        .header("Authorization", bearer(owner)))
                .andExpect(status().isOk());

        mockMvc.perform(get("/api/habit-logs/{id}", logId)
                        .header("Authorization", bearer(owner)))
                .andExpect(status().isNotFound());
    }

    @Test
    void goalsSchedulesAndMilestonesAreScopedToTheAuthenticatedOwner() throws Exception {
        Users owner = saveVerifiedUser("batch4-owner@lifesync.test");
        Users other = saveVerifiedUser("batch4-other@lifesync.test");

        String goalBody = mockMvc.perform(post("/api/goals")
                        .header("Authorization", bearer(owner))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "userId":%d,
                                  "title":"Emergency fund",
                                  "description":"Six months of costs",
                                  "targetAmount":1000.00,
                                  "currentAmount":100.25,
                                  "deadline":"2030-12-31"
                                }
                                """.formatted(other.getId())))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.userId").value(owner.getId()))
                .andExpect(jsonPath("$.currentAmount").value("100.25"))
                .andReturn().getResponse().getContentAsString();
        long goalId = objectMapper.readTree(goalBody).path("id").asLong();

        mockMvc.perform(get("/api/goals/{id}", goalId).header("Authorization", bearer(other)))
                .andExpect(status().isNotFound());

        String milestoneBody = mockMvc.perform(post("/api/goal-milestones/{goalId}", goalId)
                        .header("Authorization", bearer(owner))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"title\":\"First quarter\",\"targetDate\":\"2029-01-01\"}"))
                .andExpect(status().isOk())
                .andReturn().getResponse().getContentAsString();
        long milestoneId = objectMapper.readTree(milestoneBody).path("id").asLong();

        mockMvc.perform(get("/api/goal-milestones/goal/{goalId}", goalId)
                        .header("Authorization", bearer(other)))
                .andExpect(status().isNotFound());

        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders
                        .patch("/api/goal-milestones/{id}/complete", milestoneId)
                        .header("Authorization", bearer(owner)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.completed").value(true));

        String scheduleBody = mockMvc.perform(post("/api/goal-schedules")
                        .header("Authorization", bearer(owner))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"goalId":%d,"scheduleDate":"2029-02-01","amount":25.50}
                                """.formatted(goalId)))
                .andExpect(status().isOk())
                .andReturn().getResponse().getContentAsString();
        long scheduleId = objectMapper.readTree(scheduleBody).path("goalScheduleId").asLong();

        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders
                        .patch("/api/goal-schedules/{id}/complete", scheduleId)
                        .header("Authorization", bearer(owner)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.completed").value(true));

        mockMvc.perform(get("/api/goals/{id}", goalId).header("Authorization", bearer(owner)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.currentAmount").value("125.75"));

        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders
                        .patch("/api/goals/{id}/archive", goalId)
                        .header("Authorization", bearer(owner)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.archived").value(true));

        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders
                        .patch("/api/goals/{id}/complete", goalId)
                        .header("Authorization", bearer(owner)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.completed").value(true));

        mockMvc.perform(delete("/api/goals/{id}", goalId).header("Authorization", bearer(owner)))
                .andExpect(status().isOk());

        mockMvc.perform(get("/api/goal-milestones/goal/{goalId}", goalId)
                        .header("Authorization", bearer(owner)))
                .andExpect(status().isNotFound());
    }

    @Test
    void financeRecordsUseExactMoneyAndAuthenticatedOwnership() throws Exception {
        Users owner = saveVerifiedUser("batch5-owner@lifesync.test");
        Users other = saveVerifiedUser("batch5-other@lifesync.test");

        String categoryBody = mockMvc.perform(post("/api/categories")
                        .header("Authorization", bearer(owner))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"name\":\"Batch5 Food\",\"icon\":\"restaurant\",\"color\":\"#2979FF\"}"))
                .andExpect(status().isOk())
                .andReturn().getResponse().getContentAsString();
        long categoryId = objectMapper.readTree(categoryBody).path("id").asLong();

        String expenseBody = mockMvc.perform(post("/api/expenses")
                        .header("Authorization", bearer(owner))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"userId":%d,"categoryId":%d,"title":"Lunch","amount":"12.34","expenseDate":"2026-08-20"}
                                """.formatted(other.getId(), categoryId)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.userId").value(owner.getId()))
                .andExpect(jsonPath("$.amount").value("12.34"))
                .andReturn().getResponse().getContentAsString();
        long expenseId = objectMapper.readTree(expenseBody).path("id").asLong();

        String incomeBody = mockMvc.perform(post("/api/incomes")
                        .header("Authorization", bearer(owner))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"userId":%d,"categoryId":%d,"title":"Salary","amount":"100.01","incomeDate":"2026-08-21"}
                                """.formatted(other.getId(), categoryId)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.userId").value(owner.getId()))
                .andExpect(jsonPath("$.amount").value("100.01"))
                .andReturn().getResponse().getContentAsString();
        long incomeId = objectMapper.readTree(incomeBody).path("id").asLong();

        String budgetBody = mockMvc.perform(post("/api/budgets")
                        .header("Authorization", bearer(owner))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"category":"ignored client label","categoryId":%d,"limitAmount":"50.00"}
                                """.formatted(categoryId)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.userId").value(owner.getId()))
                .andExpect(jsonPath("$.category").value("Batch5 Food"))
                .andExpect(jsonPath("$.spentAmount").value("12.34"))
                .andExpect(jsonPath("$.remainingAmount").value("37.66"))
                .andReturn().getResponse().getContentAsString();
        long budgetId = objectMapper.readTree(budgetBody).path("id").asLong();

        mockMvc.perform(get("/api/expenses/{id}", expenseId).header("Authorization", bearer(other)))
                .andExpect(status().isNotFound());
        mockMvc.perform(get("/api/incomes/{id}", incomeId).header("Authorization", bearer(other)))
                .andExpect(status().isNotFound());
        mockMvc.perform(get("/api/budgets/{id}", budgetId).header("Authorization", bearer(other)))
                .andExpect(status().isNotFound());

        mockMvc.perform(get("/api/expenses/filter")
                        .param("startDate", "2026-08-01")
                        .param("endDate", "2026-08-31")
                        .header("Authorization", bearer(owner)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].id").value(expenseId));

        mockMvc.perform(get("/api/incomes").header("Authorization", bearer(other)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isEmpty());

        mockMvc.perform(delete("/api/categories/{id}", categoryId).header("Authorization", bearer(owner)))
                .andExpect(status().isBadRequest());
    }

    @Test
    void personalProgressResourcesAreScopedToTheAuthenticatedOwner() throws Exception {
        Users owner = saveVerifiedUser("batch6-owner@lifesync.test");
        Users other = saveVerifiedUser("batch6-other@lifesync.test");

        String checkingBody = mockMvc.perform(post("/api/morning-checkings")
                        .header("Authorization", bearer(owner))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"userId":%d,"moodRating":8,"notes":"Ready for the day"}
                                """.formatted(other.getId())))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.userId").value(owner.getId()))
                .andReturn().getResponse().getContentAsString();
        long checkingId = objectMapper.readTree(checkingBody).path("id").asLong();

        mockMvc.perform(get("/api/morning-checkings").header("Authorization", bearer(other)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isEmpty());
        mockMvc.perform(get("/api/morning-checkings/{id}", checkingId)
                        .header("Authorization", bearer(other)))
                .andExpect(status().isNotFound());

        String reviewBody = mockMvc.perform(post("/api/weekly-reviews")
                        .header("Authorization", bearer(owner))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "userId":%d,
                                  "reviewSummary":"A focused week",
                                  "startDate":"2026-08-17T00:00:00",
                                  "endDate":"2026-08-23T23:59:59"
                                }
                                """.formatted(other.getId())))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.userId").value(owner.getId()))
                .andReturn().getResponse().getContentAsString();
        long reviewId = objectMapper.readTree(reviewBody).path("id").asLong();

        mockMvc.perform(post("/api/weekly-reviews")
                        .header("Authorization", bearer(owner))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "reviewSummary":"Invalid dates",
                                  "startDate":"2026-08-23T00:00:00",
                                  "endDate":"2026-08-17T00:00:00"
                                }
                                """))
                .andExpect(status().isBadRequest());
        mockMvc.perform(get("/api/weekly-reviews/{id}", reviewId)
                        .header("Authorization", bearer(other)))
                .andExpect(status().isNotFound());

        String winBody = mockMvc.perform(post("/api/wins")
                        .header("Authorization", bearer(owner))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"userId":%d,"title":"Completed a hard task","description":"Stayed focused"}
                                """.formatted(other.getId())))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.userId").value(owner.getId()))
                .andReturn().getResponse().getContentAsString();
        long winId = objectMapper.readTree(winBody).path("id").asLong();

        mockMvc.perform(get("/api/wins").header("Authorization", bearer(other)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isEmpty());
        mockMvc.perform(delete("/api/wins/{id}", winId).header("Authorization", bearer(other)))
                .andExpect(status().isNotFound());

        String rewardBody = mockMvc.perform(post("/api/user-rewards")
                        .header("Authorization", bearer(owner))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"userId":%d,"points":125,"level":99}
                                """.formatted(other.getId())))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.userId").value(owner.getId()))
                .andExpect(jsonPath("$.points").value(125))
                .andExpect(jsonPath("$.level").value(2))
                .andReturn().getResponse().getContentAsString();
        long rewardId = objectMapper.readTree(rewardBody).path("id").asLong();

        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders
                        .patch("/api/user-rewards/users/{userId}/add-points", owner.getId())
                        .header("Authorization", bearer(owner))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"points\":75}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.points").value(200))
                .andExpect(jsonPath("$.level").value(3));

        mockMvc.perform(get("/api/user-rewards/{id}", rewardId)
                        .header("Authorization", bearer(other)))
                .andExpect(status().isNotFound());
        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders
                        .patch("/api/user-rewards/users/{userId}/add-points", owner.getId())
                        .header("Authorization", bearer(other))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"points\":5}"))
                .andExpect(status().isForbidden());
        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders
                        .patch("/api/user-rewards/users/{userId}/subtract-points", owner.getId())
                        .header("Authorization", bearer(owner))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"points\":-1}"))
                .andExpect(status().isBadRequest());
    }

    @Test
    void notificationHistoryAndReadActionsAreScopedToTheAuthenticatedOwner() throws Exception {
        Users owner = saveVerifiedUser("batch7-owner@lifesync.test");
        Users other = saveVerifiedUser("batch7-other@lifesync.test");

        String firstBody = mockMvc.perform(post("/api/notifications")
                        .header("Authorization", bearer(owner))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "userId":%d,
                                  "title":"Morning reminder",
                                  "message":"Complete your check-in",
                                  "type":"REMINDER"
                                }
                                """.formatted(other.getId())))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.userId").value(owner.getId()))
                .andExpect(jsonPath("$.isRead").value(false))
                .andReturn().getResponse().getContentAsString();
        long firstId = objectMapper.readTree(firstBody).path("notificationId").asLong();

        mockMvc.perform(post("/api/notifications")
                        .header("Authorization", bearer(owner))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"title":"Weekly review","message":"Reflect on this week","type":"PROGRESS"}
                                """))
                .andExpect(status().isOk());

        mockMvc.perform(get("/api/notifications").header("Authorization", bearer(other)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isEmpty());
        mockMvc.perform(get("/api/notifications/{id}", firstId)
                        .header("Authorization", bearer(other)))
                .andExpect(status().isNotFound());
        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders
                        .patch("/api/notifications/{id}/read", firstId)
                        .header("Authorization", bearer(other)))
                .andExpect(status().isNotFound());

        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders
                        .patch("/api/notifications/{id}/read", firstId)
                        .header("Authorization", bearer(owner)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.isRead").value(true));

        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders
                        .patch("/api/notifications/read-all")
                        .param("userId", other.getId().toString())
                        .header("Authorization", bearer(owner)))
                .andExpect(status().isNoContent());

        mockMvc.perform(get("/api/notifications").header("Authorization", bearer(owner)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(2))
                .andExpect(jsonPath("$[0].isRead").value(true))
                .andExpect(jsonPath("$[1].isRead").value(true));

        mockMvc.perform(delete("/api/notifications/{id}", firstId)
                        .header("Authorization", bearer(other)))
                .andExpect(status().isNotFound());
        mockMvc.perform(delete("/api/notifications/{id}", firstId)
                        .header("Authorization", bearer(owner)))
                .andExpect(status().isNoContent());
    }

    private Users saveVerifiedUser(String email) {
        return userRepository.saveAndFlush(Users.builder()
                .fullName("Batch One User")
                .email(email)
                .password(passwordEncoder.encode("safe-password-2026"))
                .verified(true)
                .build());
    }

    private String bearer(Users user) {
        return "Bearer " + jwtService.generateToken(user);
    }
}
