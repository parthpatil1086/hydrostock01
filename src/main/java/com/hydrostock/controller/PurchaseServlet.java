package com.hydrostock.controller;

import com.hydrostock.dao.MaterialDAO;
import com.hydrostock.dao.PurchaseDAO;
import com.hydrostock.model.Material;
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
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet(urlPatterns = {"/purchase/orders", "/purchase/create", "/purchase/status", "/purchase/view"})
public class PurchaseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private PurchaseDAO purchaseDAO = new PurchaseDAO();
    private SupplierDAO supplierDAO = new SupplierDAO();
    private MaterialDAO materialDAO = new MaterialDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();

        if (servletPath.contains("create")) {
            List<Supplier> suppliers = supplierDAO.getAllSuppliers();
            List<Material> materials = materialDAO.getAllMaterials();
            req.setAttribute("suppliers", suppliers);
            req.setAttribute("materials", materials);
            req.getRequestDispatcher("/views/purchase/create_po.jsp").forward(req, resp);
        } else if (servletPath.contains("view")) {
            int poId = Integer.parseInt(req.getParameter("id"));
            PurchaseOrder po = purchaseDAO.getPurchaseOrderById(poId);
            if (po == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Purchase order not found.");
                return;
            }
            HttpSession session = req.getSession(false);
            User viewer = session != null ? (User) session.getAttribute("currentUser") : null;
            if (viewer != null && "SUPPLIER".equalsIgnoreCase(viewer.getRoleName())) {
                Supplier supplier = supplierDAO.getSupplierByUserId(viewer.getUserId());
                if (supplier == null || supplier.getSupplierId() != po.getSupplierId()) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "You may only view your own purchase orders.");
                    return;
                }
            }
            req.setAttribute("po", po);
            req.getRequestDispatcher("/views/purchase/po_details.jsp").forward(req, resp);
        } else {
            // List all purchase orders
            List<PurchaseOrder> orders = purchaseDAO.getAllPurchaseOrders();
            req.setAttribute("orders", orders);
            req.getRequestDispatcher("/views/purchase/po_list.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();

        if (servletPath.contains("status")) {
            // Update PO Status (Approve, Dispatched, Delivered)
            int poId = Integer.parseInt(req.getParameter("poId"));
            String status = req.getParameter("status");
            HttpSession session = req.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
            String approver = (user != null) ? user.getFullName() : "Chief Engineer";

            purchaseDAO.updatePOStatus(poId, status, approver);
            resp.sendRedirect(req.getContextPath() + "/purchase/orders?msg=Order+status+updated+to+" + status);
            return;
        }

        // Create Purchase Order
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        String creator = (user != null) ? user.getFullName() : "Purchase Officer";

        int supplierId;
        try {
            supplierId = Integer.parseInt(req.getParameter("supplierId"));
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/purchase/create?error=Please+select+a+registered+supplier.");
            return;
        }
        if (supplierDAO.getSupplierById(supplierId) == null) {
            resp.sendRedirect(req.getContextPath() + "/purchase/create?error=Selected+supplier+does+not+exist.");
            return;
        }

        String poNumber = "PO-" + new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date()) + "-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        Date orderDate = new Date(System.currentTimeMillis());
        Date expectedDate;
        try {
            expectedDate = Date.valueOf(req.getParameter("expectedDelivery"));
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/purchase/create?error=Expected+delivery+date+is+required.");
            return;
        }
        if (expectedDate.before(orderDate)) {
            resp.sendRedirect(req.getContextPath() + "/purchase/create?error=Expected+delivery+date+cannot+be+in+the+past.");
            return;
        }
        String notes = req.getParameter("notes");

        String[] materialIds = req.getParameterValues("materialId[]");
        String[] quantities = req.getParameterValues("quantity[]");
        String[] unitPrices = req.getParameterValues("unitPrice[]");

        List<PurchaseItem> items = new ArrayList<>();
        double grandTotal = 0.0;

        if (materialIds != null && materialIds.length > 0 && quantities != null && unitPrices != null
                && materialIds.length == quantities.length && materialIds.length == unitPrices.length) {
            for (int i = 0; i < materialIds.length; i++) {
                int mId;
                int qty;
                double price;
                try {
                    mId = Integer.parseInt(materialIds[i]);
                    qty = Integer.parseInt(quantities[i]);
                    price = Double.parseDouble(unitPrices[i]);
                } catch (Exception e) {
                    resp.sendRedirect(req.getContextPath() + "/purchase/create?error=Every+line+item+must+have+valid+values.");
                    return;
                }
                if (mId <= 0 || qty < 1 || price <= 0 || !Double.isFinite(price)) {
                    resp.sendRedirect(req.getContextPath() + "/purchase/create?error=Each+item+must+have+quantity+at+least+1+and+unit+price+greater+than+zero.");
                    return;
                }
                double sub = qty * price;
                grandTotal += sub;

                PurchaseItem item = new PurchaseItem();
                item.setMaterialId(mId);
                item.setQuantity(qty);
                item.setUnitPrice(price);
                item.setSubtotal(sub);
                items.add(item);
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/purchase/create?error=At+least+one+purchase+item+is+required.");
            return;
        }

        PurchaseOrder po = new PurchaseOrder();
        po.setPoNumber(poNumber);
        po.setSupplierId(supplierId);
        po.setOrderDate(orderDate);
        po.setExpectedDelivery(expectedDate);
        po.setTotalAmount(grandTotal);
        po.setCreatedBy(creator);
        po.setNotes(notes);

        boolean success = purchaseDAO.createPurchaseOrder(po, items);
        if (success) {
            resp.sendRedirect(req.getContextPath() + "/purchase/orders?msg=Purchase+Order+" + poNumber + "+created+successfully!");
        } else {
            resp.sendRedirect(req.getContextPath() + "/purchase/create?error=Failed+to+create+Purchase+Order");
        }
    }
}
