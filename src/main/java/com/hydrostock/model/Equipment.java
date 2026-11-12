package com.hydrostock.model;

import java.io.Serializable;
import java.sql.Date;

public class Equipment implements Serializable {
    private static final long serialVersionUID = 1L;

    private int equipmentId;
    private String equipmentCode;
    private String equipmentName;
    private String locationPlantUnit;
    private Date installationDate;
    private String status; // OPERATIONAL, MAINTENANCE_REQUIRED, UNDER_REPAIR, STANDBY

    public Equipment() {}

    public int getEquipmentId() { return equipmentId; }
    public void setEquipmentId(int equipmentId) { this.equipmentId = equipmentId; }

    public String getEquipmentCode() { return equipmentCode; }
    public void setEquipmentCode(String equipmentCode) { this.equipmentCode = equipmentCode; }

    public String getEquipmentName() { return equipmentName; }
    public void setEquipmentName(String equipmentName) { this.equipmentName = equipmentName; }

    public String getLocationPlantUnit() { return locationPlantUnit; }
    public void setLocationPlantUnit(String locationPlantUnit) { this.locationPlantUnit = locationPlantUnit; }

    public Date getInstallationDate() { return installationDate; }
    public void setInstallationDate(Date installationDate) { this.installationDate = installationDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
