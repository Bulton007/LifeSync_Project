package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.Category.CategoryRequest;
import com.lifesync_project.LifeSyncBackend.dto.Category.CategoryResponse;
import com.lifesync_project.LifeSyncBackend.entity.Categories;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.repository.CategoryRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class CategoryService {

    private final CategoryRepository categoryRepository;

    /**
     * Create Category
     */
    public CategoryResponse createCategory(CategoryRequest request) {

        if (categoryRepository.existsByName(request.getName())) {
            throw new RuntimeException("Category already exists.");
        }

        Categories category = Categories.builder()
                .name(request.getName())
                .description(request.getDescription())
                .icon(request.getIcon())
                .color(request.getColor())
                .active(true)
                .build();

        return mapToResponse(categoryRepository.save(category));
    }

    /**
     * Update Category
     */
    public CategoryResponse updateCategory(Long id, CategoryRequest request) {

        Categories category = categoryRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Category not found."));

        category.setName(request.getName());
        category.setDescription(request.getDescription());
        category.setIcon(request.getIcon());
        category.setColor(request.getColor());

        return mapToResponse(categoryRepository.save(category));
    }

    /**
     * Delete Category
     */
    public void deleteCategory(Long id) {

        Categories category = categoryRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Category not found."));

        categoryRepository.delete(category);
    }

    /**
     * Get Category By Id
     */
    public CategoryResponse getCategoryById(Long id) {

        Categories category = categoryRepository.findById(id)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Category not found."));

        return mapToResponse(category);
    }

    /**
     * Get All Categories
     */
    public List<CategoryResponse> getCategories() {

        return categoryRepository.findAll()
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    /**
     * Entity -> Response
     */
    private CategoryResponse mapToResponse(Categories category) {

        return CategoryResponse.builder()
                .id(category.getId())
                .name(category.getName())
                .description(category.getDescription())
                .icon(category.getIcon())
                .color(category.getColor())
                .active(category.getActive())
                .createdAt(category.getCreatedAt())
                .updatedAt(category.getUpdatedAt())
                .build();
    }

}