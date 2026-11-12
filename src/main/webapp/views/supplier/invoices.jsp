<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.hydrostock.model.Bill"%>
<%@ include file="/includes/header.jsp" %>
<%@ include file="/includes/sidebar.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold text-dark mb-1">Supplier Tax Bills &amp; Payment Receipts</h3>
        <p class="text-muted mb-0" style="font-size: 0.88rem;">Review plant verified billing vouchers and disbursement clearance records</p>
    </div>
</div>

<div class="panel-card">
    <div class="table-responsive">
        <table class="table table-hover mb-0">
            <thead>
                <tr>
                    <th>Invoice No</th>
                    <th>PO Ref</th>
                    <th>Invoice Date</th>
                    <th class="text-end">Taxable Amount (₹)</th>
                    <th class="text-end">Invoice Total (₹)</th>
                    <th>Settlement Status</th>
                    <th class="text-end">Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Bill> invoices = (List<Bill>) request.getAttribute("invoices");
                    if (invoices != null && !invoices.isEmpty()) {
                        for (Bill b : invoices) {
                %>
                    <tr>
                        <td><strong><%= b.getInvoiceNumber() %></strong></td>
                        <td><code><%= b.getPoNumber() %></code></td>
                        <td><%= b.getInvoiceDate() %></td>
                        <td class="text-end">₹ <%= String.format("%,.2f", b.getSubtotal()) %></td>
                        <td class="text-end fw-bold">₹ <%= String.format("%,.2f", b.getGrandTotal()) %></td>
                        <td>
                            <span class="badge-status <%= "PAID".equalsIgnoreCase(b.getPaymentStatus()) ? "badge-paid" : ("PARTIALLY_PAID".equalsIgnoreCase(b.getPaymentStatus()) ? "badge-partially_paid" : "badge-unpaid") %>">
                                <%= b.getPaymentStatus() %>
                            </span>
                        </td>
                        <td class="text-end">
                            <a href="<%= appPath %>/purchase/invoice-print?id=<%= b.getInvoiceId() %>" class="btn btn-sm btn-outline-secondary py-0">
                                <i class="fa-solid fa-file-pdf me-1"></i> View Tax Invoice
                            </a>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="7" class="text-center text-muted py-4">No invoices on file for your supplier account.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>
