package com.hydrostock.model;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

public class MaintenanceRecord implements Serializable {
    private static final long serialVersionUID = 1L;

    private int maintenanceId;
    private int equipmentId;
    private String equipmentCode;
    private String equipmentName;
    private String locationPlantUnit;
    private String issueDescription;
    private String performedBy;
    private Integer materialUsedId;
    private String materialName;
    private int quantityUsed;
    private Date maintenanceDate;
    private String status; // SCHEDULED, IN_PROGRESS, COMPLETED
    private String remarks;
    private Timestamp createdAt;

    public MaintenanceRecord() {}

    public int getMaintenanceId() { return maintenanceId; }
    public void setMaintenanceId(int maintenanceId) { this.maintenanceId = maintenanceId; }

    public int getEquipmentId() { return equipmentId; }
    public void setEquipmentId(int equipmentId) { this.equipmentId = equipmentId; }

    public String getEquipmentCode() { return equipmentCode; }
    public void setEquipmentCode(String equipmentCode) { this.equipmentCode = equipmentCode; }

    public String getEquipmentName() { return equipmentName; }
    public void setEquipmentName(String equipmentName) { this.equipmentName = equipmentName; }

    public String getLocationPlantUnit() { return locationPlantUnit; }
    public void setLocationPlantUnit(String locationPlantUnit) { this.locationPlantUnit = locationPlantUnit; }

    public String getIssueDescription() { return issueDescription; }
    public void setIssueDescription(String issueDescription) { this.issueDescription = issueDescription; }

    public String getPerformedBy() { return performedBy; }
    public void setPerformedBy(String performedBy) { this.performedBy = performedBy; }

    public Integer getMaterialUsedId() { return materialUsedId; }
    public void setMaterialUsedId(Integer materialUsedId) { this.materialUsedId = materialUsedId; }

    public String getMaterialName() { return materialName; }
    public void setMaterialName(String materialName) { this.materialName = materialName; }

    public int getQuantityUsed() { return quantityUsed; }
    public void setQuantityUsed(int quantityUsed) { this.quantityUsed = quantityUsed; }

    public Date getMaintenanceDate() { return maintenanceDate; }
    public void setMaintenanceDate(Date maintenanceDate) { this.maintenanceDate = maintenanceDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getRemarks() { return remarks; }
    public void setRemarks(String remarks) { this.remarks = remarks; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
