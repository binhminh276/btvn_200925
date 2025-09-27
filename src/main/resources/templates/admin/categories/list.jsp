<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Category Management</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <style>
        .img-thumbnail-small {
            width: 60px;
            height: 60px;
            object-fit: cover;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h4 class="mb-0">
                            <i class="fas fa-list"></i> Category Management
                        </h4>
                        <button type="button" class="btn btn-primary" id="btnAddCategory">
                            <i class="fas fa-plus"></i> Add Category
                        </button>
                    </div>
                    <div class="card-body">
                        <!-- Alert messages -->
                        <div id="alertMessage" class="alert" style="display: none;"></div>
                        
                        <!-- Categories Table -->
                        <div class="table-responsive">
                            <table class="table table-striped table-hover" id="categoryTable">
                                <thead class="table-dark">
                                    <tr>
                                        <th>ID</th>
                                        <th>Icon</th>
                                        <th>Category Name</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="categoryTableBody">
                                    <!-- Data will be loaded here via Ajax -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Category Modal -->
    <div class="modal fade" id="addCategoryModal" tabindex="-1" aria-labelledby="addCategoryModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addCategoryModalLabel">
                        <i class="fas fa-plus"></i> Add Category
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="addCategoryForm" enctype="multipart/form-data">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="addCategoryName" class="form-label">Category Name</label>
                            <input type="text" class="form-control" id="addCategoryName" name="categoryName" required>
                        </div>
                        <div class="mb-3">
                            <label for="addIcon" class="form-label">Icon</label>
                            <input type="file" class="form-control" id="addIcon" name="icon" accept="image/*" required>
                        </div>
                        <div class="mb-3" id="addPreviewContainer" style="display: none;">
                            <label class="form-label">Preview</label>
                            <div>
                                <img id="addIconPreview" src="" alt="Preview" class="img-thumbnail-small">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Save Category
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Category Modal -->
    <div class="modal fade" id="editCategoryModal" tabindex="-1" aria-labelledby="editCategoryModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editCategoryModalLabel">
                        <i class="fas fa-edit"></i> Edit Category
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="editCategoryForm" enctype="multipart/form-data">
                    <div class="modal-body">
                        <input type="hidden" id="editCategoryId" name="id">
                        <div class="mb-3">
                            <label for="editCategoryName" class="form-label">Category Name</label>
                            <input type="text" class="form-control" id="editCategoryName" name="categoryName" required>
                        </div>
                        <div class="mb-3">
                            <label for="editIcon" class="form-label">Icon (Leave empty to keep current)</label>
                            <input type="file" class="form-control" id="editIcon" name="icon" accept="image/*">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Current Icon</label>
                            <div>
                                <img id="currentIcon" src="" alt="Current Icon" class="img-thumbnail-small">
                            </div>
                        </div>
                        <div class="mb-3" id="editPreviewContainer" style="display: none;">
                            <label class="form-label">New Preview</label>
                            <div>
                                <img id="editIconPreview" src="" alt="Preview" class="img-thumbnail-small">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-warning">
                            <i class="fas fa-save"></i> Update Category
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteCategoryModal" tabindex="-1" aria-labelledby="deleteCategoryModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title text-danger" id="deleteCategoryModalLabel">
                        <i class="fas fa-trash"></i> Delete Category
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center">
                        <i class="fas fa-exclamation-triangle text-warning" style="font-size: 3rem;"></i>
                        <h4 class="mt-3">Are you sure?</h4>
                        <p>Do you want to delete the category "<span id="deleteCategoryName" class="fw-bold"></span>"?</p>
                        <p class="text-muted">This action cannot be undone.</p>
                    </div>
                    <input type="hidden" id="deleteCategoryId">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteBtn">
                        <i class="fas fa-trash"></i> Delete
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        const contextPath = '${pageContext.request.contextPath}';
        
        $(document).ready(function() {
            loadCategories();
            
            // Add category button click
            $('#btnAddCategory').click(function() {
                $('#addCategoryModal').modal('show');
            });
            
            // File preview for add modal
            $('#addIcon').change(function() {
                previewImage(this, '#addIconPreview', '#addPreviewContainer');
            });
            
            // File preview for edit modal
            $('#editIcon').change(function() {
                previewImage(this, '#editIconPreview', '#editPreviewContainer');
            });
            
            // Add category form submit
            $('#addCategoryForm').submit(function(e) {
                e.preventDefault();
                addCategory();
            });
            
            // Edit category form submit
            $('#editCategoryForm').submit(function(e) {
                e.preventDefault();
                updateCategory();
            });
            
            // Confirm delete
            $('#confirmDeleteBtn').click(function() {
                deleteCategory();
            });
        });
        
        // Load categories function
        function loadCategories() {
            $.ajax({
                url: contextPath + '/api/category',
                type: 'GET',
                dataType: 'json',
                success: function(response) {
                    const categories = response.success ? response.data : response;
                    displayCategories(categories);
                },
                error: function(xhr, status, error) {
                    showAlert('Error loading categories: ' + error, 'danger');
                }
            });
        }
        
        // Display categories in table
        function displayCategories(categories) {
            const tbody = $('#categoryTableBody');
            tbody.empty();
            
            if (categories && categories.length > 0) {
                categories.forEach(function(category) {
                    const row = `
                        <tr>
                            <td>${category.categoryId}</td>
                            <td>
                                <img src="${contextPath}/images/${category.icon}" 
                                     alt="${category.categoryName}" 
                                     class="img-thumbnail-small"
                                     onerror="this.src='${contextPath}/images/default.png'">
                            </td>
                            <td>${category.categoryName}</td>
                            <td>
                                <button class="btn btn-sm btn-outline-warning me-1" 
                                        onclick="editCategory(${category.categoryId})"
                                        title="Edit">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button class="btn btn-sm btn-outline-danger" 
                                        onclick="showDeleteModal(${category.categoryId}, '${category.categoryName}')"
                                        title="Delete">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    `;
                    tbody.append(row);
                });
            } else {
                tbody.append('<tr><td colspan="4" class="text-center">No categories found</td></tr>');
            }
        }
        
        // Preview image function
        function previewImage(input, previewId, containerId) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    $(previewId).attr('src', e.target.result);
                    $(containerId).show();
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
        
        // Add category function
        function addCategory() {
            const formData = new FormData($('#addCategoryForm')[0]);
            
            $.ajax({
                url: contextPath + '/api/category/addCategory',
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function(response) {
                    if (response.success) {
                        showAlert('Category added successfully!', 'success');
                        $('#addCategoryModal').modal('hide');
                        $('#addCategoryForm')[0].reset();
                        $('#addPreviewContainer').hide();
                        loadCategories();
                    } else {
                        showAlert('Error: ' + response.message, 'danger');
                    }
                },
                error: function(xhr, status, error) {
                    showAlert('Error adding category: ' + error, 'danger');
                }
            });
        }
        
        // Edit category function
        function editCategory(categoryId) {
            $.ajax({
                url: contextPath + '/api/category/getCategory',
                type: 'POST',
                data: { id: categoryId },
                success: function(response) {
                    const category = response.success ? response.data : response;
                    if (category) {
                        $('#editCategoryId').val(category.categoryId);
                        $('#editCategoryName').val(category.categoryName);
                        $('#currentIcon').attr('src', contextPath + '/images/' + category.icon);
                        $('#editPreviewContainer').hide();
                        $('#editCategoryModal').modal('show');
                    }
                },
                error: function(xhr, status, error) {
                    showAlert('Error loading category: ' + error, 'danger');
                }
            });
        }
        
        // Update category function
        function updateCategory() {
            const formData = new FormData($('#editCategoryForm')[0]);
            
            $.ajax({
                url: contextPath + '/api/category/editCategory',
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function(response) {
                    if (response.success) {
                        showAlert('Category updated successfully!', 'success');
                        $('#editCategoryModal').modal('hide');
                        loadCategories();
                    } else {
                        showAlert('Error: ' + response.message, 'danger');
                    }
                },
                error: function(xhr, status, error) {
                    showAlert('Error updating category: ' + error, 'danger');
                }
            });
        }
        
        // Show delete modal
        function showDeleteModal(categoryId, categoryName) {
            $('#deleteCategoryId').val(categoryId);
            $('#deleteCategoryName').text(categoryName);
            $('#deleteCategoryModal').modal('show');
        }
        
        // Delete category function
        function deleteCategory() {
            const categoryId = $('#deleteCategoryId').val();
            
            $.ajax({
                url: contextPath + '/api/category/deleteCategory',
                type: 'POST',
                data: { id: categoryId },
                success: function(response) {
                    if (response.success) {
                        showAlert('Category deleted successfully!', 'success');
                        $('#deleteCategoryModal').modal('hide');
                        loadCategories();
                    } else {
                        showAlert('Error: ' + response.message, 'danger');
                    }
                },
                error: function(xhr, status, error) {
                    showAlert('Error deleting category: ' + error, 'danger');
                }
            });
        }
        
        // Show alert message
        function showAlert(message, type) {
            const alertDiv = $('#alertMessage');
            alertDiv.removeClass().addClass(`alert alert-${type} alert-dismissible fade show`);
            alertDiv.html(`
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            `);
            alertDiv.show();
            
            // Auto hide after 5 seconds
            setTimeout(function() {
                alertDiv.fadeOut();
            }, 5000);
        }
    </script>
</body>
</html>