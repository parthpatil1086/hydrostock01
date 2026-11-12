<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.hydrostock.model.Material"%>
<%@ page import="com.hydrostock.model.PurchaseOrder"%>
<%@ page import="com.hydrostock.model.Bill"%>
<%@ page import="com.hydrostock.model.StockTransaction"%>
<%@ include file="/includes/header.jsp" %>
<%@ include file="/includes/sidebar.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold text-dark mb-1">Plant Inventory &amp; Financial Reports</h3>
        <p class="text-muted mb-0" style="font-size: 0.88rem;">Audit ledger, stock valuation, and procurement summary</p>
    </div>
    <button class="btn btn-outline-secondary btn-sm" onclick="window.print()">
        <i class="fa-solid fa-print me-1"></i> Print / Export Report
    </button>
</div>

<!-- Financial Summary Widgets -->
<div class="row g-3 mb-4">
    <div class="col-md-6">
        <div class="kpi-card">
            <div>
                <div class="kpi-value" style="color: #0A2540;">
                    ₹ <%= String.format("%,.2f", (Double) request.getAttribute("totalValuation")) %>
                </div>
                <div class="kpi-label">Current Spares Inventory Valuation (Asset)</div>
            </div>
            <div class="kpi-icon icon-blue">
                <i class="fa-solid fa-warehouse"></i>
            </div>
        </div>
    </div>
    <div class="col-md-6">
        <div class="kpi-card">
            <div>
                <div class="kpi-value" style="color: #00A896;">
                    ₹ <%= String.format("%,.2f", (Double) request.getAttribute("totalBilled")) %>
                </div>
                <div class="kpi-label">Total Invoiced Procurement (FY 2026-2027)</div>
            </div>
            <div class="kpi-icon icon-cyan">
                <i class="fa-solid fa-file-invoice-dollar"></i>
            </div>
        </div>
    </div>
</div>

<!-- Materials Stock Valuation Ledger -->
<div class="panel-card mb-4">
    <div class="panel-header">
        <h5 class="panel-title"><i class="fa-solid fa-boxes-stacked me-2 text-primary"></i>Stock Inventory Valuation Matrix</h5>
    </div>
    <div class="table-responsive">
        <table class="table table-hover mb-0">
            <thead>
                <tr>
                    <th>Code</th>
                    <th>Material Name</th>
                    <th>Category</th>
                    <th class="text-center">Current Stock</th>
                    <th class="text-end">Unit Rate (₹)</th>
                    <th class="text-end">Total Valuation (₹)</th>
                    <th class="text-center">Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Material> mats = (List<Material>) request.getAttribute("materials");
                    if (mats != null) {
                        for (Material m : mats) {
                %>
                    <tr>
                        <td><code><%= m.getMaterialCode() %></code></td>
                        <td class="fw-semibold"><%= m.getMaterialName() %></td>
                        <td><%= m.getCategoryName() %></td>
                        <td class="text-center fw-bold"><%= m.getCurrentStock() %> <%= m.getUnitOfMeasure() %></td>
                        <td class="text-end">₹ <%= String.format("%,.2f", m.getUnitPrice()) %></td>
                        <td class="text-end fw-bold text-dark">₹ <%= String.format("%,.2f", m.getTotalStockValue()) %></td>
                        <td class="text-center">
                            <% if (m.isLowStock()) { %>
                                <span class="badge bg-danger">Critical</span>
                            <% } else { %>
                                <span class="badge bg-success">Adequate</span>
                            <% } %>
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

<!-- Recent Stock Inward / Outward Movement -->
<div class="panel-card">
    <div class="panel-header">
        <h5 class="panel-title"><i class="fa-solid fa-clock-rotate-left me-2 text-warning"></i>Audit Trail: Recent Stock Inward &amp; Outward Transactions</h5>
    </div>
    <div class="table-responsive">
        <table class="table table-hover mb-0">
            <thead>
                <tr>
                    <th>Date &amp; Time</th>
                    <th>Type</th>
                    <th>Material Code &amp; Name</th>
                    <th>Quantity</th>
                    <th>Reference / DC No</th>
                    <th>Logged By</th>
                    <th>Remarks</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<StockTransaction> txs = (List<StockTransaction>) request.getAttribute("transactions");
                    if (txs != null) {
                        for (StockTransaction t : txs) {
                %>
                    <tr>
                        <td class="small"><%= t.getTransactionDate() %></td>
                        <td>
                            <span class="badge <%= "INWARD".equalsIgnoreCase(t.getTransactionType()) ? "bg-success" : "bg-danger" %>">
                                <%= t.getTransactionType() %>
                            </span>
                        </td>
                        <td class="fw-semibold"><%= t.getMaterialCode() %> - <%= t.getMaterialName() %></td>
                        <td class="fw-bold"><%= t.getQuantity() %></td>
                        <td><code><%= t.getReferenceNo() %></code></td>
                        <td><%= t.getCreatedBy() %></td>
                        <td class="small text-muted"><%= t.getRemarks() != null ? t.getRemarks() : "-" %></td>
                    </tr>
                <%
                        }
                    }
                %>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>
