package com.hydrostock.controller;

import com.hydrostock.dao.BillingDAO;
import com.hydrostock.dao.PurchaseDAO;
import com.hydrostock.dao.SupplierDAO;
import com.hydrostock.model.Bill;
import com.hydrostock.model.PurchaseOrder;
import com.hydrostock.model.Supplier;
import com.hydrostock.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/supplier/portal", "/supplier/orders", "/supplier/invoices", "/supplier/dispatch"})
public class SupplierPortalServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private SupplierDAO supplierDAO = new SupplierDAO();
    private PurchaseDAO purchaseDAO = new PurchaseDAO();
    private BillingDAO billingDAO = new BillingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth?action=login");
            return;
        }

        Supplier supplier = supplierDAO.getSupplierByUserId(user.getUserId());
        if (supplier == null) {
            // Default to BHEL supplier (id=1) for demo if not explicitly mapped
            supplier = supplierDAO.getSupplierById(1);
        }

        int sId = supplier != null ? supplier.getSupplierId() : 1;
        List<PurchaseOrder> myOrders = purchaseDAO.getPurchaseOrdersBySupplier(sId);
        List<Bill> myInvoices = billingDAO.getInvoicesBySupplier(sId);

        req.setAttribute("supplier", supplier);
        req.setAttribute("orders", myOrders);
        req.setAttribute("invoices", myInvoices);

        String servletPath = req.getServletPath();
        if (servletPath.contains("orders")) {
            req.getRequestDispatcher("/views/supplier/my_orders.jsp").forward(req, resp);
        } else if (servletPath.contains("invoices")) {
            req.getRequestDispatcher("/views/supplier/invoices.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/views/supplier/dashboard.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Handle supplier updating dispatch / consignment info
        int poId = Integer.parseInt(req.getParameter("poId"));
        String status = req.getParameter("status"); // DISPATCHED or DELIVERED
        String trackingNotes = req.getParameter("trackingNotes");

        purchaseDAO.updatePOStatus(poId, status, "Supplier Dispatch (" + trackingNotes + ")");
        resp.sendRedirect(req.getContextPath() + "/supplier/orders?msg=Order+delivery+status+updated+to+" + status);
    }
}
