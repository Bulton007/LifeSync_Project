package com.lifesync_project.LifeSyncBackend;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@TestPropertySource(properties = {
    "spring.datasource.url=jdbc:postgresql://localhost:5432/lifesync",
    "spring.datasource.username=postgres",
    "spring.datasource.password=leang30122006",
    "spring.datasource.driver-class-name=org.postgresql.Driver",
    "spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect"
})
class PostgresConnectionTest {

    @Autowired
    private DataSource dataSource;

    @Test
    void testPostgresDirectConnectionAndTables() throws Exception {
        try (Connection connection = dataSource.getConnection()) {
            assertThat(connection.isValid(2)).isTrue();
            System.out.println("=== CONNECTED TO POSTGRES SUCCESSFULLY: " + connection.getCatalog() + " ===");

            try (Statement statement = connection.createStatement()) {
                try (ResultSet rs = statement.executeQuery("SELECT count(*) FROM information_schema.tables WHERE table_schema = 'public'")) {
                    assertThat(rs.next()).isTrue();
                    int tableCount = rs.getInt(1);
                    System.out.println("=== NUMBER OF PUBLIC TABLES IN LIFESYNC DB: " + tableCount + " ===");
                    assertThat(tableCount).isGreaterThan(0);
                }
            }
        }
    }
}
