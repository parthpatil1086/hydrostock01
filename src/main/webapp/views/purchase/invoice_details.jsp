<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.hydrostock.model.Bill"%>
<%@ page import="com.hydrostock.model.PurchaseItem"%>
<%@ include file="/includes/header.jsp" %>
<%@ include file="/includes/sidebar.jsp" %>

<%
    Bill inv = (Bill) request.getAttribute("invoice");
    List<PurchaseItem> items = (List<PurchaseItem>) request.getAttribute("items");
%>

<div class="d-flex justify-content-between align-items-center mb-4 no-print">
    <div>
        <h3 class="fw-bold text-dark mb-1">Official GST Tax Invoice</h3>
        <p class="text-muted mb-0" style="font-size: 0.88rem;">Statutory procurement voucher for power plant audit</p>
    </div>
    <div class="d-flex gap-2">
        <a href="<%= appPath %>/purchase/billing" class="btn btn-outline-secondary btn-sm"><i class="fa-solid fa-arrow-left me-1"></i> Back to Ledger</a>
        <button class="btn btn-primary btn-sm" onclick="window.print()" style="background-color: #00A896; border-color: #00A896;">
            <i class="fa-solid fa-print me-1"></i> Print / Save as PDF
        </button>
    </div>
</div>

<% if (inv != null) { %>
<!-- Printable Official Tax Invoice Container -->
<div class="panel-card p-5 bg-white shadow-sm" style="max-width: 900px; margin: auto; border: 1px solid #CBD5E1;">
    <!-- Invoice Header -->
    <div class="d-flex justify-content-between border-bottom pb-4 mb-4">
        <div>
            <div class="d-flex align-items-center gap-2 mb-2">
                <i class="fa-solid fa-water fa-2x text-primary"></i>
                <h3 class="fw-bold text-dark mb-0">HYDROSTOCK</h3>
            </div>
            <div class="fw-semibold text-dark">Hydroelectric Power Station, Warananagar</div>
            <div class="text-muted small">Warananagar Dam Complex, Kolhapur, Maharashtra 416113</div>
            <div class="text-muted small">GSTIN: <strong>27AAAGH8899J1Z4</strong> | State Code: 27 (MH)</div>
            <div class="text-muted small">Email: accounts@hydrostock.power.gov</div>
        </div>
        <div class="text-end">
            <h4 class="text-uppercase fw-bold text-primary mb-1">TAX INVOICE</h4>
            <div class="fs-5 fw-bold text-dark"><%= inv.getInvoiceNumber() %></div>
            <div class="text-muted small">Invoice Date: <strong><%= inv.getInvoiceDate() %></strong></div>
            <div class="text-muted small">PO Reference: <strong><%= inv.getPoNumber() %></strong></div>
            <div class="mt-2">
                <span class="badge <%= "PAID".equalsIgnoreCase(inv.getPaymentStatus()) ? "bg-success" : "bg-warning text-dark" %> px-3 py-1 fs-6">
                    <%= inv.getPaymentStatus() %>
                </span>
            </div>
        </div>
    </div>

    <!-- Vendor / Billed To Section -->
    <div class="row mb-4">
        <div class="col-6">
            <h6 class="text-uppercase text-muted fw-bold small">Supplier / Vendor:</h6>
            <h5 class="fw-bold text-dark mb-1"><%= inv.getSupplierName() %></h5>
            <div class="text-muted small">GSTIN: <strong><%= inv.getSupplierGst() %></strong></div>
            <div class="text-muted small">State Code: 27 (Maharashtra)</div>
        </div>
        <div class="col-6 text-end">
            <h6 class="text-uppercase text-muted fw-bold small">Consignee (Billed To):</h6>
            <h5 class="fw-bold text-dark mb-1">Superintending Engineer (E&amp;M)</h5>
            <div class="text-muted small">Store Depot, Hydroelectric Power House</div>
            <div class="text-muted small">TKIET / Warana Hydel Station Project</div>
        </div>
    </div>

    <!-- Line Items Table -->
    <div class="table-responsive mb-4">
        <table class="table table-bordered align-middle">
            <thead class="table-light">
                <tr>
                    <th style="width: 5%;">#</th>
                    <th style="width: 20%;">Material Code</th>
                    <th style="width: 40%;">Description of Spares / Goods</th>
                    <th style="width: 10%;" class="text-center">Qty</th>
                    <th style="width: 12%;" class="text-end">Rate (₹)</th>
                    <th style="width: 13%;" class="text-end">Amount (₹)</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (items != null) {
                        int idx = 1;
                        for (PurchaseItem item : items) {
                %>
                    <tr>
                        <td><%= idx++ %></td>
                        <td><code><%= item.getMaterialCode() %></code></td>
                        <td class="fw-semibold"><%= item.getMaterialName() %></td>
                        <td class="text-center"><%= item.getQuantity() %> <%= item.getUnitOfMeasure() %></td>
                        <td class="text-end"><%= String.format("%,.2f", item.getUnitPrice()) %></td>
                        <td class="text-end fw-semibold"><%= String.format("%,.2f", item.getSubtotal()) %></td>
                    </tr>
                <%
                        }
                    }
                %>
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="5" class="text-end fw-bold">Taxable Value (Subtotal):</td>
                    <td class="text-end fw-bold">₹ <%= String.format("%,.2f", inv.getSubtotal()) %></td>
                </tr>
                <% if (inv.getCgstAmount() > 0) { %>
                    <tr>
                        <td colspan="5" class="text-end text-muted">Central GST (CGST <%= inv.getCgstRate() %>%):</td>
                        <td class="text-end text-muted">₹ <%= String.format("%,.2f", inv.getCgstAmount()) %></td>
                    </tr>
                    <tr>
                        <td colspan="5" class="text-end text-muted">State GST (SGST <%= inv.getSgstRate() %>%):</td>
                        <td class="text-end text-muted">₹ <%= String.format("%,.2f", inv.getSgstAmount()) %></td>
                    </tr>
                <% } else if (inv.getIgstAmount() > 0) { %>
                    <tr>
                        <td colspan="5" class="text-end text-muted">Integrated GST (IGST <%= inv.getIgstRate() %>%):</td>
                        <td class="text-end text-muted">₹ <%= String.format("%,.2f", inv.getIgstAmount()) %></td>
                    </tr>
                <% } %>
                <tr class="table-light">
                    <td colspan="5" class="text-end fw-bold fs-5 text-dark">Invoice Grand Total:</td>
                    <td class="text-end fw-bold fs-5 text-primary">₹ <%= String.format("%,.2f", inv.getGrandTotal()) %></td>
                </tr>
            </tfoot>
        </table>
    </div>

    <!-- Signatures -->
    <div class="row pt-5 mt-4 text-center">
        <div class="col-4">
            <div class="border-top border-dark pt-2 small fw-semibold">Store In-Charge / Inward Verification</div>
        </div>
        <div class="col-4">
            <div class="border-top border-dark pt-2 small fw-semibold">Accounts Officer (Billing Audit)</div>
        </div>
        <div class="col-4">
            <div class="border-top border-dark pt-2 small fw-semibold">Superintending Chief Engineer</div>
        </div>
    </div>
</div>
<% } %>

<%@ include file="/includes/footer.jsp" %>
