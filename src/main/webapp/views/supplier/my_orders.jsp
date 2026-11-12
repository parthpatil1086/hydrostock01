<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.hydrostock.model.PurchaseOrder"%>
<%@ include file="/includes/header.jsp" %>
<%@ include file="/includes/sidebar.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold text-dark mb-1">My Purchase Orders &amp; Consignments</h3>
        <p class="text-muted mb-0" style="font-size: 0.88rem;">Manage delivery schedules, dispatch notifications, and consignment tracking</p>
    </div>
</div>

<div class="panel-card">
    <div class="table-responsive">
        <table class="table table-hover mb-0">
            <thead>
                <tr>
                    <th>PO Number</th>
                    <th>Issue Date</th>
                    <th>Target Delivery</th>
                    <th class="text-end">Value (₹)</th>
                    <th>Status</th>
                    <th>Approval Clearance</th>
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
                        <td><strong><%= po.getPoNumber() %></strong></td>
                        <td><%= po.getOrderDate() %></td>
                        <td><%= po.getExpectedDelivery() %></td>
                        <td class="text-end fw-bold">₹ <%= String.format("%,.2f", po.getTotalAmount()) %></td>
                        <td>
                            <span class="badge-status <%= "DELIVERED".equalsIgnoreCase(po.getStatus()) ? "badge-delivered" : ("DISPATCHED".equalsIgnoreCase(po.getStatus()) ? "badge-dispatched" : "badge-pending") %>">
                                <%= po.getStatus() %>
                            </span>
                        </td>
                        <td><%= po.getApprovedBy() != null ? po.getApprovedBy() : "<span class='text-muted small'>Pending Admin</span>" %></td>
                        <td class="text-end">
                            <div class="btn-group btn-group-sm">
                                <a href="<%= appPath %>/purchase/view?id=<%= po.getPoId() %>" class="btn btn-outline-secondary" title="View Items">
                                    <i class="fa-solid fa-eye"></i>
                                </a>

                                <% if (!"DELIVERED".equalsIgnoreCase(po.getStatus())) { %>
                                    <button type="button" class="btn btn-outline-primary" onclick="openDispatchModal(<%= po.getPoId() %>, '<%= po.getPoNumber() %>')" title="Update Dispatch / Delivery">
                                        <i class="fa-solid fa-truck-ramp-box"></i>
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
                        <td colspan="7" class="text-center text-muted py-4">No purchase orders found.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Dispatch Consignment Modal -->
<div class="modal fade" id="dispatchModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="<%= appPath %>/supplier/dispatch" method="POST">
                <input type="hidden" name="poId" id="dispatchPoId">
                <div class="modal-header bg-dark text-white">
                    <h5 class="modal-title fs-6"><i class="fa-solid fa-truck-fast me-2 text-info"></i>Notify Consignment Dispatch / Delivery</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label text-muted">Purchase Order</label>
                        <input type="text" id="dispatchPoNum" class="form-control" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Updated Consignment Status *</label>
                        <select name="status" class="form-select form-select-lg" required>
                            <option value="DISPATCHED" selected>DISPATCHED (In Transit via Logistics)</option>
                            <option value="DELIVERED">DELIVERED (Arrived at Hydro Power Station Gate)</option>
                        </select>
                    </div>

                    <div class="mb-2">
                        <label class="form-label fw-semibold">Carrier / Transporter &amp; Docket Details *</label>
                        <textarea name="trackingNotes" class="form-control" rows="3" placeholder="e.g. Dispatched via VRL Logistics, Docket No: VRL-PUN-98214. Vehicle: MH-12-AB-3344" required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary btn-sm" style="background-color: #00A896; border-color: #00A896;">Submit Consignment Status</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function openDispatchModal(poId, poNum) {
    document.getElementById("dispatchPoId").value = poId;
    document.getElementById("dispatchPoNum").value = poNum;
    new bootstrap.Modal(document.getElementById("dispatchModal")).show();
}
</script>

<%@ include file="/includes/footer.jsp" %>
