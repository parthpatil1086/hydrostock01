<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hydrostock.model.User"%>
<%
    User navUser = (User) session.getAttribute("currentUser");
    String ctx = request.getContextPath();
    String currentRole = navUser != null ? navUser.getRoleName() : "";
    String requestUri = (String) request.getAttribute("javax.servlet.forward.request_uri");
    if (requestUri == null) requestUri = request.getRequestURI();
    String currentPath = requestUri.startsWith(ctx) ? requestUri.substring(ctx.length()) : request.getServletPath();
%>
<aside class="sidebar">
    <div class="sidebar-brand">
        <i class="fa-solid fa-water brand-icon"></i>
        <div class="brand-text">
            <h4>HYDROSTOCK</h4>
            <span>Power Plant ERP</span>
        </div>
    </div>

    <ul class="sidebar-menu">
        <% if ("ADMIN".equalsIgnoreCase(currentRole)) { %>
            <li class="menu-header">1. ADMIN PANEL</li>
            <li class="<%= "/admin/dashboard".equals(currentPath) ? "active" : "" %>"><a href="<%= ctx %>/admin/dashboard"><i class="fa-solid fa-chart-line"></i>Dashboard</a></li>
            <li class="<%= "/admin/users".equals(currentPath) ? "active" : "" %>"><a href="<%= ctx %>/admin/users"><i class="fa-solid fa-users-gear"></i>User Management</a></li>
            <li class="<%= "/admin/equipment".equals(currentPath) ? "active" : "" %>"><a href="<%= ctx %>/admin/equipment"><i class="fa-solid fa-screwdriver-wrench"></i>Plant Equipment</a></li>
            <li class="<%= "/admin/reports".equals(currentPath) ? "active" : "" %>"><a href="<%= ctx %>/admin/reports"><i class="fa-solid fa-file-waveform"></i>System Reports</a></li>
        <% } %>

        <% if ("INVENTORY_MANAGER".equalsIgnoreCase(currentRole) || "PLANT_ENGINEER".equalsIgnoreCase(currentRole)) { %>
            <li class="menu-header">2. INVENTORY PANEL</li>
            <li class="<%= "/inventory/materials".equals(currentPath) ? "active" : "" %>"><a href="<%= ctx %>/inventory/materials"><i class="fa-solid fa-boxes-stacked"></i>Material Catalog</a></li>
            <li class="<%= "/inventory/categories".equals(currentPath) ? "active" : "" %>"><a href="<%= ctx %>/inventory/categories"><i class="fa-solid fa-layer-group"></i>Material Categories</a></li>
            <li class="<%= "/inventory/inward".equals(currentPath) ? "active" : "" %>"><a href="<%= ctx %>/inventory/inward"><i class="fa-solid fa-arrow-down-long"></i>Stock Inward</a></li>
            <li class="<%= "/inventory/outward".equals(currentPath) ? "active" : "" %>"><a href="<%= ctx %>/inventory/outward"><i class="fa-solid fa-arrow-up-long"></i>Stock Outward</a></li>
            <li class="<%= "/inventory/alerts".equals(currentPath) ? "active" : "" %>"><a href="<%= ctx %>/inventory/alerts"><i class="fa-solid fa-triangle-exclamation"></i>Low Stock Alerts</a></li>
            <li class="<%= "/inventory/history".equals(currentPath) ? "active" : "" %>"><a href="<%= ctx %>/inventory/history"><i class="fa-solid fa-clock-rotate-left"></i>Stock History</a></li>
        <% } %>

        <% if ("PURCHASE_MANAGER".equalsIgnoreCase(currentRole)) { %>
            <li class="menu-header">3. PURCHASE & BILLING</li>
            <li class="<%= "/purchase/create".equals(currentPath) ? "active" : "" %>"><a href="<%= ctx %>/purchase/create"><i class="fa-solid fa-cart-plus"></i>Create Purchase Order</a></li>
            <li class="<%= "/purchase/orders".equals(currentPath) || "/purchase/view".equals(currentPath) ? "active" : "" %>"><a href="<%= ctx %>/purchase/orders"><i class="fa-solid fa-file-invoice"></i>Purchase Orders</a></li>
            <li class="<%= "/purchase/generate-bill".equals(currentPath) ? "active" : "" %>"><a href="<%= ctx %>/purchase/generate-bill"><i class="fa-solid fa-calculator"></i>Generate GST Bill</a></li>
            <li class="<%= "/purchase/billing".equals(currentPath) || "/purchase/invoice-print".equals(currentPath) ? "active" : "" %>"><a href="<%= ctx %>/purchase/billing"><i class="fa-solid fa-receipt"></i>Invoices &amp; Payments</a></li>
        <% } %>

        <% if ("SUPPLIER".equalsIgnoreCase(currentRole)) { %>
            <li class="menu-header">4. SUPPLIER PORTAL</li>
            <li class="<%= "/supplier/portal".equals(currentPath) ? "active" : "" %>"><a href="<%= ctx %>/supplier/portal"><i class="fa-solid fa-house-chimney"></i>Supplier Overview</a></li>
            <li class="<%= "/supplier/orders".equals(currentPath) ? "active" : "" %>"><a href="<%= ctx %>/supplier/orders"><i class="fa-solid fa-dolly"></i>Purchase Orders</a></li>
            <li class="<%= "/supplier/invoices".equals(currentPath) ? "active" : "" %>"><a href="<%= ctx %>/supplier/invoices"><i class="fa-solid fa-file-invoice-dollar"></i>Supplier Bills</a></li>
        <% } %>
    </ul>

    <div class="sidebar-user">
        <div class="user-avatar">
            <%= navUser != null && navUser.getFullName() != null ? navUser.getFullName().substring(0, 1).toUpperCase() : "U" %>
        </div>
        <div class="user-info text-truncate">
            <div class="user-name text-truncate"><%= navUser != null ? navUser.getFullName() : "User" %></div>
            <div class="user-role"><%= currentRole %></div>
        </div>
    </div>
</aside>
