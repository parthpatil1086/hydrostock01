<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.hydrostock.model.User"%>
<%@ include file="/includes/header.jsp" %>
<%@ include file="/includes/sidebar.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold text-dark mb-1">User &amp; Plant Staff Management</h3>
        <p class="text-muted mb-0" style="font-size: 0.88rem;">Manage system user accounts, engineers, storekeepers, and roles</p>
    </div>
    <button class="btn btn-primary btn-sm" style="background-color: #00A896; border-color: #00A896;" data-bs-toggle="modal" data-bs-target="#addUserModal">
        <i class="fa-solid fa-user-plus me-1"></i> Add New Employee / User
    </button>
</div>

<div class="panel-card">
    <div class="table-responsive">
        <table class="table table-hover mb-0">
            <thead>
                <tr>
                    <th>User ID</th>
                    <th>Full Name</th>
                    <th>Username</th>
                    <th>Role Designation</th>
                    <th>Contact Email</th>
                    <th>Phone</th>
                    <th>Status</th>
                    <th class="text-end">Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<User> list = (List<User>) request.getAttribute("userList");
                    if (list != null && !list.isEmpty()) {
                        for (User u : list) {
                %>
                    <tr>
                        <td>#<%= u.getUserId() %></td>
                        <td class="fw-semibold text-dark"><%= u.getFullName() %></td>
                        <td><code><%= u.getUsername() %></code></td>
                        <td>
                            <span class="badge <%= "ADMIN".equalsIgnoreCase(u.getRoleName()) ? "bg-primary" : "bg-secondary" %>">
                                <%= u.getRoleName() %>
                            </span>
                        </td>
                        <td><%= u.getEmail() %></td>
                        <td><%= u.getPhone() != null ? u.getPhone() : "-" %></td>
                        <td>
                            <span class="badge-status <%= "ACTIVE".equalsIgnoreCase(u.getStatus()) ? "badge-approved" : "badge-low-stock" %>">
                                <%= u.getStatus() %>
                            </span>
                        </td>
                        <td class="text-end">
                            <% if (u.getUserId() != 1) { %>
                                <a href="<%= appPath %>/admin/users?action=delete&id=<%= u.getUserId() %>" class="btn btn-sm btn-outline-danger py-0" onclick="return confirm('Are you sure you want to deactivate/delete this user?');">
                                    <i class="fa-solid fa-trash-can"></i>
                                </a>
                            <% } else { %>
                                <span class="badge bg-light text-muted border">System Master</span>
                            <% } %>
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

<!-- Add User Modal -->
<div class="modal fade" id="addUserModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="<%= appPath %>/admin/users" method="POST">
                <input type="hidden" name="action" value="add">
                <div class="modal-header bg-dark text-white">
                    <h5 class="modal-title fs-6"><i class="fa-solid fa-user-plus me-2 text-info"></i>Register Plant Staff / User</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Full Name *</label>
                        <input type="text" name="fullName" class="form-control" required placeholder="e.g. Ramesh S. Patil">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Username *</label>
                        <input type="text" name="username" class="form-control" required placeholder="Unique username">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Temporary Password *</label>
                        <input type="password" name="password" class="form-control" required placeholder="Password">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Role Designation *</label>
                        <select name="roleId" class="form-select" required>
                            <option value="1">ADMIN (System Administrator)</option>
                            <option value="2">INVENTORY_MANAGER (Store Officer)</option>
                            <option value="3">PURCHASE_MANAGER (Accounts &amp; Billing)</option>
                            <option value="4">SUPPLIER (Equipment Vendor)</option>
                            <option value="5" selected>PLANT_ENGINEER (Operations &amp; Maintenance)</option>
                        </select>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Email *</label>
                            <input type="email" name="email" class="form-control" required placeholder="staff@hydrostock.power.gov">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Mobile Number</label>
                            <input type="text" name="phone" class="form-control" placeholder="+91 9822000000">
                        </div>
                    </div>
                    <div class="mb-2">
                        <label class="form-label fw-semibold">Account Status</label>
                        <select name="status" class="form-select">
                            <option value="ACTIVE" selected>ACTIVE</option>
                            <option value="INACTIVE">INACTIVE</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary btn-sm" style="background-color: #00A896; border-color: #00A896;">Save User Account</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>
