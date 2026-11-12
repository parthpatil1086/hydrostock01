<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.hydrostock.model.Equipment"%>
<%@ page import="com.hydrostock.model.MaintenanceRecord"%>
<%@ page import="com.hydrostock.model.Material"%>
<%@ include file="/includes/header.jsp" %>
<%@ include file="/includes/sidebar.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold text-dark mb-1">Plant Equipment &amp; Maintenance Logs</h3>
        <p class="text-muted mb-0" style="font-size: 0.88rem;">Hydro turbines, generators, penstock valves, and scheduled overhauls</p>
    </div>
    <button class="btn btn-primary btn-sm" style="background-color: #00A896; border-color: #00A896;" data-bs-toggle="modal" data-bs-target="#logMaintenanceModal">
        <i class="fa-solid fa-wrench me-1"></i> Log Maintenance Breakdown / Overhaul
    </button>
</div>

<!-- Equipment Master Table -->
<div class="panel-card mb-4">
    <div class="panel-header">
        <h5 class="panel-title"><i class="fa-solid fa-bolt me-2 text-primary"></i>Heavy Power Generation Machinery</h5>
        <span class="badge bg-light text-dark border">Warananagar Station</span>
    </div>
    <div class="table-responsive">
        <table class="table table-hover mb-0">
            <thead>
                <tr>
                    <th>Equipment Code</th>
                    <th>Equipment Name</th>
                    <th>Plant Location</th>
                    <th>Commissioning Date</th>
                    <th>Operational Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Equipment> eqList = (List<Equipment>) request.getAttribute("equipmentList");
                    if (eqList != null) {
                        for (Equipment eq : eqList) {
                %>
                    <tr>
                        <td><code><%= eq.getEquipmentCode() %></code></td>
                        <td class="fw-semibold"><%= eq.getEquipmentName() %></td>
                        <td><i class="fa-solid fa-location-dot text-muted me-1"></i><%= eq.getLocationPlantUnit() %></td>
                        <td><%= eq.getInstallationDate() != null ? eq.getInstallationDate().toString() : "N/A" %></td>
                        <td>
                            <span class="badge-status <%= "OPERATIONAL".equalsIgnoreCase(eq.getStatus()) ? "badge-operational" : "badge-maintenance_required" %>">
                                <%= eq.getStatus() %>
                            </span>
                        </td>
                    </tr>
                <%
                        }
                    }
                %>
            </tbody>
        </table>
    </div>
</div>

<!-- Maintenance History Table -->
<div class="panel-card">
    <div class="panel-header">
        <h5 class="panel-title"><i class="fa-solid fa-clock-rotate-left me-2 text-warning"></i>Maintenance History &amp; Spares Consumed</h5>
    </div>
    <div class="table-responsive">
        <table class="table table-hover mb-0">
            <thead>
                <tr>
                    <th>Date</th>
                    <th>Equipment</th>
                    <th>Issue Description</th>
                    <th>Engineer In-Charge</th>
                    <th>Spares Consumed</th>
                    <th>Status</th>
                    <th>Remarks</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<MaintenanceRecord> maintList = (List<MaintenanceRecord>) request.getAttribute("maintenanceList");
                    if (maintList != null) {
                        for (MaintenanceRecord mr : maintList) {
                %>
                    <tr>
                        <td><%= mr.getMaintenanceDate() %></td>
                        <td class="fw-semibold"><%= mr.getEquipmentName() %></td>
                        <td style="max-width: 250px;"><%= mr.getIssueDescription() %></td>
                        <td><%= mr.getPerformedBy() %></td>
                        <td>
                            <% if (mr.getMaterialName() != null) { %>
                                <span class="badge bg-light text-dark border">
                                    <%= mr.getQuantityUsed() %>x <%= mr.getMaterialName() %>
                                </span>
                            <% } else { %>
                                <span class="text-muted">None (Labor only)</span>
                            <% } %>
                        </td>
                        <td>
                            <span class="badge-status <%= "COMPLETED".equalsIgnoreCase(mr.getStatus()) ? "badge-approved" : "badge-in_progress" %>">
                                <%= mr.getStatus() %>
                            </span>
                        </td>
                        <td class="small text-muted"><%= mr.getRemarks() != null ? mr.getRemarks() : "-" %></td>
                    </tr>
                <%
                        }
                    }
                %>
            </tbody>
        </table>
    </div>
</div>

<!-- Log Maintenance Modal -->
<div class="modal fade" id="logMaintenanceModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="<%= appPath %>/admin/equipment" method="POST">
                <div class="modal-header bg-dark text-white">
                    <h5 class="modal-title fs-6"><i class="fa-solid fa-wrench me-2 text-info"></i>Log Equipment Maintenance</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Target Machine / Unit *</label>
                        <select name="equipmentId" class="form-select" required>
                            <% if (eqList != null) {
                                for (Equipment eq : eqList) { %>
                                <option value="<%= eq.getEquipmentId() %>"><%= eq.getEquipmentName() %> (<%= eq.getLocationPlantUnit() %>)</option>
                            <% } } %>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Issue / Maintenance Work Description *</label>
                        <textarea name="issueDescription" class="form-control" rows="2" placeholder="e.g. Francis guide bearing inspection and vibration check" required></textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Performing Engineer / Technician *</label>
                        <input type="text" name="performedBy" class="form-control" placeholder="e.g. Anand Kulkarni" required>
                    </div>

                    <div class="row g-2 mb-3">
                        <div class="col-md-8">
                            <label class="form-label fw-semibold">Spare Part Consumed</label>
                            <select name="materialUsedId" class="form-select">
                                <option value="0">-- No Spares Used (Inspection Only) --</option>
                                <%
                                    List<Material> mats = (List<Material>) request.getAttribute("materials");
                                    if (mats != null) {
                                        for (Material m : mats) {
                                %>
                                    <option value="<%= m.getMaterialId() %>"><%= m.getMaterialName() %> (In stock: <%= m.getCurrentStock() %>)</option>
                                <% } } %>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Quantity</label>
                            <input type="number" name="quantityUsed" class="form-control" value="1" min="0">
                        </div>
                    </div>

                    <div class="row g-2 mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Maintenance Date *</label>
                            <input type="date" name="maintenanceDate" class="form-control" required value="<%= new java.sql.Date(new java.util.Date().getTime()) %>">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Status *</label>
                            <select name="status" class="form-select">
                                <option value="COMPLETED" selected>COMPLETED</option>
                                <option value="IN_PROGRESS">IN_PROGRESS</option>
                                <option value="SCHEDULED">SCHEDULED</option>
                            </select>
                        </div>
                    </div>

                    <div class="mb-2">
                        <label class="form-label fw-semibold">Technical Remarks / Calibration Readings</label>
                        <input type="text" name="remarks" class="form-control" placeholder="Optional notes">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary btn-sm" style="background-color: #00A896; border-color: #00A896;">Record Maintenance Log</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>
