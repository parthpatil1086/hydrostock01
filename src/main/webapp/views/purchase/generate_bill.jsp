<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.hydrostock.model.PurchaseOrder"%>
<%@ include file="/includes/header.jsp" %>
<%@ include file="/includes/sidebar.jsp" %>

<div class="row justify-content-center">
    <div class="col-lg-8">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold text-dark mb-1">Generate GST Purchase Invoice</h3>
                <p class="text-muted mb-0" style="font-size: 0.88rem;">Create statutory tax bill with CGST, SGST or IGST tax computation</p>
            </div>
            <a href="<%= appPath %>/purchase/billing" class="btn btn-outline-secondary btn-sm">
                <i class="fa-solid fa-arrow-left me-1"></i> Back to Invoices
            </a>
        </div>

        <div class="panel-card">
            <div class="panel-header bg-light">
                <h5 class="panel-title text-primary"><i class="fa-solid fa-calculator me-2"></i>GST Tax Invoice Formulation</h5>
            </div>
            <div class="p-4">
                <form action="<%= appPath %>/purchase/billing" method="POST">
                    <div class="mb-4">
                        <label class="form-label fw-semibold">Select Fulfilled Purchase Order *</label>
                        <select name="poId" class="form-select form-select-lg" required id="poSelector">
                            <option value="">-- Choose Purchase Order --</option>
                            <%
                                List<PurchaseOrder> orders = (List<PurchaseOrder>) request.getAttribute("orders");
                                if (orders != null) {
                                    for (PurchaseOrder po : orders) {
                            %>
                                <option value="<%= po.getPoId() %>" data-amount="<%= po.getTotalAmount() %>" data-vendor="<%= po.getSupplierName() %>">
                                    <%= po.getPoNumber() %> - <%= po.getSupplierName() %> (Base: ₹ <%= String.format("%,.2f", po.getTotalAmount()) %>) [<%= po.getStatus() %>]
                                </option>
                            <% } } %>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold">GST Taxation Type *</label>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="form-check p-3 border rounded bg-light">
                                    <input class="form-check-input" type="radio" name="gstType" id="gstIntra" value="INTRA" checked>
                                    <label class="form-check-label fw-semibold" for="gstIntra">
                                        Intra-State Supply (Maharashtra)
                                        <div class="small text-muted fw-normal">CGST (9%) + SGST (9%) = 18% Total Tax</div>
                                    </label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-check p-3 border rounded bg-light">
                                    <input class="form-check-input" type="radio" name="gstType" id="gstInter" value="INTER">
                                    <label class="form-check-label fw-semibold" for="gstInter">
                                        Inter-State Supply (Outside State)
                                        <div class="small text-muted fw-normal">Integrated GST (IGST 18%) Total Tax</div>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="panel-card p-3 mb-4 bg-light">
                        <h6 class="fw-bold text-dark mb-2">Live Tax Calculation Preview:</h6>
                        <div class="d-flex justify-content-between mb-1">
                            <span>Base Subtotal (Excl. Tax):</span>
                            <span id="previewSubtotal" class="fw-semibold">₹ 0.00</span>
                        </div>
                        <div class="d-flex justify-content-between mb-1 text-muted">
                            <span id="taxLabel1">CGST (9%):</span>
                            <span id="taxVal1">₹ 0.00</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2 text-muted">
                            <span id="taxLabel2">SGST (9%):</span>
                            <span id="taxVal2">₹ 0.00</span>
                        </div>
                        <hr class="my-2">
                        <div class="d-flex justify-content-between fs-5 fw-bold text-primary">
                            <span>Grand Total (Incl. Taxes):</span>
                            <span id="previewGrandTotal">₹ 0.00</span>
                        </div>
                    </div>

                    <div class="d-grid">
                        <button type="submit" class="btn btn-primary btn-lg py-2 fw-semibold" style="background-color: #00A896; border-color: #00A896;">
                            <i class="fa-solid fa-file-invoice-dollar me-2"></i> Finalize &amp; Generate Tax Invoice
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const poSelect = document.getElementById("poSelector");
    const gstIntra = document.getElementById("gstIntra");
    const gstInter = document.getElementById("gstInter");

    function updatePreview() {
        const selected = poSelect.options[poSelect.selectedIndex];
        const base = parseFloat(selected.getAttribute("data-amount")) || 0;
        const isInter = gstInter.checked;

        let cgst = 0, sgst = 0, igst = 0;
        if (isInter) {
            igst = base * 0.18;
            document.getElementById("taxLabel1").innerText = "Integrated GST (IGST 18%):";
            document.getElementById("taxVal1").innerText = "₹ " + igst.toLocaleString('en-IN', {minimumFractionDigits: 2});
            document.getElementById("taxLabel2").innerText = "";
            document.getElementById("taxVal2").innerText = "";
        } else {
            cgst = base * 0.09;
            sgst = base * 0.09;
            document.getElementById("taxLabel1").innerText = "Central GST (CGST 9%):";
            document.getElementById("taxVal1").innerText = "₹ " + cgst.toLocaleString('en-IN', {minimumFractionDigits: 2});
            document.getElementById("taxLabel2").innerText = "State GST (SGST 9%):";
            document.getElementById("taxVal2").innerText = "₹ " + sgst.toLocaleString('en-IN', {minimumFractionDigits: 2});
        }

        const grand = base + cgst + sgst + igst;
        document.getElementById("previewSubtotal").innerText = "₹ " + base.toLocaleString('en-IN', {minimumFractionDigits: 2});
        document.getElementById("previewGrandTotal").innerText = "₹ " + grand.toLocaleString('en-IN', {minimumFractionDigits: 2});
    }

    poSelect.addEventListener("change", updatePreview);
    gstIntra.addEventListener("change", updatePreview);
    gstInter.addEventListener("change", updatePreview);
});
</script>

<%@ include file="/includes/footer.jsp" %>
