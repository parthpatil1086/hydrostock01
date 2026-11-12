<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.hydrostock.model.Category"%>
<%@ include file="/includes/header.jsp" %>
<%@ include file="/includes/sidebar.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold text-dark mb-1">Material Categories</h3>
        <p class="text-muted mb-0" style="font-size: 0.88rem;">Classification of plant mechanical, electrical, and hydraulic spares</p>
    </div>
    <button class="btn btn-primary btn-sm" style="background-color: #00A896; border-color: #00A896;" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
        <i class="fa-solid fa-plus me-1"></i> Add Category
    </button>
</div>

<div class="panel-card">
    <div class="table-responsive">
        <table class="table table-hover mb-0">
            <thead>
                <tr>
                    <th>Category ID</th>
                    <th>Category Name</th>
                    <th>Description</th>
                    <th class="text-center">Active Materials Count</th>
                    <th class="text-end">Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Category> categories = (List<Category>) request.getAttribute("categories");
                    if (categories != null) {
                        for (Category c : categories) {
                %>
                    <tr>
                        <td>#<%= c.getCategoryId() %></td>
                        <td class="fw-semibold text-dark"><%= c.getCategoryName() %></td>
                        <td class="text-muted" style="max-width: 350px;"><%= c.getDescription() %></td>
                        <td class="text-center">
                            <span class="badge bg-light text-dark border fs-6"><%= c.getMaterialCount() %></span>
                        </td>
                        <td class="text-end">
                            <a href="<%= appPath %>/inventory/categories?action=delete&id=<%= c.getCategoryId() %>" class="btn btn-sm btn-outline-danger py-0" onclick="return confirm('Delete this category?');">
                                <i class="fa-solid fa-trash-can"></i>
                            </a>
                        </td>
                    </tr>
                <%
                        }
                    }
                %>
            </tbody>
        </table>
    </div>
</div>

<!-- Add Category Modal -->
<div class="modal fade" id="addCategoryModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="<%= appPath %>/inventory/categories" method="POST">
                <input type="hidden" name="action" value="add">
                <div class="modal-header bg-dark text-white">
                    <h5 class="modal-title fs-6"><i class="fa-solid fa-folder-plus me-2 text-info"></i>Create Material Category</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Category Name *</label>
                        <input type="text" name="categoryName" class="form-control" required placeholder="e.g. Turbine Governor Hydraulics">
                    </div>
                    <div class="mb-2">
                        <label class="form-label fw-semibold">Description</label>
                        <textarea name="description" class="form-control" rows="3" placeholder="Category purpose and scope"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary btn-sm" style="background-color: #00A896; border-color: #00A896;">Save Category</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>
