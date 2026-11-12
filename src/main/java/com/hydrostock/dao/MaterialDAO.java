package com.hydrostock.dao;

import com.hydrostock.config.DBConnection;
import com.hydrostock.model.Material;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MaterialDAO {

    public List<Material> getAllMaterials() {
        List<Material> list = new ArrayList<>();
        String sql = "SELECT m.material_id, m.material_code, m.material_name, m.category_id, c.category_name, " +
                     "m.unit_of_measure, m.current_stock, m.min_stock_level, m.unit_price, m.location_rack, m.created_at " +
                     "FROM materials m INNER JOIN categories c ON m.category_id = c.category_id " +
                     "ORDER BY m.material_name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToMaterial(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Material> getLowStockMaterials() {
        List<Material> list = new ArrayList<>();
        String sql = "SELECT m.material_id, m.material_code, m.material_name, m.category_id, c.category_name, " +
                     "m.unit_of_measure, m.current_stock, m.min_stock_level, m.unit_price, m.location_rack, m.created_at " +
                     "FROM materials m INNER JOIN categories c ON m.category_id = c.category_id " +
                     "WHERE m.current_stock <= m.min_stock_level ORDER BY m.current_stock ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToMaterial(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Material getMaterialById(int materialId) {
        String sql = "SELECT m.material_id, m.material_code, m.material_name, m.category_id, c.category_name, " +
                     "m.unit_of_measure, m.current_stock, m.min_stock_level, m.unit_price, m.location_rack, m.created_at " +
                     "FROM materials m INNER JOIN categories c ON m.category_id = c.category_id " +
                     "WHERE m.material_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, materialId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToMaterial(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addMaterial(Material mat) {
        String sql = "INSERT INTO materials (material_code, material_name, category_id, unit_of_measure, " +
                     "current_stock, min_stock_level, unit_price, location_rack) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, mat.getMaterialCode());
            ps.setString(2, mat.getMaterialName());
            ps.setInt(3, mat.getCategoryId());
            ps.setString(4, mat.getUnitOfMeasure());
            ps.setInt(5, mat.getCurrentStock());
            ps.setInt(6, mat.getMinStockLevel());
            ps.setDouble(7, mat.getUnitPrice());
            ps.setString(8, mat.getLocationRack());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateMaterial(Material mat) {
        String sql = "UPDATE materials SET material_code = ?, material_name = ?, category_id = ?, unit_of_measure = ?, " +
                     "min_stock_level = ?, unit_price = ?, location_rack = ? WHERE material_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, mat.getMaterialCode());
            ps.setString(2, mat.getMaterialName());
            ps.setInt(3, mat.getCategoryId());
            ps.setString(4, mat.getUnitOfMeasure());
            ps.setInt(5, mat.getMinStockLevel());
            ps.setDouble(6, mat.getUnitPrice());
            ps.setString(7, mat.getLocationRack());
            ps.setInt(8, mat.getMaterialId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteMaterial(int materialId) {
        String sql = "DELETE FROM materials WHERE material_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, materialId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getTotalMaterialsCount() {
        String sql = "SELECT COUNT(*) FROM materials";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getLowStockCount() {
        String sql = "SELECT COUNT(*) FROM materials WHERE current_stock <= min_stock_level";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double getTotalInventoryValuation() {
        String sql = "SELECT SUM(current_stock * unit_price) FROM materials";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    private Material mapResultSetToMaterial(ResultSet rs) throws SQLException {
        Material m = new Material();
        m.setMaterialId(rs.getInt("material_id"));
        m.setMaterialCode(rs.getString("material_code"));
        m.setMaterialName(rs.getString("material_name"));
        m.setCategoryId(rs.getInt("category_id"));
        m.setCategoryName(rs.getString("category_name"));
        m.setUnitOfMeasure(rs.getString("unit_of_measure"));
        m.setCurrentStock(rs.getInt("current_stock"));
        m.setMinStockLevel(rs.getInt("min_stock_level"));
        m.setUnitPrice(rs.getDouble("unit_price"));
        m.setLocationRack(rs.getString("location_rack"));
        m.setCreatedAt(rs.getTimestamp("created_at"));
        return m;
    }
}
