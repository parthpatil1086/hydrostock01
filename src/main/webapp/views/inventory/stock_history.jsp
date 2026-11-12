<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.hydrostock.model.StockTransaction"%>
<%@ include file="/includes/header.jsp" %>
<%@ include file="/includes/sidebar.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold text-dark mb-1">Stock Movement Audit Ledger</h3>
        <p class="text-muted mb-0" style="font-size: 0.88rem;">Complete history of material inward receipts and outward plant maintenance issues</p>
    </div>
    <div class="d-flex gap-2">
        <a href="<%= appPath %>/inventory/inward" class="btn btn-outline-success btn-sm"><i class="fa-solid fa-arrow-down-long me-1"></i> Stock Inward</a>
        <a href="<%= appPath %>/inventory/outward" class="btn btn-outline-danger btn-sm"><i class="fa-solid fa-arrow-up-long me-1"></i> Stock Outward</a>
    </div>
</div>

<div class="panel-card">
    <div class="table-responsive">
        <table class="table table-hover mb-0">
            <thead>
                <tr>
                    <th>Tx ID</th>
                    <th>Date &amp; Time</th>
                    <th>Type</th>
                    <th>Material Code &amp; Name</th>
                    <th class="text-center">Quantity</th>
                    <th>Reference / DC / Indent</th>
                    <th>Recorded By</th>
                    <th>Remarks</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<StockTransaction> history = (List<StockTransaction>) request.getAttribute("history");
                    if (history != null && !history.isEmpty()) {
                        for (StockTransaction t : history) {
                %>
                    <tr>
                        <td>#<%= t.getTransactionId() %></td>
                        <td class="small text-muted"><%= t.getTransactionDate() %></td>
                        <td>
                            <span class="badge <%= "INWARD".equalsIgnoreCase(t.getTransactionType()) ? "bg-success" : "bg-danger" %>">
                                <%= t.getTransactionType() %>
                            </span>
                        </td>
                        <td class="fw-semibold"><%= t.getMaterialCode() %> - <%= t.getMaterialName() %></td>
                        <td class="text-center fw-bold fs-6"><%= t.getQuantity() %></td>
                        <td><code><%= t.getReferenceNo() %></code></td>
                        <td><%= t.getCreatedBy() %></td>
                        <td class="small text-muted" style="max-width: 250px;"><%= t.getRemarks() != null ? t.getRemarks() : "-" %></td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="8" class="text-center text-muted py-4">No stock transactions logged yet.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>
