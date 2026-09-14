package com.lifesync_project.LifeSyncBackend;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.lifesync_project.LifeSyncBackend.entity.Users;
import com.lifesync_project.LifeSyncBackend.repository.UserRepository;
import com.lifesync_project.LifeSyncBackend.security.JwtService;
import jakarta.transaction.Transactional;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.patch;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@Transactional
class FeatureCrudIntegrationTests {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JwtService jwtService;

    @Test
    void taskAndHabitSecondaryOperationsWork() throws Exception {
        Users owner = saveVerifiedUser("feature-task-habit@lifesync.test");
        String authorization = bearer(owner);

        long taskId = idFrom(postJson("/api/tasks", authorization, """
                {
                  "title":"Exercise secondary task paths",
                  "dueDate":"2031-01-02",
                  "priority":"NORMAL"
                }
                """), "id");

        long subTaskId = idFrom(postJson("/api/subtasks/" + taskId, authorization,
                "{\"title\":\"Original subtask\"}"), "id");

        mockMvc.perform(put("/api/subtasks/{id}", subTaskId)
                        .header("Authorization", authorization)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"title\":\"Updated subtask\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.title").value("Updated subtask"));

        mockMvc.perform(delete("/api/subtasks/{id}", subTaskId)
                        .header("Authorization", authorization))
                .andExpect(status().isNoContent());

        mockMvc.perform(get("/api/subtasks/{id}", subTaskId)
                        .header("Authorization", authorization))
                .andExpect(status().isNotFound());

        long habitId = idFrom(postJson("/api/habits", authorization, """
                {
                  "name":"Read",
                  "frequency":"DAILY",
                  "startDate":"2026-09-01",
                  "endDate":"2031-09-01"
                }
                """), "habitId");

        mockMvc.perform(post("/api/habit-logs")
                        .header("Authorization", authorization)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "habitId":%d,
                                  "completedDate":"2026-09-01",
                                  "note":"Completed from the dated endpoint"
                                }
                                """.formatted(habitId)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.habitId").value(habitId))
                .andExpect(jsonPath("$.completedDate").value("2026-09-01"))
                .andExpect(jsonPath("$.note").value("Completed from the dated endpoint"));
    }

    @Test
    void goalAndChildUpdateDeleteOperationsWork() throws Exception {
        Users owner = saveVerifiedUser("feature-goals@lifesync.test");
        String authorization = bearer(owner);

        long goalId = idFrom(postJson("/api/goals", authorization, """
                {
                  "title":"Initial goal",
                  "targetAmount":"1000.00",
                  "currentAmount":"10.25",
                  "deadline":"2031-12-31"
                }
                """), "id");

        mockMvc.perform(put("/api/goals/{id}", goalId)
                        .header("Authorization", authorization)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "title":"Updated goal",
                                  "description":"Updated safely",
                                  "targetAmount":"1200.00",
                                  "currentAmount":"20.25",
                                  "deadline":"2032-01-31"
                                }
                                """))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.title").value("Updated goal"))
                .andExpect(jsonPath("$.currentAmount").value("20.25"));

        long milestoneId = idFrom(postJson("/api/goal-milestones/" + goalId, authorization,
                "{\"title\":\"Initial milestone\",\"targetDate\":\"2030-01-01\"}"), "id");

        mockMvc.perform(put("/api/goal-milestones/{id}", milestoneId)
                        .header("Authorization", authorization)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"title\":\"Updated milestone\",\"targetDate\":\"2030-02-01\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.title").value("Updated milestone"))
                .andExpect(jsonPath("$.targetDate").value("2030-02-01"));

        long scheduleId = idFrom(postJson("/api/goal-schedules", authorization, """
                {"goalId":%d,"scheduleDate":"2030-03-01","amount":"25.50"}
                """.formatted(goalId)), "goalScheduleId");

        mockMvc.perform(put("/api/goal-schedules/{id}", scheduleId)
                        .header("Authorization", authorization)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"goalId":%d,"scheduleDate":"2030-04-01","amount":"30.50"}
                                """.formatted(goalId)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.scheduleDate").value("2030-04-01"))
                .andExpect(jsonPath("$.amount").value("30.50"));

        mockMvc.perform(delete("/api/goal-milestones/{id}", milestoneId)
                        .header("Authorization", authorization))
                .andExpect(status().isNoContent());

        mockMvc.perform(delete("/api/goal-schedules/{id}", scheduleId)
                        .header("Authorization", authorization))
                .andExpect(status().isNoContent());

        mockMvc.perform(get("/api/goal-milestones/goal/{goalId}", goalId)
                        .header("Authorization", authorization))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isEmpty());

        mockMvc.perform(get("/api/goal-schedules/goal/{goalId}", goalId)
                        .header("Authorization", authorization))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isEmpty());
    }

    @Test
    void financeUpdateFilterAndDependencyOrderedDeletesWork() throws Exception {
        Users owner = saveVerifiedUser("feature-finance@lifesync.test");
        String authorization = bearer(owner);

        long categoryId = idFrom(postJson("/api/categories", authorization,
                "{\"name\":\"Food\",\"description\":\"Initial\"}"), "id");

        mockMvc.perform(put("/api/categories/{id}", categoryId)
                        .header("Authorization", authorization)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"name\":\"Dining\",\"description\":\"Updated\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("Dining"));

        long expenseId = idFrom(postJson("/api/expenses", authorization, """
                {"categoryId":%d,"title":"Lunch","amount":"12.34","expenseDate":"2026-09-01"}
                """.formatted(categoryId)), "id");
        long incomeId = idFrom(postJson("/api/incomes", authorization, """
                {"categoryId":%d,"title":"Salary","amount":"100.01","incomeDate":"2026-09-02"}
                """.formatted(categoryId)), "id");
        long budgetId = idFrom(postJson("/api/budgets", authorization, """
                {"category":"Dining","categoryId":%d,"limitAmount":"50.00"}
                """.formatted(categoryId)), "id");

        mockMvc.perform(put("/api/expenses/{id}", expenseId)
                        .header("Authorization", authorization)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"categoryId":%d,"title":"Dinner","amount":"15.67","expenseDate":"2026-09-03"}
                                """.formatted(categoryId)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.title").value("Dinner"))
                .andExpect(jsonPath("$.amount").value("15.67"));

        mockMvc.perform(put("/api/incomes/{id}", incomeId)
                        .header("Authorization", authorization)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"categoryId":%d,"title":"Bonus","amount":"125.55","incomeDate":"2026-09-04"}
                                """.formatted(categoryId)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.title").value("Bonus"))
                .andExpect(jsonPath("$.amount").value("125.55"));

        mockMvc.perform(put("/api/budgets/{id}", budgetId)
                        .header("Authorization", authorization)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"category":"ignored","categoryId":%d,"limitAmount":"80.00"}
                                """.formatted(categoryId)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.category").value("Dining"))
                .andExpect(jsonPath("$.limitAmount").value("80.00"))
                .andExpect(jsonPath("$.spentAmount").value("15.67"));

        mockMvc.perform(get("/api/incomes/filter")
                        .param("startDate", "2026-09-01")
                        .param("endDate", "2026-09-30")
                        .header("Authorization", authorization))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].id").value(incomeId));

        mockMvc.perform(delete("/api/expenses/{id}", expenseId)
                        .header("Authorization", authorization))
                .andExpect(status().isOk());
        mockMvc.perform(delete("/api/incomes/{id}", incomeId)
                        .header("Authorization", authorization))
                .andExpect(status().isOk());
        mockMvc.perform(delete("/api/budgets/{id}", budgetId)
                        .header("Authorization", authorization))
                .andExpect(status().isNoContent());
        mockMvc.perform(delete("/api/categories/{id}", categoryId)
                        .header("Authorization", authorization))
                .andExpect(status().isOk());
    }

    @Test
    void personalProgressUpdateSubtractAndDeleteOperationsWork() throws Exception {
        Users owner = saveVerifiedUser("feature-progress@lifesync.test");
        String authorization = bearer(owner);

        long checkingId = idFrom(postJson("/api/morning-checkings", authorization,
                "{\"moodRating\":7,\"notes\":\"Initial check-in\"}"), "id");
        long reviewId = idFrom(postJson("/api/weekly-reviews", authorization, """
                {
                  "reviewSummary":"Initial review",
                  "startDate":"2026-08-24T00:00:00",
                  "endDate":"2026-08-30T23:59:59"
                }
                """), "id");
        long winId = idFrom(postJson("/api/wins", authorization,
                "{\"title\":\"Initial win\",\"description\":\"Initial\"}"), "id");
        long rewardId = idFrom(postJson("/api/user-rewards", authorization,
                "{\"points\":250}"), "id");

        mockMvc.perform(put("/api/morning-checkings/{id}", checkingId)
                        .header("Authorization", authorization)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"moodRating\":9,\"notes\":\"Updated check-in\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.moodRating").value(9));

        mockMvc.perform(put("/api/weekly-reviews/{id}", reviewId)
                        .header("Authorization", authorization)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "reviewSummary":"Updated review",
                                  "startDate":"2026-08-25T00:00:00",
                                  "endDate":"2026-08-31T23:59:59"
                                }
                                """))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.reviewSummary").value("Updated review"));

        mockMvc.perform(put("/api/wins/{id}", winId)
                        .header("Authorization", authorization)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"title\":\"Updated win\",\"description\":\"Updated\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.title").value("Updated win"));

        mockMvc.perform(patch("/api/user-rewards/users/{userId}/subtract-points", owner.getId())
                        .header("Authorization", authorization)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"points\":75}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.points").value(175))
                .andExpect(jsonPath("$.level").value(2));

        mockMvc.perform(delete("/api/morning-checkings/{id}", checkingId)
                        .header("Authorization", authorization))
                .andExpect(status().isNoContent());
        mockMvc.perform(delete("/api/weekly-reviews/{id}", reviewId)
                        .header("Authorization", authorization))
                .andExpect(status().isNoContent());
        mockMvc.perform(delete("/api/wins/{id}", winId)
                        .header("Authorization", authorization))
                .andExpect(status().isNoContent());
        mockMvc.perform(delete("/api/user-rewards/{id}", rewardId)
                        .header("Authorization", authorization))
                .andExpect(status().isNoContent());
    }

    private String postJson(String path, String authorization, String content) throws Exception {
        return mockMvc.perform(post(path)
                        .header("Authorization", authorization)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(content))
                .andExpect(status().isOk())
                .andReturn()
                .getResponse()
                .getContentAsString();
    }

    private long idFrom(String responseBody, String field) throws Exception {
        return objectMapper.readTree(responseBody).path(field).asLong();
    }

    private Users saveVerifiedUser(String email) {
        return userRepository.saveAndFlush(Users.builder()
                .fullName("Feature Test User")
                .email(email)
                .password("not-used-by-these-tests")
                .verified(true)
                .build());
    }

    private String bearer(Users user) {
        return "Bearer " + jwtService.generateToken(user);
    }
}
