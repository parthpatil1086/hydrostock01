<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.hydrostock.model.Supplier"%>
<%@ page import="com.hydrostock.model.PurchaseOrder"%>
<%@ page import="com.hydrostock.model.Bill"%>
<%@ include file="/includes/header.jsp" %>
<%@ include file="/includes/sidebar.jsp" %>

<%
    Supplier s = (Supplier) request.getAttribute("supplier");
    List<PurchaseOrder> orders = (List<PurchaseOrder>) request.getAttribute("orders");
    List<Bill> invoices = (List<Bill>) request.getAttribute("invoices");

    int pendingOrders = 0;
    double totalBilled = 0.0;
    if (orders != null) {
        for (PurchaseOrder po : orders) {
            if ("PENDING".equalsIgnoreCase(po.getStatus()) || "APPROVED".equalsIgnoreCase(po.getStatus())) {
                pendingOrders++;
            }
        }
    }
    if (invoices != null) {
        for (Bill b : invoices) {
            totalBilled += b.getGrandTotal();
        }
    }
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold text-dark mb-1">Supplier Portal: <%= s != null ? s.getCompanyName() : "Vendor Workspace" %></h3>
        <p class="text-muted mb-0" style="font-size: 0.88rem;">Hydroelectric Power Station Procurement &amp; Delivery Management</p>
    </div>
    <span class="badge bg-light text-dark border p-2">
        <i class="fa-solid fa-star text-warning me-1"></i> Supplier Rating: <strong><%= s != null ? s.getRating() : "4.8" %> / 5.0</strong>
    </span>
</div>

<!-- Supplier Metrics Row -->
<div class="row g-3 mb-4">
    <div class="col-md-4">
        <div class="kpi-card">
            <div>
                <div class="kpi-value text-primary"><%= orders != null ? orders.size() : 0 %></div>
                <div class="kpi-label">Total Purchase Orders Received</div>
            </div>
            <div class="kpi-icon icon-blue">
                <i class="fa-solid fa-dolly"></i>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="kpi-card">
            <div>
                <div class="kpi-value text-warning"><%= pendingOrders %></div>
                <div class="kpi-label">Pending Delivery / In Transit</div>
            </div>
            <div class="kpi-icon icon-amber">
                <i class="fa-solid fa-truck-fast"></i>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="kpi-card">
            <div>
                <div class="kpi-value" style="color: #00A896;">₹ <%= String.format("%,.0f", totalBilled) %></div>
                <div class="kpi-label">Total Invoiced Order Volume</div>
            </div>
            <div class="kpi-icon icon-cyan">
                <i class="fa-solid fa-wallet"></i>
            </div>
        </div>
    </div>
</div>

<!-- Recent Orders Table -->
<div class="panel-card mb-4">
    <div class="panel-header d-flex justify-content-between align-items-center">
        <h5 class="panel-title"><i class="fa-solid fa-file-contract me-2 text-primary"></i>Active Plant Supply Orders</h5>
        <a href="<%= appPath %>/supplier/orders" class="btn btn-outline-primary btn-sm">View All Orders</a>
    </div>
    <div class="table-responsive">
        <table class="table table-hover mb-0">
            <thead>
                <tr>
                    <th>PO Number</th>
                    <th>Issue Date</th>
                    <th>Target Delivery</th>
                    <th class="text-end">Total Amount (₹)</th>
                    <th>Current Status</th>
                    <th class="text-end">Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (orders != null && !orders.isEmpty()) {
                        for (PurchaseOrder po : orders) {
                %>
                    <tr>
                        <td><strong><%= po.getPoNumber() %></strong></td>
                        <td><%= po.getOrderDate() %></td>
                        <td><%= po.getExpectedDelivery() %></td>
                        <td class="text-end fw-bold">₹ <%= String.format("%,.2f", po.getTotalAmount()) %></td>
                        <td>
                            <span class="badge-status <%= "DELIVERED".equalsIgnoreCase(po.getStatus()) ? "badge-delivered" : ("DISPATCHED".equalsIgnoreCase(po.getStatus()) ? "badge-dispatched" : "badge-pending") %>">
                                <%= po.getStatus() %>
                            </span>
                        </td>
                        <td class="text-end">
                            <a href="<%= appPath %>/purchase/view?id=<%= po.getPoId() %>" class="btn btn-sm btn-outline-secondary py-0">View Details</a>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="6" class="text-center text-muted py-4">No orders currently assigned to your vendor profile.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>
