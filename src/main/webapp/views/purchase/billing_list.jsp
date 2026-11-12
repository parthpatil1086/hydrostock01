<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.hydrostock.model.Bill"%>
<%@ include file="/includes/header.jsp" %>
<%@ include file="/includes/sidebar.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold text-dark mb-1">Billing &amp; Invoices Ledger</h3>
        <p class="text-muted mb-0" style="font-size: 0.88rem;">Track generated GST tax invoices, disbursement status, and payment acknowledgments</p>
    </div>
    <a href="<%= appPath %>/purchase/generate-bill" class="btn btn-primary btn-sm" style="background-color: #00A896; border-color: #00A896;">
        <i class="fa-solid fa-calculator me-1"></i> Generate New GST Bill
    </a>
</div>

<div class="panel-card">
    <div class="table-responsive">
        <table class="table table-hover mb-0">
            <thead>
                <tr>
                    <th>Invoice No</th>
                    <th>PO Ref</th>
                    <th>Supplier / Vendor</th>
                    <th>Invoice Date</th>
                    <th class="text-end">Base Amount (₹)</th>
                    <th class="text-end">Grand Total (₹)</th>
                    <th>Payment Status</th>
                    <th class="text-end">Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Bill> invoices = (List<Bill>) request.getAttribute("invoices");
                    if (invoices != null && !invoices.isEmpty()) {
                        for (Bill b : invoices) {
                %>
                    <tr>
                        <td>
                            <a href="<%= appPath %>/purchase/invoice-print?id=<%= b.getInvoiceId() %>" class="fw-bold text-primary text-decoration-none">
                                <%= b.getInvoiceNumber() %>
                            </a>
                        </td>
                        <td><code><%= b.getPoNumber() %></code></td>
                        <td class="fw-semibold text-dark"><%= b.getSupplierName() %></td>
                        <td><%= b.getInvoiceDate() %></td>
                        <td class="text-end">₹ <%= String.format("%,.2f", b.getSubtotal()) %></td>
                        <td class="text-end fw-bold text-dark">₹ <%= String.format("%,.2f", b.getGrandTotal()) %></td>
                        <td>
                            <span class="badge-status <%= "PAID".equalsIgnoreCase(b.getPaymentStatus()) ? "badge-paid" : ("PARTIALLY_PAID".equalsIgnoreCase(b.getPaymentStatus()) ? "badge-partially_paid" : "badge-unpaid") %>">
                                <%= b.getPaymentStatus() %>
                            </span>
                        </td>
                        <td class="text-end">
                            <div class="btn-group btn-group-sm">
                                <a href="<%= appPath %>/purchase/invoice-print?id=<%= b.getInvoiceId() %>" class="btn btn-outline-secondary" title="View &amp; Print PDF Invoice">
                                    <i class="fa-solid fa-file-pdf"></i>
                                </a>

                                <% if (!"PAID".equalsIgnoreCase(b.getPaymentStatus())) { %>
                                    <button type="button" class="btn btn-outline-success" onclick="openPaymentModal(<%= b.getInvoiceId() %>, '<%= b.getInvoiceNumber() %>', <%= b.getGrandTotal() %>)" title="Record Payment">
                                        <i class="fa-solid fa-money-bill-wave"></i>
                                    </button>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="8" class="text-center text-muted py-4">No billing invoices found.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Record Payment Modal -->
<div class="modal fade" id="paymentModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="<%= appPath %>/purchase/pay" method="POST">
                <input type="hidden" name="invoiceId" id="payInvoiceId">
                <div class="modal-header bg-dark text-white">
                    <h5 class="modal-title fs-6"><i class="fa-solid fa-money-bill-wave me-2 text-success"></i>Disburse Supplier Payment</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label text-muted">Invoice Number</label>
                        <input type="text" id="payInvNum" class="form-control" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Disbursed Amount (₹) *</label>
                        <input type="number" step="0.01" min="0.01" name="amountPaid" id="payAmount" class="form-control form-control-lg fw-bold" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Payment Mode *</label>
                        <select name="paymentMode" class="form-select" required>
                            <option value="NEFT_RTGS" selected>NEFT / RTGS Treasury Transfer</option>
                            <option value="DIRECT_BANK_TRANSFER">Direct Electronic Fund Transfer</option>
                            <option value="CHEQUE">Government Treasury Cheque</option>
                            <option value="TREASURY_BILL">State Electricity Board Treasury Bill</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Transaction / UTR Reference No *</label>
                        <input type="text" name="reference" class="form-control" placeholder="e.g. UTR-SBI-2026111299" required>
                    </div>

                    <div class="mb-2">
                        <label class="form-label fw-semibold">Accounts Department Notes</label>
                        <input type="text" name="notes" class="form-control" placeholder="Payment clearance voucher remarks">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-success btn-sm">Confirm &amp; Record Payment</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function openPaymentModal(invId, invNum, total) {
    document.getElementById("payInvoiceId").value = invId;
    document.getElementById("payInvNum").value = invNum;
    document.getElementById("payAmount").value = total;
    new bootstrap.Modal(document.getElementById("paymentModal")).show();
}
</script>

<%@ include file="/includes/footer.jsp" %>
