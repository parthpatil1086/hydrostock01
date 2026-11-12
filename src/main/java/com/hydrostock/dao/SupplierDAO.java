package com.hydrostock.dao;

import com.hydrostock.config.DBConnection;
import com.hydrostock.model.Supplier;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SupplierDAO {

    public List<Supplier> getAllSuppliers() {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT supplier_id, user_id, company_name, contact_person, gst_number, phone, email, address, rating, status, created_at " +
                     "FROM suppliers ORDER BY company_name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToSupplier(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Supplier getSupplierById(int supplierId) {
        String sql = "SELECT supplier_id, user_id, company_name, contact_person, gst_number, phone, email, address, rating, status, created_at " +
                     "FROM suppliers WHERE supplier_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSupplier(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Supplier getSupplierByUserId(int userId) {
        String sql = "SELECT supplier_id, user_id, company_name, contact_person, gst_number, phone, email, address, rating, status, created_at " +
                     "FROM suppliers WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSupplier(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addSupplier(Supplier s) {
        String sql = "INSERT INTO suppliers (user_id, company_name, contact_person, gst_number, phone, email, address, rating, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (s.getUserId() != null && s.getUserId() > 0) {
                ps.setInt(1, s.getUserId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, s.getCompanyName());
            ps.setString(3, s.getContactPerson());
            ps.setString(4, s.getGstNumber());
            ps.setString(5, s.getPhone());
            ps.setString(6, s.getEmail());
            ps.setString(7, s.getAddress());
            ps.setDouble(8, s.getRating() > 0 ? s.getRating() : 4.5);
            ps.setString(9, s.getStatus() != null ? s.getStatus() : "ACTIVE");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateSupplier(Supplier s) {
        String sql = "UPDATE suppliers SET company_name = ?, contact_person = ?, gst_number = ?, phone = ?, " +
                     "email = ?, address = ?, rating = ?, status = ? WHERE supplier_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getCompanyName());
            ps.setString(2, s.getContactPerson());
            ps.setString(3, s.getGstNumber());
            ps.setString(4, s.getPhone());
            ps.setString(5, s.getEmail());
            ps.setString(6, s.getAddress());
            ps.setDouble(7, s.getRating());
            ps.setString(8, s.getStatus());
            ps.setInt(9, s.getSupplierId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteSupplier(int supplierId) {
        String sql = "DELETE FROM suppliers WHERE supplier_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getTotalSuppliersCount() {
        String sql = "SELECT COUNT(*) FROM suppliers";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Supplier mapResultSetToSupplier(ResultSet rs) throws SQLException {
        Supplier s = new Supplier();
        s.setSupplierId(rs.getInt("supplier_id"));
        int uid = rs.getInt("user_id");
        if (!rs.wasNull()) {
            s.setUserId(uid);
        }
        s.setCompanyName(rs.getString("company_name"));
        s.setContactPerson(rs.getString("contact_person"));
        s.setGstNumber(rs.getString("gst_number"));
        s.setPhone(rs.getString("phone"));
        s.setEmail(rs.getString("email"));
        s.setAddress(rs.getString("address"));
        s.setRating(rs.getDouble("rating"));
        s.setStatus(rs.getString("status"));
        s.setCreatedAt(rs.getTimestamp("created_at"));
        return s;
    }
}
