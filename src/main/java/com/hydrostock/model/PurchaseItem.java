package com.hydrostock.model;

import java.io.Serializable;

public class PurchaseItem implements Serializable {
    private static final long serialVersionUID = 1L;

    private int itemId;
    private int poId;
    private int materialId;
    private String materialCode;
    private String materialName;
    private String unitOfMeasure;
    private int quantity;
    private double unitPrice;
    private double subtotal;

    public PurchaseItem() {}

    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }

    public int getPoId() { return poId; }
    public void setPoId(int poId) { this.poId = poId; }

    public int getMaterialId() { return materialId; }
    public void setMaterialId(int materialId) { this.materialId = materialId; }

    public String getMaterialCode() { return materialCode; }
    public void setMaterialCode(String materialCode) { this.materialCode = materialCode; }

    public String getMaterialName() { return materialName; }
    public void setMaterialName(String materialName) { this.materialName = materialName; }

    public String getUnitOfMeasure() { return unitOfMeasure; }
    public void setUnitOfMeasure(String unitOfMeasure) { this.unitOfMeasure = unitOfMeasure; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }

    public double getSubtotal() { return subtotal; }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }
}
