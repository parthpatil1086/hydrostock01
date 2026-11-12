<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.hydrostock.model.Material"%>
<%@ page import="com.hydrostock.model.Category"%>
<%@ include file="/includes/header.jsp" %>
<%@ include file="/includes/sidebar.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold text-dark mb-1">Hydro Plant Materials &amp; Spares Master</h3>
        <p class="text-muted mb-0" style="font-size: 0.88rem;">Complete catalog of turbine parts, seals, valves, and electrical components</p>
    </div>
    <div class="d-flex gap-2">
        <a href="<%= appPath %>/inventory/inward" class="btn btn-outline-success btn-sm"><i class="fa-solid fa-arrow-down-long me-1"></i> Stock Inward</a>
        <a href="<%= appPath %>/inventory/outward" class="btn btn-outline-danger btn-sm"><i class="fa-solid fa-arrow-up-long me-1"></i> Stock Outward</a>
        <button class="btn btn-primary btn-sm" style="background-color: #00A896; border-color: #00A896;" data-bs-toggle="modal" data-bs-target="#addMaterialModal">
            <i class="fa-solid fa-plus me-1"></i> Add New Material
        </button>
    </div>
</div>

<div class="panel-card">
    <div class="panel-header">
        <h5 class="panel-title"><i class="fa-solid fa-boxes-stacked me-2 text-primary"></i>Inventory Spares Ledger</h5>
        <input type="text" id="matSearch" class="form-control form-control-sm" placeholder="Search spares..." style="max-width: 250px;">
    </div>
    <div class="table-responsive">
        <table class="table table-hover mb-0" id="materialsTable">
            <thead>
                <tr>
                    <th>Item Code</th>
                    <th>Material / Spare Name</th>
                    <th>Category</th>
                    <th>Unit</th>
                    <th class="text-center">Available Stock</th>
                    <th class="text-center">Min Threshold</th>
                    <th class="text-end">Unit Rate (₹)</th>
                    <th>Storage Rack</th>
                    <th>Stock Health</th>
                    <th class="text-end">Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Material> materials = (List<Material>) request.getAttribute("materials");
                    if (materials != null) {
                        for (Material m : materials) {
                %>
                    <tr>
                        <td><code><%= m.getMaterialCode() %></code></td>
                        <td class="fw-semibold text-dark"><%= m.getMaterialName() %></td>
                        <td><%= m.getCategoryName() %></td>
                        <td><%= m.getUnitOfMeasure() %></td>
                        <td class="text-center fw-bold fs-6">
                            <%= m.getCurrentStock() %>
                        </td>
                        <td class="text-center text-muted"><%= m.getMinStockLevel() %></td>
                        <td class="text-end">₹ <%= String.format("%,.2f", m.getUnitPrice()) %></td>
                        <td><i class="fa-solid fa-location-dot text-muted me-1"></i><%= m.getLocationRack() %></td>
                        <td>
                            <% if (m.isLowStock()) { %>
                                <span class="badge bg-danger"><i class="fa-solid fa-triangle-exclamation me-1"></i>Low Stock</span>
                            <% } else { %>
                                <span class="badge bg-success"><i class="fa-solid fa-check me-1"></i>Adequate</span>
                            <% } %>
                        </td>
                        <td class="text-end">
                            <a href="<%= appPath %>/inventory/materials?action=delete&id=<%= m.getMaterialId() %>" class="btn btn-sm btn-outline-danger py-0" onclick="return confirm('Delete this material record?');">
                                <i class="fa-solid fa-trash-can"></i>
                            </a>
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

<!-- Add Material Modal -->
<div class="modal fade" id="addMaterialModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="<%= appPath %>/inventory/materials" method="POST">
                <input type="hidden" name="action" value="add">
                <div class="modal-header bg-dark text-white">
                    <h5 class="modal-title fs-6"><i class="fa-solid fa-box-open me-2 text-info"></i>Register New Material / Spare</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-2 mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Material Code *</label>
                            <input type="text" name="materialCode" class="form-control" required placeholder="e.g. MAT-TURB-008">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Category *</label>
                            <select name="categoryId" class="form-select" required>
                                <%
                                    List<Category> cats = (List<Category>) request.getAttribute("categories");
                                    if (cats != null) {
                                        for (Category c : cats) {
                                %>
                                    <option value="<%= c.getCategoryId() %>"><%= c.getCategoryName() %></option>
                                <% } } %>
                            </select>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Material / Spare Name *</label>
                        <input type="text" name="materialName" class="form-control" required placeholder="e.g. Francis Runner Guide Ring Seal">
                    </div>

                    <div class="row g-2 mb-3">
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Unit *</label>
                            <select name="unitOfMeasure" class="form-select" required>
                                <option value="Units">Units</option>
                                <option value="Pieces">Pieces</option>
                                <option value="Sets">Sets</option>
                                <option value="Drums">Drums</option>
                                <option value="Liters">Liters</option>
                                <option value="Kg">Kg</option>
                                <option value="Meters">Meters</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Initial Stock</label>
                            <input type="number" name="currentStock" class="form-control" value="0" min="0" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Min Level *</label>
                            <input type="number" name="minStockLevel" class="form-control" value="5" min="1" required>
                        </div>
                    </div>

                    <div class="row g-2 mb-2">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Unit Price (₹) *</label>
                            <input type="number" step="0.01" name="unitPrice" class="form-control" value="0.00" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Warehouse Rack *</label>
                            <input type="text" name="locationRack" class="form-control" placeholder="Rack-A2-Bay01" required>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary btn-sm" style="background-color: #00A896; border-color: #00A896;">Save Material</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
document.getElementById('matSearch').addEventListener('keyup', function() {
    let filter = this.value.toLowerCase();
    let rows = document.querySelectorAll('#materialsTable tbody tr');
    rows.forEach(row => {
        let text = row.innerText.toLowerCase();
        row.style.display = text.includes(filter) ? '' : 'none';
    });
});
</script>

<%@ include file="/includes/footer.jsp" %>
