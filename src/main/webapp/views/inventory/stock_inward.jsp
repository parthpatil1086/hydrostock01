<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.hydrostock.model.Material"%>
<%@ include file="/includes/header.jsp" %>
<%@ include file="/includes/sidebar.jsp" %>

<div class="row justify-content-center">
    <div class="col-lg-8">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold text-dark mb-1">Stock Inward (Goods Receipt)</h3>
                <p class="text-muted mb-0" style="font-size: 0.88rem;">Record incoming materials from suppliers and auto-increment stock</p>
            </div>
            <a href="<%= appPath %>/inventory/materials" class="btn btn-outline-secondary btn-sm">
                <i class="fa-solid fa-arrow-left me-1"></i> Back to Catalog
            </a>
        </div>

        <div class="panel-card">
            <div class="panel-header bg-light">
                <h5 class="panel-title text-success"><i class="fa-solid fa-arrow-down-long me-2"></i>Stock Inward Entry Voucher</h5>
            </div>
            <div class="p-4">
                <form action="<%= appPath %>/inventory/inward" method="POST" novalidate>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Select Material / Spare Part *</label>
                        <select name="materialId" class="form-select form-select-lg" required>
                            <option value="">-- Choose Spare from Catalog --</option>
                            <%
                                List<Material> materials = (List<Material>) request.getAttribute("materials");
                                if (materials != null) {
                                    for (Material m : materials) {
                            %>
                                <option value="<%= m.getMaterialId() %>">
                                    [<%= m.getMaterialCode() %>] <%= m.getMaterialName() %> (Current Balance: <%= m.getCurrentStock() %> <%= m.getUnitOfMeasure() %>)
                                </option>
                            <% } } %>
                        </select>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Quantity Received *</label>
                            <input type="number" name="quantity" class="form-control form-control-lg" placeholder="e.g. 10" min="1" step="1" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Delivery Challan / Invoice Reference No *</label>
                            <input type="text" name="referenceNo" class="form-control form-control-lg" placeholder="e.g. DC-BHEL-2026-90" required>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold">Storekeeper Remarks / Inspection Notes</label>
                        <textarea name="remarks" class="form-control" rows="3" placeholder="e.g. Material inspected against Purchase Order specifications. Verified without damage."></textarea>
                    </div>

                    <div class="d-grid">
                        <button type="submit" class="btn btn-success btn-lg py-2 fw-semibold">
                            <i class="fa-solid fa-circle-check me-2"></i> Confirm Stock Inward &amp; Update Inventory
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>
