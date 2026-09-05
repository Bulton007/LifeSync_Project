package com.lifesync_project.LifeSyncBackend;

import com.lifesync_project.LifeSyncBackend.entity.*;
import com.lifesync_project.LifeSyncBackend.repository.*;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.TestPropertySource;

import javax.sql.DataSource;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@SpringBootTest
@TestPropertySource(properties = {
    "spring.datasource.url=jdbc:postgresql://localhost:5432/lifesync",
    "spring.datasource.username=postgres",
    "spring.datasource.password=leang30122006",
    "spring.datasource.driver-class-name=org.postgresql.Driver",
    "spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect",
    "spring.jpa.hibernate.ddl-auto=update"
})
public class DatabaseFeatureSeedTest {

    @Autowired
    private DataSource dataSource;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TaskRepository taskRepository;

    @Autowired
    private HabitRepository habitRepository;

    @Autowired
    private GoalRepository goalRepository;

    @Autowired
    private ExpenseRepository expenseRepository;

    @Autowired
    private IncomeRepository incomeRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Test
    public void seedThreeItemsPerFeatureAndDisplayDatabase() throws Exception {
        System.out.println("===============================================================================");
        System.out.println("          POSTGRESQL LIFESYNC DATABASE REAL DATA SEED & INSPECT                 ");
        System.out.println("===============================================================================");

        // 1. Inspect existing users in PostgreSQL
        List<Users> existingUsers = userRepository.findAll();
        System.out.println("\n[1] ALL USERS CURRENTLY IN POSTGRESQL (users table):");
        if (existingUsers.isEmpty()) {
            System.out.println("  (No users registered yet)");
        } else {
            for (Users u : existingUsers) {
                System.out.println("  -> ID: " + u.getId() + " | Email: " + u.getEmail() + " | Name: " + u.getFullName() + " | Verified: " + u.getVerified());
            }
        }

        // 2. Pick or create active user for features
        Users activeUser = existingUsers.stream()
                .filter(u -> Boolean.TRUE.equals(u.getVerified()))
                .findFirst()
                .orElse(null);

        if (activeUser == null) {
            if (!existingUsers.isEmpty()) {
                activeUser = existingUsers.get(0);
                activeUser.setVerified(true);
                activeUser = userRepository.saveAndFlush(activeUser);
            } else {
                activeUser = Users.builder()
                        .fullName("LifeSync Demo User")
                        .email("user@lifesync.com")
                        .phoneNumber("+1234567890")
                        .password(passwordEncoder.encode("Password123!"))
                        .verified(true)
                        .createdAt(LocalDateTime.now())
                        .build();
                activeUser = userRepository.saveAndFlush(activeUser);
            }
        }
        System.out.println("\n[2] ACTIVE USER FOR FEATURE DATA: ID " + activeUser.getId() + " (" + activeUser.getEmail() + ")");

        // 3. Insert 3 Tasks into tasks table
        System.out.println("\n[3] INSERTING 3 TASKS INTO POSTGRESQL 'tasks' TABLE...");
        Tasks t1 = Tasks.builder()
                .title("Design UI Landing Page")
                .description("Complete high-fidelity Figma designs for dashboard")
                .priority("HIGH")
                .status("IN_PROGRESS")
                .dueDate(LocalDate.now().plusDays(1))
                .createdAt(LocalDateTime.now())
                .user(activeUser)
                .build();
        Tasks t2 = Tasks.builder()
                .title("Review Backend API Endpoints")
                .description("Test tasks, habits, and finance endpoints with PostgreSQL")
                .priority("MEDIUM")
                .status("PENDING")
                .dueDate(LocalDate.now().plusDays(2))
                .createdAt(LocalDateTime.now())
                .user(activeUser)
                .build();
        Tasks t3 = Tasks.builder()
                .title("Prepare Sprint Demo")
                .description("Record walk-through video of mobile features")
                .priority("LOW")
                .status("COMPLETED")
                .dueDate(LocalDate.now().plusDays(3))
                .createdAt(LocalDateTime.now())
                .user(activeUser)
                .build();
        taskRepository.saveAllAndFlush(List.of(t1, t2, t3));

        // 4. Insert 3 Habits into habits table
        System.out.println("[4] INSERTING 3 HABITS INTO POSTGRESQL 'habits' TABLE...");
        Habits h1 = Habits.builder()
                .userId(activeUser.getId())
                .name("Morning Meditation (15 mins)")
                .description("Mindfulness breathing before starting the day")
                .frequency("DAILY")
                .active(true)
                .streak(7)
                .startDate(LocalDate.now().minusDays(7))
                .build();
        Habits h2 = Habits.builder()
                .userId(activeUser.getId())
                .name("Drink 2L Water")
                .description("Stay hydrated with 8 glasses throughout the day")
                .frequency("DAILY")
                .active(true)
                .streak(14)
                .startDate(LocalDate.now().minusDays(14))
                .build();
        Habits h3 = Habits.builder()
                .userId(activeUser.getId())
                .name("Evening Reading (20 pages)")
                .description("Read non-fiction and tech architecture books")
                .frequency("DAILY")
                .active(true)
                .streak(4)
                .startDate(LocalDate.now().minusDays(4))
                .build();
        habitRepository.saveAllAndFlush(List.of(h1, h2, h3));

        // 5. Insert 3 Goals into goals table
        System.out.println("[5] INSERTING 3 GOALS INTO POSTGRESQL 'goals' TABLE...");
        Goals g1 = Goals.builder()
                .userId(activeUser.getId())
                .title("Buy New MacBook Pro M3")
                .description("Dedicated budget for development workstation")
                .targetAmount(new BigDecimal("2500.00"))
                .currentAmount(new BigDecimal("1450.00"))
                .deadline(LocalDate.now().plusMonths(4))
                .completed(false)
                .archived(false)
                .build();
        Goals g2 = Goals.builder()
                .userId(activeUser.getId())
                .title("Tokyo Vacation Fund")
                .description("Flight, accommodation and food savings")
                .targetAmount(new BigDecimal("3800.00"))
                .currentAmount(new BigDecimal("920.00"))
                .deadline(LocalDate.now().plusMonths(8))
                .completed(false)
                .archived(false)
                .build();
        Goals g3 = Goals.builder()
                .userId(activeUser.getId())
                .title("Emergency Reserve")
                .description("6 months of essential living expenses")
                .targetAmount(new BigDecimal("6000.00"))
                .currentAmount(new BigDecimal("4200.00"))
                .deadline(LocalDate.now().plusMonths(6))
                .completed(false)
                .archived(false)
                .build();
        goalRepository.saveAllAndFlush(List.of(g1, g2, g3));

        // 6. Ensure Categories exist and insert 3 Financial Items (income + expense)
        System.out.println("[6] INSERTING 3 FINANCIAL TRANSACTIONS (INCOMES & EXPENSES)...");
        Categories salaryCat = categoryRepository.findByName("Salary")
                .orElseGet(() -> categoryRepository.saveAndFlush(Categories.builder().name("Salary").description("Earned income").color("#4CAF50").build()));
        Categories foodCat = categoryRepository.findByName("Food & Dining")
                .orElseGet(() -> categoryRepository.saveAndFlush(Categories.builder().name("Food & Dining").description("Restaurants and groceries").color("#FF9800").build()));
        Categories shoppingCat = categoryRepository.findByName("Electronics")
                .orElseGet(() -> categoryRepository.saveAndFlush(Categories.builder().name("Electronics").description("Tech gadgets and equipment").color("#2196F3").build()));

        Income inc1 = Income.builder()
                .userId(activeUser.getId())
                .categoryId(salaryCat.getId())
                .title("Monthly Software Engineering Salary")
                .description("Primary payroll direct deposit")
                .amount(new BigDecimal("3500.00"))
                .incomeDate(LocalDate.now())
                .build();
        incomeRepository.saveAndFlush(inc1);

        Expense exp1 = Expense.builder()
                .userId(activeUser.getId())
                .categoryId(foodCat.getId())
                .title("Whole Foods Grocery Stockup")
                .description("Weekly healthy meals and organic ingredients")
                .amount(new BigDecimal("135.50"))
                .expenseDate(LocalDate.now())
                .build();
        Expense exp2 = Expense.builder()
                .userId(activeUser.getId())
                .categoryId(shoppingCat.getId())
                .title("Mechanical Keyboard & Accessories")
                .description("Keychron mechanical keyboard with wrist rest")
                .amount(new BigDecimal("89.99"))
                .expenseDate(LocalDate.now().minusDays(1))
                .build();
        expenseRepository.saveAllAndFlush(List.of(exp1, exp2));

        // 7. Query directly via JDBC connection to prove persistence in PostgreSQL
        System.out.println("\n===============================================================================");
        System.out.println("        ACTUAL POSTGRESQL DATABASE ROWS (CONFIRMED COMMITTED)                  ");
        System.out.println("===============================================================================");
        try (Connection conn = dataSource.getConnection(); Statement stmt = conn.createStatement()) {

            // Tasks Query
            System.out.println("\n--- [TABLE: tasks] (user_id = " + activeUser.getId() + ") ---");
            try (ResultSet rs = stmt.executeQuery("SELECT id, title, priority, status, due_date FROM tasks WHERE user_id = " + activeUser.getId() + " ORDER BY id ASC")) {
                int count = 0;
                while (rs.next()) {
                    count++;
                    System.out.printf("  Task #%d: ID=%-4d | Title=%-32s | Priority=%-6s | Status=%-12s | Due=%s%n",
                            count, rs.getLong("id"), rs.getString("title"), rs.getString("priority"), rs.getString("status"), rs.getDate("due_date"));
                }
            }

            // Habits Query
            System.out.println("\n--- [TABLE: habits] (user_id = " + activeUser.getId() + ") ---");
            try (ResultSet rs = stmt.executeQuery("SELECT habit_id, name, frequency, streak, active FROM habits WHERE user_id = " + activeUser.getId() + " ORDER BY habit_id ASC")) {
                int count = 0;
                while (rs.next()) {
                    count++;
                    System.out.printf("  Habit #%d: ID=%-4d | Name=%-32s | Freq=%-6s | Streak=%-2d days | Active=%s%n",
                            count, rs.getLong("habit_id"), rs.getString("name"), rs.getString("frequency"), rs.getInt("streak"), rs.getBoolean("active"));
                }
            }

            // Goals Query
            System.out.println("\n--- [TABLE: goals] (user_id = " + activeUser.getId() + ") ---");
            try (ResultSet rs = stmt.executeQuery("SELECT goal_id, title, target_amount, current_amount, deadline FROM goals WHERE user_id = " + activeUser.getId() + " ORDER BY goal_id ASC")) {
                int count = 0;
                while (rs.next()) {
                    count++;
                    System.out.printf("  Goal #%d: ID=%-4d | Title=%-32s | Target=$%-9.2f | Current=$%-9.2f | Deadline=%s%n",
                            count, rs.getLong("goal_id"), rs.getString("title"), rs.getBigDecimal("target_amount"), rs.getBigDecimal("current_amount"), rs.getDate("deadline"));
                }
            }

            // Finance Incomes Query
            System.out.println("\n--- [TABLE: income] (user_id = " + activeUser.getId() + ") ---");
            try (ResultSet rs = stmt.executeQuery("SELECT id, title, amount, income_date FROM income WHERE user_id = " + activeUser.getId() + " ORDER BY id ASC")) {
                int count = 0;
                while (rs.next()) {
                    count++;
                    System.out.printf("  Income #%d: ID=%-4d | Title=%-38s | Amount=+$%-9.2f | Date=%s%n",
                            count, rs.getLong("id"), rs.getString("title"), rs.getBigDecimal("amount"), rs.getDate("income_date"));
                }
            }

            // Finance Expenses Query
            System.out.println("\n--- [TABLE: expense] (user_id = " + activeUser.getId() + ") ---");
            try (ResultSet rs = stmt.executeQuery("SELECT id, title, amount, expense_date FROM expense WHERE user_id = " + activeUser.getId() + " ORDER BY id ASC")) {
                int count = 0;
                while (rs.next()) {
                    count++;
                    System.out.printf("  Expense #%d: ID=%-4d | Title=%-38s | Amount=-$%-9.2f | Date=%s%n",
                            count, rs.getLong("id"), rs.getString("title"), rs.getBigDecimal("amount"), rs.getDate("expense_date"));
                }
            }
        }

        System.out.println("\n===============================================================================");
        System.out.println("       ALL 3 ITEMS PER FEATURE ARE NOW PERMANENTLY IN POSTGRESQL!             ");
        System.out.println("===============================================================================\n");
    }
}
