package com.hydrostock.dao;

import com.hydrostock.config.DBConnection;
import com.hydrostock.model.PurchaseItem;
import com.hydrostock.model.PurchaseOrder;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PurchaseDAO {

    public List<PurchaseOrder> getAllPurchaseOrders() {
        List<PurchaseOrder> list = new ArrayList<>();
        String sql = "SELECT po.po_id, po.po_number, po.supplier_id, s.company_name, s.gst_number, " +
                     "po.order_date, po.expected_delivery, po.total_amount, po.status, po.created_by, " +
                     "po.approved_by, po.notes, po.created_at " +
                     "FROM purchase_orders po INNER JOIN suppliers s ON po.supplier_id = s.supplier_id " +
                     "ORDER BY po.po_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToPO(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<PurchaseOrder> getPurchaseOrdersBySupplier(int supplierId) {
        List<PurchaseOrder> list = new ArrayList<>();
        String sql = "SELECT po.po_id, po.po_number, po.supplier_id, s.company_name, s.gst_number, " +
                     "po.order_date, po.expected_delivery, po.total_amount, po.status, po.created_by, " +
                     "po.approved_by, po.notes, po.created_at " +
                     "FROM purchase_orders po INNER JOIN suppliers s ON po.supplier_id = s.supplier_id " +
                     "WHERE po.supplier_id = ? ORDER BY po.po_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToPO(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public PurchaseOrder getPurchaseOrderById(int poId) {
        String sql = "SELECT po.po_id, po.po_number, po.supplier_id, s.company_name, s.gst_number, " +
                     "po.order_date, po.expected_delivery, po.total_amount, po.status, po.created_by, " +
                     "po.approved_by, po.notes, po.created_at " +
                     "FROM purchase_orders po INNER JOIN suppliers s ON po.supplier_id = s.supplier_id " +
                     "WHERE po.po_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, poId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    PurchaseOrder po = mapResultSetToPO(rs);
                    po.setItems(getItemsForPO(poId));
                    return po;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<PurchaseItem> getItemsForPO(int poId) {
        List<PurchaseItem> items = new ArrayList<>();
        String sql = "SELECT pi.item_id, pi.po_id, pi.material_id, m.material_code, m.material_name, " +
                     "m.unit_of_measure, pi.quantity, pi.unit_price, pi.subtotal " +
                     "FROM purchase_items pi INNER JOIN materials m ON pi.material_id = m.material_id " +
                     "WHERE pi.po_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, poId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PurchaseItem item = new PurchaseItem();
                    item.setItemId(rs.getInt("item_id"));
                    item.setPoId(rs.getInt("po_id"));
                    item.setMaterialId(rs.getInt("material_id"));
                    item.setMaterialCode(rs.getString("material_code"));
                    item.setMaterialName(rs.getString("material_name"));
                    item.setUnitOfMeasure(rs.getString("unit_of_measure"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setUnitPrice(rs.getDouble("unit_price"));
                    item.setSubtotal(rs.getDouble("subtotal"));
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    public boolean createPurchaseOrder(PurchaseOrder po, List<PurchaseItem> items) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String poSql = "INSERT INTO purchase_orders (po_number, supplier_id, order_date, expected_delivery, " +
                           "total_amount, status, created_by, notes) VALUES (?, ?, ?, ?, ?, 'PENDING', ?, ?)";
            int generatedPoId = 0;
            try (PreparedStatement psPo = conn.prepareStatement(poSql, Statement.RETURN_GENERATED_KEYS)) {
                psPo.setString(1, po.getPoNumber());
                psPo.setInt(2, po.getSupplierId());
                psPo.setDate(3, po.getOrderDate());
                psPo.setDate(4, po.getExpectedDelivery());
                psPo.setDouble(5, po.getTotalAmount());
                psPo.setString(6, po.getCreatedBy());
                psPo.setString(7, po.getNotes());
                psPo.executeUpdate();

                try (ResultSet rsKey = psPo.getGeneratedKeys()) {
                    if (rsKey.next()) {
                        generatedPoId = rsKey.getInt(1);
                    }
                }
            }

            if (generatedPoId == 0) {
                conn.rollback();
                return false;
            }

            String itemSql = "INSERT INTO purchase_items (po_id, material_id, quantity, unit_price, subtotal) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement psItem = conn.prepareStatement(itemSql)) {
                for (PurchaseItem item : items) {
                    psItem.setInt(1, generatedPoId);
                    psItem.setInt(2, item.getMaterialId());
                    psItem.setInt(3, item.getQuantity());
                    psItem.setDouble(4, item.getUnitPrice());
                    psItem.setDouble(5, item.getSubtotal());
                    psItem.addBatch();
                }
                psItem.executeBatch();
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

    public boolean updatePOStatus(int poId, String status, String approvedBy) {
        String sql = "UPDATE purchase_orders SET status = ?, approved_by = COALESCE(?, approved_by) WHERE po_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, approvedBy);
            ps.setInt(3, poId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getOpenPOCount() {
        String sql = "SELECT COUNT(*) FROM purchase_orders WHERE status IN ('PENDING', 'APPROVED', 'DISPATCHED')";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private PurchaseOrder mapResultSetToPO(ResultSet rs) throws SQLException {
        PurchaseOrder po = new PurchaseOrder();
        po.setPoId(rs.getInt("po_id"));
        po.setPoNumber(rs.getString("po_number"));
        po.setSupplierId(rs.getInt("supplier_id"));
        po.setSupplierName(rs.getString("company_name"));
        po.setSupplierGst(rs.getString("gst_number"));
        po.setOrderDate(rs.getDate("order_date"));
        po.setExpectedDelivery(rs.getDate("expected_delivery"));
        po.setTotalAmount(rs.getDouble("total_amount"));
        po.setStatus(rs.getString("status"));
        po.setCreatedBy(rs.getString("created_by"));
        po.setApprovedBy(rs.getString("approved_by"));
        po.setNotes(rs.getString("notes"));
        po.setCreatedAt(rs.getTimestamp("created_at"));
        return po;
    }
}
