package com.hydrostock.controller;

import com.hydrostock.dao.BillingDAO;
import com.hydrostock.dao.PurchaseDAO;
import com.hydrostock.model.Bill;
import com.hydrostock.model.PurchaseItem;
import com.hydrostock.model.PurchaseOrder;
import com.hydrostock.model.Supplier;
import com.hydrostock.model.User;
import com.hydrostock.dao.SupplierDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.UUID;

@WebServlet(urlPatterns = {"/purchase/billing", "/purchase/generate-bill", "/purchase/invoice-print", "/purchase/pay"})
public class BillingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private BillingDAO billingDAO = new BillingDAO();
    private PurchaseDAO purchaseDAO = new PurchaseDAO();
    private SupplierDAO supplierDAO = new SupplierDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();

        if (servletPath.contains("generate-bill")) {
            List<PurchaseOrder> approvedOrders = purchaseDAO.getAllPurchaseOrders();
            req.setAttribute("orders", approvedOrders);
            req.getRequestDispatcher("/views/purchase/generate_bill.jsp").forward(req, resp);
        } else if (servletPath.contains("invoice-print")) {
            int invoiceId = Integer.parseInt(req.getParameter("id"));
            Bill invoice = billingDAO.getInvoiceById(invoiceId);
            if (invoice == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Invoice not found.");
                return;
            }
            HttpSession session = req.getSession(false);
            User viewer = session != null ? (User) session.getAttribute("currentUser") : null;
            if (viewer != null && "SUPPLIER".equalsIgnoreCase(viewer.getRoleName())) {
                Supplier supplier = supplierDAO.getSupplierByUserId(viewer.getUserId());
                PurchaseOrder invoicePo = purchaseDAO.getPurchaseOrderById(invoice.getPoId());
                if (supplier == null || invoicePo == null || supplier.getSupplierId() != invoicePo.getSupplierId()) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "You may only view your own invoices.");
                    return;
                }
            }
            List<PurchaseItem> items = purchaseDAO.getItemsForPO(invoice.getPoId());
            req.setAttribute("invoice", invoice);
            req.setAttribute("items", items);
            req.getRequestDispatcher("/views/purchase/invoice_details.jsp").forward(req, resp);
        } else {
            // Invoices & payments list
            List<Bill> invoices = billingDAO.getAllInvoices();
            req.setAttribute("invoices", invoices);
            req.getRequestDispatcher("/views/purchase/billing_list.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();

        if (servletPath.contains("pay")) {
            // Record payment
            int invoiceId;
            double amount;
            try {
                invoiceId = Integer.parseInt(req.getParameter("invoiceId"));
                amount = Double.parseDouble(req.getParameter("amountPaid"));
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/purchase/billing?error=Payment+amount+must+be+a+valid+positive+number");
                return;
            }
            String mode = req.getParameter("paymentMode");
            String ref = req.getParameter("reference");
            String notes = req.getParameter("notes");
            Date payDate = new Date(System.currentTimeMillis());

            if (amount <= 0 || ref == null || ref.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/purchase/billing?error=Disbursed+amount+must+be+positive+and+UTR+reference+is+required");
                return;
            }
            boolean recorded = billingDAO.recordPayment(invoiceId, payDate, amount, mode, ref, notes);
            resp.sendRedirect(req.getContextPath() + (recorded
                    ? "/purchase/billing?msg=Payment+recorded+successfully"
                    : "/purchase/billing?error=Payment+exceeds+the+pending+invoice+balance+or+the+invoice+does+not+exist"));
            return;
        }

        // Generate Bill with GST computation
        int poId = Integer.parseInt(req.getParameter("poId"));
        PurchaseOrder po = purchaseDAO.getPurchaseOrderById(poId);
        if (po == null) {
            resp.sendRedirect(req.getContextPath() + "/purchase/generate-bill?error=Purchase+order+not+found");
            return;
        }
        double subtotal = po.getTotalAmount();

        String gstType = req.getParameter("gstType"); // 'INTRA' (CGST+SGST) or 'INTER' (IGST)
        double cgstRate = 0.0, sgstRate = 0.0, igstRate = 0.0;
        double cgstAmount = 0.0, sgstAmount = 0.0, igstAmount = 0.0;

        if ("INTER".equalsIgnoreCase(gstType)) {
            igstRate = 18.00;
            igstAmount = subtotal * (igstRate / 100.0);
        } else {
            cgstRate = 9.00;
            sgstRate = 9.00;
            cgstAmount = subtotal * (cgstRate / 100.0);
            sgstAmount = subtotal * (sgstRate / 100.0);
        }

        double grandTotal = subtotal + cgstAmount + sgstAmount + igstAmount;
        String invNumber = "INV-HS-" + new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date()) + "-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

        Bill bill = new Bill();
        bill.setInvoiceNumber(invNumber);
        bill.setPoId(poId);
        bill.setInvoiceDate(new Date(System.currentTimeMillis()));
        bill.setSubtotal(subtotal);
        bill.setCgstRate(cgstRate);
        bill.setCgstAmount(cgstAmount);
        bill.setSgstRate(sgstRate);
        bill.setSgstAmount(sgstAmount);
        bill.setIgstRate(igstRate);
        bill.setIgstAmount(igstAmount);
        bill.setGrandTotal(grandTotal);
        bill.setPaymentStatus("UNPAID");

        boolean created = billingDAO.createInvoice(bill);
        if (created) {
            resp.sendRedirect(req.getContextPath() + "/purchase/billing?msg=GST+Invoice+" + invNumber + "+generated+successfully!");
        } else {
            resp.sendRedirect(req.getContextPath() + "/purchase/generate-bill?error=Failed+to+create+invoice");
        }
    }
}
