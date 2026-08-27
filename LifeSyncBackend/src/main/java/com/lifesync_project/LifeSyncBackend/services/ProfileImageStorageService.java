package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.exception.BadRequestException;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.Locale;
import java.util.Set;
import java.util.UUID;

@Service
public class ProfileImageStorageService {

    private static final Set<String> ALLOWED_EXTENSIONS = Set.of("jpg", "jpeg", "png", "webp");

    private final Path storageRoot;

    public ProfileImageStorageService(
            @Value("${app.profile-images.directory:./uploads/profile-images}") String storageDirectory) {
        this.storageRoot = Path.of(storageDirectory).toAbsolutePath().normalize();
    }

    public String store(MultipartFile file) {
        String extension = extensionOf(file.getOriginalFilename());
        if (!ALLOWED_EXTENSIONS.contains(extension)) {
            throw new BadRequestException("Profile image must be JPG, PNG, or WebP.");
        }

        String storedFileName = UUID.randomUUID() + "." + extension;
        Path destination = resolveSafe(storedFileName);

        try {
            Files.createDirectories(storageRoot);
            try (InputStream inputStream = file.getInputStream()) {
                Files.copy(inputStream, destination, StandardCopyOption.REPLACE_EXISTING);
            }
            return storedFileName;
        } catch (IOException exception) {
            throw new BadRequestException("Profile image could not be stored.");
        }
    }

    public Resource load(String storedFileName) {
        Path imagePath = resolveSafe(storedFileName);
        if (!Files.isRegularFile(imagePath)) {
            throw new ResourceNotFoundException("Profile image not found.");
        }
        return new FileSystemResource(imagePath);
    }

    public String contentType(String storedFileName) {
        try {
            String contentType = Files.probeContentType(resolveSafe(storedFileName));
            return contentType == null ? "application/octet-stream" : contentType;
        } catch (IOException exception) {
            return "application/octet-stream";
        }
    }

    public void delete(String storedFileName) {
        if (storedFileName == null || storedFileName.isBlank()) {
            return;
        }

        try {
            Files.deleteIfExists(resolveSafe(storedFileName));
        } catch (IOException exception) {
            throw new BadRequestException("Profile image could not be deleted.");
        }
    }

    private Path resolveSafe(String storedFileName) {
        if (storedFileName == null || storedFileName.isBlank()) {
            throw new ResourceNotFoundException("Profile image not found.");
        }

        Path resolved = storageRoot.resolve(storedFileName).normalize();
        if (!resolved.startsWith(storageRoot)) {
            throw new BadRequestException("Invalid profile image path.");
        }
        return resolved;
    }

    private String extensionOf(String originalFileName) {
        if (originalFileName == null) {
            return "";
        }

        int separator = originalFileName.lastIndexOf('.');
        if (separator < 0 || separator == originalFileName.length() - 1) {
            return "";
        }
        return originalFileName.substring(separator + 1).toLowerCase(Locale.ROOT);
    }
}
