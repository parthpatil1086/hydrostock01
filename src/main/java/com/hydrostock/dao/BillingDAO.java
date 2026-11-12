package com.hydrostock.dao;

import com.hydrostock.config.DBConnection;
import com.hydrostock.model.Bill;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BillingDAO {

    public List<Bill> getAllInvoices() {
        List<Bill> list = new ArrayList<>();
        String sql = "SELECT i.invoice_id, i.invoice_number, i.po_id, po.po_number, s.company_name, s.gst_number, " +
                     "i.invoice_date, i.subtotal, i.cgst_rate, i.cgst_amount, i.sgst_rate, i.sgst_amount, " +
                     "i.igst_rate, i.igst_amount, i.grand_total, i.payment_status, i.created_at " +
                     "FROM invoices i " +
                     "INNER JOIN purchase_orders po ON i.po_id = po.po_id " +
                     "INNER JOIN suppliers s ON po.supplier_id = s.supplier_id " +
                     "ORDER BY i.invoice_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToBill(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Bill> getInvoicesBySupplier(int supplierId) {
        List<Bill> list = new ArrayList<>();
        String sql = "SELECT i.invoice_id, i.invoice_number, i.po_id, po.po_number, s.company_name, s.gst_number, " +
                     "i.invoice_date, i.subtotal, i.cgst_rate, i.cgst_amount, i.sgst_rate, i.sgst_amount, " +
                     "i.igst_rate, i.igst_amount, i.grand_total, i.payment_status, i.created_at " +
                     "FROM invoices i " +
                     "INNER JOIN purchase_orders po ON i.po_id = po.po_id " +
                     "INNER JOIN suppliers s ON po.supplier_id = s.supplier_id " +
                     "WHERE s.supplier_id = ? " +
                     "ORDER BY i.invoice_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToBill(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Bill getInvoiceById(int invoiceId) {
        String sql = "SELECT i.invoice_id, i.invoice_number, i.po_id, po.po_number, s.company_name, s.gst_number, " +
                     "i.invoice_date, i.subtotal, i.cgst_rate, i.cgst_amount, i.sgst_rate, i.sgst_amount, " +
                     "i.igst_rate, i.igst_amount, i.grand_total, i.payment_status, i.created_at " +
                     "FROM invoices i " +
                     "INNER JOIN purchase_orders po ON i.po_id = po.po_id " +
                     "INNER JOIN suppliers s ON po.supplier_id = s.supplier_id " +
                     "WHERE i.invoice_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBill(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean createInvoice(Bill bill) {
        String sql = "INSERT INTO invoices (invoice_number, po_id, invoice_date, subtotal, " +
                     "cgst_rate, cgst_amount, sgst_rate, sgst_amount, igst_rate, igst_amount, " +
                     "grand_total, payment_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, bill.getInvoiceNumber());
            ps.setInt(2, bill.getPoId());
            ps.setDate(3, bill.getInvoiceDate());
            ps.setDouble(4, bill.getSubtotal());
            ps.setDouble(5, bill.getCgstRate());
            ps.setDouble(6, bill.getCgstAmount());
            ps.setDouble(7, bill.getSgstRate());
            ps.setDouble(8, bill.getSgstAmount());
            ps.setDouble(9, bill.getIgstRate());
            ps.setDouble(10, bill.getIgstAmount());
            ps.setDouble(11, bill.getGrandTotal());
            ps.setString(12, bill.getPaymentStatus() != null ? bill.getPaymentStatus() : "UNPAID");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean recordPayment(int invoiceId, Date paymentDate, double amount, String mode, String reference, String notes) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            if (invoiceId <= 0 || amount <= 0 || reference == null || reference.trim().isEmpty()) {
                return false;
            }

            double grandTotal;
            double paidSoFar;
            String balanceSql = "SELECT i.grand_total, COALESCE(SUM(p.amount_paid), 0) AS paid_so_far " +
                    "FROM invoices i LEFT JOIN payments p ON p.invoice_id = i.invoice_id " +
                    "WHERE i.invoice_id = ? GROUP BY i.invoice_id, i.grand_total FOR UPDATE";
            try (PreparedStatement psBalance = conn.prepareStatement(balanceSql)) {
                psBalance.setInt(1, invoiceId);
                try (ResultSet rs = psBalance.executeQuery()) {
                    if (!rs.next()) return false;
                    grandTotal = rs.getDouble("grand_total");
                    paidSoFar = rs.getDouble("paid_so_far");
                }
            }
            if (amount > grandTotal - paidSoFar + 0.005) {
                return false;
            }

            String paySql = "INSERT INTO payments (invoice_id, payment_date, amount_paid, payment_mode, transaction_reference, notes) " +
                            "VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement psPay = conn.prepareStatement(paySql)) {
                psPay.setInt(1, invoiceId);
                psPay.setDate(2, paymentDate);
                psPay.setDouble(3, amount);
                psPay.setString(4, mode);
                psPay.setString(5, reference);
                psPay.setString(6, notes);
                psPay.executeUpdate();
            }

            // Update invoice payment status from the actual accumulated balance.
            String updateSql = "UPDATE invoices SET payment_status = CASE " +
                    "WHEN (SELECT COALESCE(SUM(amount_paid), 0) FROM payments WHERE invoice_id = ?) >= grand_total THEN 'PAID' " +
                    "WHEN (SELECT COALESCE(SUM(amount_paid), 0) FROM payments WHERE invoice_id = ?) > 0 THEN 'PARTIALLY_PAID' " +
                    "ELSE 'UNPAID' END WHERE invoice_id = ?";
            try (PreparedStatement psUp = conn.prepareStatement(updateSql)) {
                psUp.setInt(1, invoiceId);
                psUp.setInt(2, invoiceId);
                psUp.setInt(3, invoiceId);
                if (psUp.executeUpdate() != 1) return false;
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

    public double getTotalBilledAmount() {
        String sql = "SELECT SUM(grand_total) FROM invoices";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    private Bill mapResultSetToBill(ResultSet rs) throws SQLException {
        Bill b = new Bill();
        b.setInvoiceId(rs.getInt("invoice_id"));
        b.setInvoiceNumber(rs.getString("invoice_number"));
        b.setPoId(rs.getInt("po_id"));
        b.setPoNumber(rs.getString("po_number"));
        b.setSupplierName(rs.getString("company_name"));
        b.setSupplierGst(rs.getString("gst_number"));
        b.setInvoiceDate(rs.getDate("invoice_date"));
        b.setSubtotal(rs.getDouble("subtotal"));
        b.setCgstRate(rs.getDouble("cgst_rate"));
        b.setCgstAmount(rs.getDouble("cgst_amount"));
        b.setSgstRate(rs.getDouble("sgst_rate"));
        b.setSgstAmount(rs.getDouble("sgst_amount"));
        b.setIgstRate(rs.getDouble("igst_rate"));
        b.setIgstAmount(rs.getDouble("igst_amount"));
        b.setGrandTotal(rs.getDouble("grand_total"));
        b.setPaymentStatus(rs.getString("payment_status"));
        b.setCreatedAt(rs.getTimestamp("created_at"));
        return b;
    }
}
