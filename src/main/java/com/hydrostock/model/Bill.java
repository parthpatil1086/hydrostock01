package com.hydrostock.model;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

public class Bill implements Serializable {
    private static final long serialVersionUID = 1L;

    private int invoiceId;
    private String invoiceNumber;
    private int poId;
    private String poNumber;
    private String supplierName;
    private String supplierGst;
    private Date invoiceDate;
    private double subtotal;
    private double cgstRate;
    private double cgstAmount;
    private double sgstRate;
    private double sgstAmount;
    private double igstRate;
    private double igstAmount;
    private double grandTotal;
    private String paymentStatus; // UNPAID, PARTIALLY_PAID, PAID
    private Timestamp createdAt;

    public Bill() {}

    public int getInvoiceId() { return invoiceId; }
    public void setInvoiceId(int invoiceId) { this.invoiceId = invoiceId; }

    public String getInvoiceNumber() { return invoiceNumber; }
    public void setInvoiceNumber(String invoiceNumber) { this.invoiceNumber = invoiceNumber; }

    public int getPoId() { return poId; }
    public void setPoId(int poId) { this.poId = poId; }

    public String getPoNumber() { return poNumber; }
    public void setPoNumber(String poNumber) { this.poNumber = poNumber; }

    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }

    public String getSupplierGst() { return supplierGst; }
    public void setSupplierGst(String supplierGst) { this.supplierGst = supplierGst; }

    public Date getInvoiceDate() { return invoiceDate; }
    public void setInvoiceDate(Date invoiceDate) { this.invoiceDate = invoiceDate; }

    public double getSubtotal() { return subtotal; }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }

    public double getCgstRate() { return cgstRate; }
    public void setCgstRate(double cgstRate) { this.cgstRate = cgstRate; }

    public double getCgstAmount() { return cgstAmount; }
    public void setCgstAmount(double cgstAmount) { this.cgstAmount = cgstAmount; }

    public double getSgstRate() { return sgstRate; }
    public void setSgstRate(double sgstRate) { this.sgstRate = sgstRate; }

    public double getSgstAmount() { return sgstAmount; }
    public void setSgstAmount(double sgstAmount) { this.sgstAmount = sgstAmount; }

    public double getIgstRate() { return igstRate; }
    public void setIgstRate(double igstRate) { this.igstRate = igstRate; }

    public double getIgstAmount() { return igstAmount; }
    public void setIgstAmount(double igstAmount) { this.igstAmount = igstAmount; }

    public double getGrandTotal() { return grandTotal; }
    public void setGrandTotal(double grandTotal) { this.grandTotal = grandTotal; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
