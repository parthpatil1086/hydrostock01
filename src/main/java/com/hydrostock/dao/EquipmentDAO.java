package com.hydrostock.dao;

import com.hydrostock.config.DBConnection;
import com.hydrostock.model.Equipment;
import com.hydrostock.model.MaintenanceRecord;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EquipmentDAO {

    public List<Equipment> getAllEquipment() {
        List<Equipment> list = new ArrayList<>();
        String sql = "SELECT equipment_id, equipment_code, equipment_name, location_plant_unit, installation_date, status " +
                     "FROM equipment ORDER BY equipment_code ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Equipment eq = new Equipment();
                eq.setEquipmentId(rs.getInt("equipment_id"));
                eq.setEquipmentCode(rs.getString("equipment_code"));
                eq.setEquipmentName(rs.getString("equipment_name"));
                eq.setLocationPlantUnit(rs.getString("location_plant_unit"));
                eq.setInstallationDate(rs.getDate("installation_date"));
                eq.setStatus(rs.getString("status"));
                list.add(eq);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<MaintenanceRecord> getAllMaintenanceRecords() {
        List<MaintenanceRecord> list = new ArrayList<>();
        String sql = "SELECT mr.maintenance_id, mr.equipment_id, eq.equipment_code, eq.equipment_name, eq.location_plant_unit, " +
                     "mr.issue_description, mr.performed_by, mr.material_used_id, m.material_name, mr.quantity_used, " +
                     "mr.maintenance_date, mr.status, mr.remarks, mr.created_at " +
                     "FROM maintenance_records mr " +
                     "INNER JOIN equipment eq ON mr.equipment_id = eq.equipment_id " +
                     "LEFT JOIN materials m ON mr.material_used_id = m.material_id " +
                     "ORDER BY mr.maintenance_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                MaintenanceRecord mr = new MaintenanceRecord();
                mr.setMaintenanceId(rs.getInt("maintenance_id"));
                mr.setEquipmentId(rs.getInt("equipment_id"));
                mr.setEquipmentCode(rs.getString("equipment_code"));
                mr.setEquipmentName(rs.getString("equipment_name"));
                mr.setLocationPlantUnit(rs.getString("location_plant_unit"));
                mr.setIssueDescription(rs.getString("issue_description"));
                mr.setPerformedBy(rs.getString("performed_by"));
                int mid = rs.getInt("material_used_id");
                if (!rs.wasNull()) {
                    mr.setMaterialUsedId(mid);
                }
                mr.setMaterialName(rs.getString("material_name"));
                mr.setQuantityUsed(rs.getInt("quantity_used"));
                mr.setMaintenanceDate(rs.getDate("maintenance_date"));
                mr.setStatus(rs.getString("status"));
                mr.setRemarks(rs.getString("remarks"));
                mr.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(mr);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addMaintenanceRecord(MaintenanceRecord mr) {
        String sql = "INSERT INTO maintenance_records (equipment_id, issue_description, performed_by, " +
                     "material_used_id, quantity_used, maintenance_date, status, remarks) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, mr.getEquipmentId());
            ps.setString(2, mr.getIssueDescription());
            ps.setString(3, mr.getPerformedBy());
            if (mr.getMaterialUsedId() != null && mr.getMaterialUsedId() > 0) {
                ps.setInt(4, mr.getMaterialUsedId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setInt(5, mr.getQuantityUsed());
            ps.setDate(6, mr.getMaintenanceDate());
            ps.setString(7, mr.getStatus());
            ps.setString(8, mr.getRemarks());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getMaintenanceRequiredCount() {
        String sql = "SELECT COUNT(*) FROM equipment WHERE status IN ('MAINTENANCE_REQUIRED', 'UNDER_REPAIR')";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
