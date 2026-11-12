<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.hydrostock.model.Material"%>
<%@ page import="com.hydrostock.model.Notification"%>
<%@ include file="/includes/header.jsp" %>
<%@ include file="/includes/sidebar.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold text-dark mb-1">Executive Plant Dashboard</h3>
        <p class="text-muted mb-0" style="font-size: 0.88rem;">Overview of hydroelectric plant inventory, procurement, and maintenance</p>
    </div>
    <div class="d-flex gap-2">
        <a href="<%= appPath %>/inventory/inward" class="btn btn-outline-primary btn-sm"><i class="fa-solid fa-plus me-1"></i> Stock Inward</a>
        <a href="<%= appPath %>/purchase/create" class="btn btn-primary btn-sm" style="background-color: #00A896; border-color: #00A896;"><i class="fa-solid fa-cart-plus me-1"></i> New Purchase Order</a>
    </div>
</div>

<!-- KPI Cards Row -->
<div class="row g-3 mb-4">
    <div class="col-md-3">
        <div class="kpi-card">
            <div>
                <div class="kpi-value"><%= request.getAttribute("totalMaterials") != null ? request.getAttribute("totalMaterials") : "0" %></div>
                <div class="kpi-label">Active Spares &amp; Items</div>
            </div>
            <div class="kpi-icon icon-blue">
                <i class="fa-solid fa-boxes-stacked"></i>
            </div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="kpi-card">
            <div>
                <div class="kpi-value text-danger"><%= request.getAttribute("lowStockCount") != null ? request.getAttribute("lowStockCount") : "0" %></div>
                <div class="kpi-label">Low Stock Alerts</div>
            </div>
            <div class="kpi-icon icon-red">
                <i class="fa-solid fa-triangle-exclamation"></i>
            </div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="kpi-card">
            <div>
                <div class="kpi-value text-warning"><%= request.getAttribute("openPOCount") != null ? request.getAttribute("openPOCount") : "0" %></div>
                <div class="kpi-label">Active Purchase Orders</div>
            </div>
            <div class="kpi-icon icon-amber">
                <i class="fa-solid fa-file-invoice"></i>
            </div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="kpi-card">
            <div>
                <div class="kpi-value" style="color: #00A896;">
                    ₹ <%= String.format("%,.0f", (Double) (request.getAttribute("totalValuation") != null ? request.getAttribute("totalValuation") : 0.0)) %>
                </div>
                <div class="kpi-label">Total Inventory Valuation</div>
            </div>
            <div class="kpi-icon icon-cyan">
                <i class="fa-solid fa-indian-rupee-sign"></i>
            </div>
        </div>
    </div>
</div>

<!-- Charts & Alerts Row -->
<div class="row g-4 mb-4">
    <!-- Chart Column -->
    <div class="col-lg-8">
        <div class="panel-card h-100">
            <div class="panel-header">
                <h5 class="panel-title"><i class="fa-solid fa-chart-area me-2 text-primary"></i>Stock &amp; Procurement Valuation Analytics</h5>
                <span class="badge bg-light text-dark border">FY 2026-2027</span>
            </div>
            <div class="p-4">
                <canvas id="analyticsChart" style="max-height: 280px;"></canvas>
            </div>
        </div>
    </div>

    <!-- Notifications / Alerts Column -->
    <div class="col-lg-4">
        <div class="panel-card h-100">
            <div class="panel-header">
                <h5 class="panel-title"><i class="fa-solid fa-bell me-2 text-warning"></i>Recent Plant Alerts</h5>
                <span class="badge bg-danger rounded-pill"><%= request.getAttribute("lowStockCount") %> Critical</span>
            </div>
            <div class="p-3">
                <%
                    List<Notification> notifs = (List<Notification>) request.getAttribute("notifications");
                    if (notifs != null && !notifs.isEmpty()) {
                        for (Notification n : notifs) {
                %>
                    <div class="d-flex align-items-start gap-3 p-2 mb-2 rounded bg-light border-start border-3 <%= n.getTitle().contains("CRITICAL") || n.getTitle().contains("LOW") ? "border-danger" : "border-info" %>">
                        <i class="fa-solid <%= n.getTitle().contains("CRITICAL") || n.getTitle().contains("LOW") ? "fa-circle-exclamation text-danger" : "fa-info text-info" %> mt-1"></i>
                        <div>
                            <div class="fw-semibold text-dark" style="font-size: 0.85rem;"><%= n.getTitle() %></div>
                            <div class="text-muted" style="font-size: 0.78rem;"><%= n.getMessage() %></div>
                        </div>
                    </div>
                <%
                        }
                    } else {
                %>
                    <div class="text-center text-muted py-4">No active system alerts</div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<!-- Low Stock Critical Spares Table -->
<div class="panel-card">
    <div class="panel-header">
        <h5 class="panel-title text-danger"><i class="fa-solid fa-triangle-exclamation me-2"></i>Critical Low-Stock Spares Requiring Indent</h5>
        <a href="<%= appPath %>/inventory/alerts" class="btn btn-sm btn-outline-danger">View All Low Stock</a>
    </div>
    <div class="table-responsive">
        <table class="table table-hover mb-0">
            <thead>
                <tr>
                    <th>Material Code</th>
                    <th>Spare / Material Name</th>
                    <th>Category</th>
                    <th>Current Balance</th>
                    <th>Safety Threshold</th>
                    <th>Rack Location</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Material> lowList = (List<Material>) request.getAttribute("lowStockList");
                    if (lowList != null && !lowList.isEmpty()) {
                        for (Material m : lowList) {
                %>
                    <tr>
                        <td><span class="badge bg-light text-dark border font-monospace"><%= m.getMaterialCode() %></span></td>
                        <td class="fw-semibold"><%= m.getMaterialName() %></td>
                        <td><%= m.getCategoryName() %></td>
                        <td><span class="badge bg-danger fs-6"><%= m.getCurrentStock() %> <%= m.getUnitOfMeasure() %></span></td>
                        <td><%= m.getMinStockLevel() %> <%= m.getUnitOfMeasure() %></td>
                        <td><i class="fa-solid fa-location-dot text-muted me-1"></i><%= m.getLocationRack() %></td>
                        <td>
                            <a href="<%= appPath %>/purchase/create" class="btn btn-sm btn-primary py-0" style="font-size: 0.8rem; background-color: #00A896; border-color: #00A896;">
                                <i class="fa-solid fa-cart-plus me-1"></i> Order Now
                            </a>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="7" class="text-center text-muted py-4">All plant spares and materials are well above minimum safety levels.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const ctx = document.getElementById('analyticsChart').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Turbine Spares', 'Hydraulic Valves', 'Generator & Coils', 'Dielectric Oils', 'Sensors & RTD', 'Fasteners/Flanges'],
            datasets: [{
                label: 'Stock Value (in Lakhs ₹)',
                data: [6.8, 1.36, 1.44, 7.53, 3.98, 0.64],
                backgroundColor: [
                    'rgba(13, 59, 102, 0.85)',
                    'rgba(0, 168, 150, 0.85)',
                    'rgba(2, 128, 144, 0.85)',
                    'rgba(244, 162, 97, 0.85)',
                    'rgba(42, 157, 143, 0.85)',
                    'rgba(113, 128, 150, 0.85)'
                ],
                borderRadius: 6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: { callback: function(value) { return '₹ ' + value + ' L'; } }
                }
            }
        }
    });
});
</script>

<%@ include file="/includes/footer.jsp" %>
