package com.hydrostock.model;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class PurchaseOrder implements Serializable {
    private static final long serialVersionUID = 1L;

    private int poId;
    private String poNumber;
    private int supplierId;
    private String supplierName;
    private String supplierGst;
    private Date orderDate;
    private Date expectedDelivery;
    private double totalAmount;
    private String status; // PENDING, APPROVED, DISPATCHED, DELIVERED, CANCELLED
    private String createdBy;
    private String approvedBy;
    private String notes;
    private Timestamp createdAt;

    private List<PurchaseItem> items = new ArrayList<>();

    public PurchaseOrder() {}

    public int getPoId() { return poId; }
    public void setPoId(int poId) { this.poId = poId; }

    public String getPoNumber() { return poNumber; }
    public void setPoNumber(String poNumber) { this.poNumber = poNumber; }

    public int getSupplierId() { return supplierId; }
    public void setSupplierId(int supplierId) { this.supplierId = supplierId; }

    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }

    public String getSupplierGst() { return supplierGst; }
    public void setSupplierGst(String supplierGst) { this.supplierGst = supplierGst; }

    public Date getOrderDate() { return orderDate; }
    public void setOrderDate(Date orderDate) { this.orderDate = orderDate; }

    public Date getExpectedDelivery() { return expectedDelivery; }
    public void setExpectedDelivery(Date expectedDelivery) { this.expectedDelivery = expectedDelivery; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCreatedBy() { return createdBy; }
    public void setCreatedBy(String createdBy) { this.createdBy = createdBy; }

    public String getApprovedBy() { return approvedBy; }
    public void setApprovedBy(String approvedBy) { this.approvedBy = approvedBy; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public List<PurchaseItem> getItems() { return items; }
    public void setItems(List<PurchaseItem> items) { this.items = items; }
}
