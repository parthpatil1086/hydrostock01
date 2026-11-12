package com.hydrostock.dao;

import com.hydrostock.config.DBConnection;
import com.hydrostock.model.StockTransaction;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StockDAO {

    public boolean recordStockInward(int materialId, int quantity, String referenceNo, String remarks, String createdBy) {
        if (materialId <= 0 || quantity <= 0 || referenceNo == null || referenceNo.trim().isEmpty()) {
            return false;
        }
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Atomic transaction

            // 1. Insert transaction log
            String txSql = "INSERT INTO stock_transactions (material_id, transaction_type, quantity, reference_no, remarks, created_by) " +
                           "VALUES (?, 'INWARD', ?, ?, ?, ?)";
            try (PreparedStatement psTx = conn.prepareStatement(txSql)) {
                psTx.setInt(1, materialId);
                psTx.setInt(2, quantity);
                psTx.setString(3, referenceNo);
                psTx.setString(4, remarks);
                psTx.setString(5, createdBy);
                psTx.executeUpdate();
            }

            // 2. Increment stock in materials table
            String stockSql = "UPDATE materials SET current_stock = current_stock + ? WHERE material_id = ?";
            try (PreparedStatement psStock = conn.prepareStatement(stockSql)) {
                psStock.setInt(1, quantity);
                psStock.setInt(2, materialId);
                psStock.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        }
    }

    public boolean recordStockOutward(int materialId, int quantity, String referenceNo, String remarks, String createdBy) throws Exception {
        if (materialId <= 0 || quantity <= 0) {
            throw new Exception("Quantity must be a positive integer and a material must be selected.");
        }
        if (referenceNo == null || referenceNo.trim().isEmpty()) {
            throw new Exception("Reference / Challan number cannot be blank.");
        }
        if (remarks == null || remarks.trim().isEmpty()) {
            throw new Exception("Equipment / Purpose is required for stock outward.");
        }
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Check current stock sufficiency
            String checkSql = "SELECT current_stock, material_name FROM materials WHERE material_id = ?";
            int currentStock = 0;
            try (PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
                psCheck.setInt(1, materialId);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next()) {
                        currentStock = rs.getInt("current_stock");
                    } else {
                        throw new Exception("Material ID not found.");
                    }
                }
            }

            if (currentStock < quantity) {
                throw new Exception("Insufficient stock available. Current balance: " + currentStock + ", Requested: " + quantity + ".");
            }

            // 2. Insert transaction log
            String txSql = "INSERT INTO stock_transactions (material_id, transaction_type, quantity, reference_no, remarks, created_by) " +
                           "VALUES (?, 'OUTWARD', ?, ?, ?, ?)";
            try (PreparedStatement psTx = conn.prepareStatement(txSql)) {
                psTx.setInt(1, materialId);
                psTx.setInt(2, quantity);
                psTx.setString(3, referenceNo);
                psTx.setString(4, remarks);
                psTx.setString(5, createdBy);
                psTx.executeUpdate();
            }

            // 3. Decrement stock
            String stockSql = "UPDATE materials SET current_stock = current_stock - ? WHERE material_id = ? AND current_stock >= ?";
            try (PreparedStatement psStock = conn.prepareStatement(stockSql)) {
                psStock.setInt(1, quantity);
                psStock.setInt(2, materialId);
                psStock.setInt(3, quantity);
                if (psStock.executeUpdate() != 1) {
                    throw new Exception("Insufficient stock available. Current balance: " + currentStock + ", Requested: " + quantity + ".");
                }
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            throw e;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        }
    }

    public List<StockTransaction> getAllTransactions() {
        List<StockTransaction> list = new ArrayList<>();
        String sql = "SELECT t.transaction_id, t.material_id, m.material_code, m.material_name, " +
                     "t.transaction_type, t.quantity, t.reference_no, t.remarks, t.created_by, t.transaction_date " +
                     "FROM stock_transactions t INNER JOIN materials m ON t.material_id = m.material_id " +
                     "ORDER BY t.transaction_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                StockTransaction st = new StockTransaction();
                st.setTransactionId(rs.getInt("transaction_id"));
                st.setMaterialId(rs.getInt("material_id"));
                st.setMaterialCode(rs.getString("material_code"));
                st.setMaterialName(rs.getString("material_name"));
                st.setTransactionType(rs.getString("transaction_type"));
                st.setQuantity(rs.getInt("quantity"));
                st.setReferenceNo(rs.getString("reference_no"));
                st.setRemarks(rs.getString("remarks"));
                st.setCreatedBy(rs.getString("created_by"));
                st.setTransactionDate(rs.getTimestamp("transaction_date"));
                list.add(st);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
