<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.hydrostock.model.PurchaseOrder"%>
<%@ include file="/includes/header.jsp" %>
<%@ include file="/includes/sidebar.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold text-dark mb-1">Purchase Orders Management</h3>
        <p class="text-muted mb-0" style="font-size: 0.88rem;">Track procurement lifecycles from creation, Chief Engineer approval to supplier dispatch</p>
    </div>
    <a href="<%= appPath %>/purchase/create" class="btn btn-primary btn-sm" style="background-color: #00A896; border-color: #00A896;">
        <i class="fa-solid fa-plus me-1"></i> New Purchase Order
    </a>
</div>

<div class="panel-card">
    <div class="table-responsive">
        <table class="table table-hover mb-0">
            <thead>
                <tr>
                    <th>PO Number</th>
                    <th>Supplier / Vendor</th>
                    <th>Order Date</th>
                    <th>Expected Delivery</th>
                    <th class="text-end">Total Amount (₹)</th>
                    <th>Status</th>
                    <th>Raised By</th>
                    <th class="text-end">Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<PurchaseOrder> orders = (List<PurchaseOrder>) request.getAttribute("orders");
                    if (orders != null && !orders.isEmpty()) {
                        for (PurchaseOrder po : orders) {
                %>
                    <tr>
                        <td>
                            <a href="<%= appPath %>/purchase/view?id=<%= po.getPoId() %>" class="fw-bold text-primary text-decoration-none">
                                <%= po.getPoNumber() %>
                            </a>
                        </td>
                        <td class="fw-semibold text-dark"><%= po.getSupplierName() %></td>
                        <td><%= po.getOrderDate() %></td>
                        <td><%= po.getExpectedDelivery() %></td>
                        <td class="text-end fw-bold">₹ <%= String.format("%,.2f", po.getTotalAmount()) %></td>
                        <td>
                            <span class="badge-status <%= "APPROVED".equalsIgnoreCase(po.getStatus()) || "DELIVERED".equalsIgnoreCase(po.getStatus()) ? "badge-approved" : ("PENDING".equalsIgnoreCase(po.getStatus()) ? "badge-pending" : "badge-dispatched") %>">
                                <%= po.getStatus() %>
                            </span>
                        </td>
                        <td class="small text-muted"><%= po.getCreatedBy() %></td>
                        <td class="text-end">
                            <div class="btn-group btn-group-sm">
                                <a href="<%= appPath %>/purchase/view?id=<%= po.getPoId() %>" class="btn btn-outline-secondary" title="View Items">
                                    <i class="fa-solid fa-eye"></i>
                                </a>

                                <% if ("PENDING".equalsIgnoreCase(po.getStatus())) { %>
                                    <form action="<%= appPath %>/purchase/status" method="POST" class="d-inline">
                                        <input type="hidden" name="poId" value="<%= po.getPoId() %>">
                                        <input type="hidden" name="status" value="APPROVED">
                                        <button type="submit" class="btn btn-outline-success" title="Approve Order">
                                            <i class="fa-solid fa-check"></i>
                                        </button>
                                    </form>
                                <% } %>

                                <% if ("APPROVED".equalsIgnoreCase(po.getStatus()) || "DISPATCHED".equalsIgnoreCase(po.getStatus())) { %>
                                    <form action="<%= appPath %>/purchase/status" method="POST" class="d-inline">
                                        <input type="hidden" name="poId" value="<%= po.getPoId() %>">
                                        <input type="hidden" name="status" value="DELIVERED">
                                        <button type="submit" class="btn btn-outline-primary" title="Mark Delivered &amp; Ready for Inward">
                                            <i class="fa-solid fa-box-open"></i>
                                        </button>
                                    </form>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="8" class="text-center text-muted py-4">No purchase orders found.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>
