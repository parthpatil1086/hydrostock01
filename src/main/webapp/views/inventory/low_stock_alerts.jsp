<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.hydrostock.model.Material"%>
<%@ include file="/includes/header.jsp" %>
<%@ include file="/includes/sidebar.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold text-dark mb-1">Low Stock Safety Alerts</h3>
        <p class="text-muted mb-0" style="font-size: 0.88rem;">Spares below minimum operating inventory levels requiring urgent purchase requisition</p>
    </div>
    <a href="<%= appPath %>/purchase/create" class="btn btn-primary btn-sm" style="background-color: #00A896; border-color: #00A896;">
        <i class="fa-solid fa-cart-plus me-1"></i> Generate Purchase Indent
    </a>
</div>

<div class="panel-card">
    <div class="panel-header bg-danger text-white">
        <h5 class="panel-title text-white"><i class="fa-solid fa-triangle-exclamation me-2"></i>Critical Inventory Alerts</h5>
        <span class="badge bg-white text-danger fw-bold"><%= ((List) request.getAttribute("lowStock")).size() %> Items Under Safety Buffer</span>
    </div>
    <div class="table-responsive">
        <table class="table table-hover mb-0">
            <thead>
                <tr>
                    <th>Item Code</th>
                    <th>Material / Spare Name</th>
                    <th>Category</th>
                    <th class="text-center">Current Stock</th>
                    <th class="text-center">Min Threshold</th>
                    <th class="text-center">Deficit</th>
                    <th>Storage Location</th>
                    <th class="text-end">Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Material> lowStock = (List<Material>) request.getAttribute("lowStock");
                    if (lowStock != null && !lowStock.isEmpty()) {
                        for (Material m : lowStock) {
                            int deficit = m.getMinStockLevel() - m.getCurrentStock();
                %>
                    <tr>
                        <td><code><%= m.getMaterialCode() %></code></td>
                        <td class="fw-semibold text-dark"><%= m.getMaterialName() %></td>
                        <td><%= m.getCategoryName() %></td>
                        <td class="text-center">
                            <span class="badge bg-danger fs-6"><%= m.getCurrentStock() %> <%= m.getUnitOfMeasure() %></span>
                        </td>
                        <td class="text-center fw-semibold"><%= m.getMinStockLevel() %> <%= m.getUnitOfMeasure() %></td>
                        <td class="text-center text-danger fw-bold"><%= deficit > 0 ? "-" + deficit : "0" %> <%= m.getUnitOfMeasure() %></td>
                        <td><i class="fa-solid fa-location-dot text-muted me-1"></i><%= m.getLocationRack() %></td>
                        <td class="text-end">
                            <a href="<%= appPath %>/purchase/create" class="btn btn-sm btn-primary py-1" style="background-color: #00A896; border-color: #00A896;">
                                <i class="fa-solid fa-cart-plus me-1"></i> Raise PO
                            </a>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="8" class="text-center text-muted py-4">All plant materials are above minimum stock levels.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>
