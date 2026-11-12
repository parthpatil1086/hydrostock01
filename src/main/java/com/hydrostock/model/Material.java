package com.hydrostock.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Material implements Serializable {
    private static final long serialVersionUID = 1L;

    private int materialId;
    private String materialCode;
    private String materialName;
    private int categoryId;
    private String categoryName;
    private String unitOfMeasure;
    private int currentStock;
    private int minStockLevel;
    private double unitPrice;
    private String locationRack;
    private Timestamp createdAt;

    public Material() {}

    public int getMaterialId() { return materialId; }
    public void setMaterialId(int materialId) { this.materialId = materialId; }

    public String getMaterialCode() { return materialCode; }
    public void setMaterialCode(String materialCode) { this.materialCode = materialCode; }

    public String getMaterialName() { return materialName; }
    public void setMaterialName(String materialName) { this.materialName = materialName; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getUnitOfMeasure() { return unitOfMeasure; }
    public void setUnitOfMeasure(String unitOfMeasure) { this.unitOfMeasure = unitOfMeasure; }

    public int getCurrentStock() { return currentStock; }
    public void setCurrentStock(int currentStock) { this.currentStock = currentStock; }

    public int getMinStockLevel() { return minStockLevel; }
    public void setMinStockLevel(int minStockLevel) { this.minStockLevel = minStockLevel; }

    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }

    public String getLocationRack() { return locationRack; }
    public void setLocationRack(String locationRack) { this.locationRack = locationRack; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public boolean isLowStock() {
        return this.currentStock <= this.minStockLevel;
    }

    public double getTotalStockValue() {
        return this.currentStock * this.unitPrice;
    }
}
