package com.lifesync_project.LifeSyncBackend;

import jakarta.persistence.EntityManagerFactory;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping;

import static org.junit.jupiter.api.Assertions.assertFalse;

@SpringBootTest
class RemovedFlashcardFeatureTest {
    @Autowired
    @Qualifier("requestMappingHandlerMapping")
    private RequestMappingHandlerMapping mappings;

    @Autowired
    private EntityManagerFactory entityManagerFactory;

    @Test
    void doesNotRegisterFlashcardEndpointsOrEntities() {
        assertFalse(mappings.getHandlerMethods().keySet().stream()
                .flatMap(mapping -> mapping.getPatternValues().stream())
                .anyMatch(path -> path.contains("flashcard")));
        assertFalse(entityManagerFactory.getMetamodel().getEntities().stream()
                .anyMatch(entity -> entity.getName().startsWith("Flashcard")));
    }
}
