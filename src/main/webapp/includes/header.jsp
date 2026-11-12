<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hydrostock.model.User"%>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    String appPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HydroStock - Hydroelectric Power Plant Inventory & Billing</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome 6 Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <!-- Custom Theme Stylesheet -->
    <link href="<%= appPath %>/assets/css/style.css" rel="stylesheet">
</head>
<body>
<div class="app-wrapper">
    <!-- Sidebar Partial Included in Page -->
    <div class="main-wrapper">
        <header class="top-navbar">
            <div class="d-flex align-items-center gap-3">
                <span class="station-badge">
                    <span class="status-indicator"></span>
                    Warananagar Hydro Station (60 MW) - Active
                </span>
            </div>
            <div class="d-flex align-items-center gap-4">
                <div class="dropdown">
                    <button type="button" class="btn p-0 border-0 d-flex align-items-center text-decoration-none dropdown-toggle" id="userMenu" data-bs-toggle="dropdown" aria-expanded="false">
                        <div class="user-avatar me-2">
                            <%= currentUser != null && currentUser.getFullName() != null ? currentUser.getFullName().substring(0, 1).toUpperCase() : "U" %>
                        </div>
                        <div class="d-none d-md-block text-start">
                            <div class="fw-semibold text-dark" style="font-size: 0.88rem;">
                                <%= currentUser != null ? currentUser.getFullName() : "Guest" %>
                            </div>
                            <div class="text-muted" style="font-size: 0.75rem;">
                                <%= currentUser != null ? currentUser.getRoleName() : "Visitor" %>
                            </div>
                        </div>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow-sm">
                        <li><span class="dropdown-header">System Role: <%= currentUser != null ? currentUser.getRoleName() : "" %></span></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="<%= appPath %>/auth?action=logout"><i class="fa-solid fa-right-from-bracket me-2"></i>Sign Out</a></li>
                    </ul>
                </div>
            </div>
        </header>

        <div class="content-body">
            <% String flashMsg = request.getParameter("msg"); %>
            <% if (flashMsg != null && !flashMsg.trim().isEmpty()) { %>
                <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i> <%= flashMsg %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <% String flashErr = request.getParameter("error"); %>
            <% if (flashErr != null && !flashErr.trim().isEmpty()) { %>
                <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i> <%= flashErr %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
            <% String requestErr = (String) request.getAttribute("errorMessage"); %>
            <% if (requestErr != null && !requestErr.trim().isEmpty()) { %>
                <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i> <%= requestErr %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
