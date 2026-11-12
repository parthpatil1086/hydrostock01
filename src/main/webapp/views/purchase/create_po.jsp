<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.hydrostock.model.Supplier"%>
<%@ page import="com.hydrostock.model.Material"%>
<%@ include file="/includes/header.jsp" %>
<%@ include file="/includes/sidebar.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold text-dark mb-1">Create Purchase Order (Indent)</h3>
        <p class="text-muted mb-0" style="font-size: 0.88rem;">Procurement order for power plant mechanical, electrical spares, and lubricants</p>
    </div>
    <a href="<%= appPath %>/purchase/orders" class="btn btn-outline-secondary btn-sm">
        <i class="fa-solid fa-arrow-left me-1"></i> Back to Orders
    </a>
</div>

<form action="<%= appPath %>/purchase/create" method="POST" id="poForm">
    <div class="row g-4 mb-4">
        <!-- Supplier & Delivery Details -->
        <div class="col-lg-6">
            <div class="panel-card h-100 p-4">
                <h5 class="fw-bold text-dark mb-3"><i class="fa-solid fa-truck-field me-2 text-primary"></i>Supplier Information</h5>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Select Registered Supplier *</label>
                    <select name="supplierId" class="form-select form-select-lg" required>
                        <option value="">-- Choose Vendor --</option>
                        <%
                            List<Supplier> suppliers = (List<Supplier>) request.getAttribute("suppliers");
                            if (suppliers != null) {
                                for (Supplier s : suppliers) {
                        %>
                            <option value="<%= s.getSupplierId() %>">
                                <%= s.getCompanyName() %> (GST: <%= s.getGstNumber() %>) - <%= s.getContactPerson() %>
                            </option>
                        <% } } %>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Expected Delivery Date *</label>
                    <input type="date" name="expectedDelivery" class="form-control" required min="<%= new java.sql.Date(new java.util.Date().getTime()) %>" value="<%= new java.sql.Date(new java.util.Date().getTime() + 14L*24*60*60*1000) %>">
                </div>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="panel-card h-100 p-4">
                <h5 class="fw-bold text-dark mb-3"><i class="fa-solid fa-clipboard-list me-2 text-primary"></i>Order Terms &amp; Scope</h5>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Purchaser Authority</label>
                    <input type="text" class="form-control" value="HydroStock Plant Stores &amp; Accounts, Warananagar" readonly>
                </div>

                <div class="mb-2">
                    <label class="form-label fw-semibold">Special Terms / Scope of Supply</label>
                    <textarea name="notes" class="form-control" rows="3" placeholder="e.g. Spares must be certified OEM compliant with test certificates."></textarea>
                </div>
            </div>
        </div>
    </div>

    <!-- Multi-Item Purchase Order Table -->
    <div class="panel-card mb-4">
        <div class="panel-header d-flex justify-content-between align-items-center">
            <h5 class="panel-title"><i class="fa-solid fa-list-check me-2 text-primary"></i>Purchase Line Items</h5>
            <button type="button" class="btn btn-outline-primary btn-sm" id="addItemBtn">
                <i class="fa-solid fa-plus me-1"></i> Add Another Spare
            </button>
        </div>

        <div class="table-responsive p-3">
            <table class="table align-middle" id="poItemsTable">
                <thead class="table-light">
                    <tr>
                        <th style="width: 45%;">Material / Spare Part *</th>
                        <th style="width: 15%;">Quantity *</th>
                        <th style="width: 18%;">Unit Rate (₹) *</th>
                        <th style="width: 17%;">Line Total (₹)</th>
                        <th style="width: 5%;"></th>
                    </tr>
                </thead>
                <tbody id="poItemsBody">
                    <tr>
                        <td>
                            <select name="materialId[]" class="form-select material-select" required>
                                <option value="" data-price="0">-- Select Material --</option>
                                <%
                                    List<Material> materials = (List<Material>) request.getAttribute("materials");
                                    if (materials != null) {
                                        for (Material m : materials) {
                                %>
                                    <option value="<%= m.getMaterialId() %>" data-price="<%= m.getUnitPrice() %>">
                                        [<%= m.getMaterialCode() %>] <%= m.getMaterialName() %> (<%= m.getUnitOfMeasure() %>)
                                    </option>
                                <% } } %>
                            </select>
                        </td>
                        <td>
                            <input type="number" name="quantity[]" class="form-control item-qty" value="1" min="1" required>
                        </td>
                        <td>
                            <input type="number" step="0.01" name="unitPrice[]" class="form-control item-price" value="0.00" min="0.01" required>
                        </td>
                        <td>
                            <input type="text" class="form-control item-subtotal bg-light" value="0.00" readonly>
                        </td>
                        <td class="text-center">
                            <button type="button" class="btn btn-sm btn-outline-danger remove-item-btn"><i class="fa-solid fa-trash"></i></button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="panel-header bg-light d-flex justify-content-between align-items-center p-3">
            <div class="fw-bold fs-5 text-dark">Total PO Amount (Excl. Tax):</div>
            <div class="fw-bold fs-4 text-primary" id="poGrandTotal">₹ 0.00</div>
        </div>
    </div>

    <div class="d-flex justify-content-end gap-3 mb-5">
        <a href="<%= appPath %>/purchase/orders" class="btn btn-secondary px-4">Cancel</a>
        <button type="submit" class="btn btn-primary px-4 fw-semibold" style="background-color: #00A896; border-color: #00A896;">
            <i class="fa-solid fa-paper-plane me-2"></i> Submit &amp; Issue Purchase Order
        </button>
    </div>
</form>

<%@ include file="/includes/footer.jsp" %>
