<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hydrostock.model.PurchaseOrder"%>
<%@ page import="com.hydrostock.model.PurchaseItem"%>
<%@ include file="/includes/header.jsp" %>
<%@ include file="/includes/sidebar.jsp" %>

<%
    PurchaseOrder po = (PurchaseOrder) request.getAttribute("po");
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold text-dark mb-1">Purchase Order: <%= po != null ? po.getPoNumber() : "" %></h3>
        <p class="text-muted mb-0" style="font-size: 0.88rem;">Detailed line items and supplier allocation</p>
    </div>
    <div class="d-flex gap-2">
        <a href="<%= appPath %>/purchase/orders" class="btn btn-outline-secondary btn-sm"><i class="fa-solid fa-arrow-left me-1"></i> Back to Orders</a>
        <button class="btn btn-outline-primary btn-sm" onclick="window.print()"><i class="fa-solid fa-print me-1"></i> Print PO</button>
    </div>
</div>

<% if (po != null) { %>
<div class="row g-4 mb-4">
    <div class="col-md-6">
        <div class="panel-card h-100 p-4">
            <h6 class="text-muted text-uppercase fw-bold mb-3" style="font-size: 0.78rem;">Vendor Profile</h6>
            <h5 class="fw-bold text-dark mb-1"><%= po.getSupplierName() %></h5>
            <div class="text-muted mb-2">GSTIN: <code><%= po.getSupplierGst() %></code></div>
            <div class="badge bg-light text-dark border">Verified Hydro Equipment Supplier</div>
        </div>
    </div>

    <div class="col-md-6">
        <div class="panel-card h-100 p-4">
            <h6 class="text-muted text-uppercase fw-bold mb-3" style="font-size: 0.78rem;">Order Metadata</h6>
            <div class="d-flex justify-content-between mb-1">
                <span class="text-muted">Order Date:</span>
                <span class="fw-semibold"><%= po.getOrderDate() %></span>
            </div>
            <div class="d-flex justify-content-between mb-1">
                <span class="text-muted">Target Delivery:</span>
                <span class="fw-semibold"><%= po.getExpectedDelivery() %></span>
            </div>
            <div class="d-flex justify-content-between mb-1">
                <span class="text-muted">Status:</span>
                <span class="badge bg-primary"><%= po.getStatus() %></span>
            </div>
            <div class="d-flex justify-content-between">
                <span class="text-muted">Approved By:</span>
                <span class="fw-semibold"><%= po.getApprovedBy() != null ? po.getApprovedBy() : "Pending Clearance" %></span>
            </div>
        </div>
    </div>
</div>

<div class="panel-card mb-4">
    <div class="panel-header">
        <h5 class="panel-title"><i class="fa-solid fa-list-check me-2 text-primary"></i>Items Breakdown</h5>
    </div>
    <div class="table-responsive">
        <table class="table table-hover mb-0">
            <thead class="table-light">
                <tr>
                    <th>#</th>
                    <th>Material Code</th>
                    <th>Description</th>
                    <th class="text-center">Quantity</th>
                    <th class="text-end">Unit Rate (₹)</th>
                    <th class="text-end">Subtotal (₹)</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (po.getItems() != null) {
                        int idx = 1;
                        for (PurchaseItem item : po.getItems()) {
                %>
                    <tr>
                        <td><%= idx++ %></td>
                        <td><code><%= item.getMaterialCode() %></code></td>
                        <td class="fw-semibold"><%= item.getMaterialName() %></td>
                        <td class="text-center"><%= item.getQuantity() %> <%= item.getUnitOfMeasure() %></td>
                        <td class="text-end">₹ <%= String.format("%,.2f", item.getUnitPrice()) %></td>
                        <td class="text-end fw-bold">₹ <%= String.format("%,.2f", item.getSubtotal()) %></td>
                    </tr>
                <%
                        }
                    }
                %>
            </tbody>
            <tfoot>
                <tr class="table-light">
                    <td colspan="5" class="text-end fw-bold fs-5">Total Order Value:</td>
                    <td class="text-end fw-bold fs-5 text-primary">₹ <%= String.format("%,.2f", po.getTotalAmount()) %></td>
                </tr>
            </tfoot>
        </table>
    </div>
</div>
<% } %>

<%@ include file="/includes/footer.jsp" %>
