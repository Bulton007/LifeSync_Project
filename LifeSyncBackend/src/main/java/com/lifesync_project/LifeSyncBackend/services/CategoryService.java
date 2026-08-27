package com.lifesync_project.LifeSyncBackend.services;

import com.lifesync_project.LifeSyncBackend.dto.Category.CategoryRequest;
import com.lifesync_project.LifeSyncBackend.dto.Category.CategoryResponse;
import com.lifesync_project.LifeSyncBackend.entity.Categories;
import com.lifesync_project.LifeSyncBackend.exception.ResourceNotFoundException;
import com.lifesync_project.LifeSyncBackend.exception.DuplicateResourceException;
import com.lifesync_project.LifeSyncBackend.exception.BadRequestException;
import com.lifesync_project.LifeSyncBackend.repository.CategoryRepository;
import com.lifesync_project.LifeSyncBackend.repository.BudgetRepository;
import com.lifesync_project.LifeSyncBackend.repository.ExpenseRepository;
import com.lifesync_project.LifeSyncBackend.repository.IncomeRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class CategoryService {

    private final CategoryRepository categoryRepository;
    private final BudgetRepository budgetRepository;
    private final ExpenseRepository expenseRepository;
    private final IncomeRepository incomeRepository;

    /**
     * Create Category
     */
    public CategoryResponse createCategory(CategoryRequest request) {

        if (categoryRepository.existsByName(request.getName())) {
            throw new DuplicateResourceException("Category already exists.");
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

        categoryRepository.findByName(request.getName())
                .filter(existing -> !existing.getId().equals(id))
                .ifPresent(existing -> {
                    throw new DuplicateResourceException("Category already exists.");
                });

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

        if (budgetRepository.existsByCategoryId(id)
                || expenseRepository.existsByCategoryId(id)
                || incomeRepository.existsByCategoryId(id)) {
            throw new BadRequestException("Category is in use and cannot be deleted.");
        }

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
