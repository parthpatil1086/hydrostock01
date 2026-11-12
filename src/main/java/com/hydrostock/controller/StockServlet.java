package com.hydrostock.controller;

import com.hydrostock.dao.MaterialDAO;
import com.hydrostock.dao.StockDAO;
import com.hydrostock.model.Material;
import com.hydrostock.model.StockTransaction;
import com.hydrostock.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/inventory/inward", "/inventory/outward", "/inventory/alerts", "/inventory/history"})
public class StockServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private StockDAO stockDAO = new StockDAO();
    private MaterialDAO materialDAO = new MaterialDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();

        if (servletPath.contains("inward")) {
            List<Material> materials = materialDAO.getAllMaterials();
            req.setAttribute("materials", materials);
            req.getRequestDispatcher("/views/inventory/stock_inward.jsp").forward(req, resp);
        } else if (servletPath.contains("outward")) {
            List<Material> materials = materialDAO.getAllMaterials();
            req.setAttribute("materials", materials);
            req.getRequestDispatcher("/views/inventory/stock_outward.jsp").forward(req, resp);
        } else if (servletPath.contains("alerts")) {
            List<Material> lowStock = materialDAO.getLowStockMaterials();
            req.setAttribute("lowStock", lowStock);
            req.getRequestDispatcher("/views/inventory/low_stock_alerts.jsp").forward(req, resp);
        } else {
            // Transaction history
            List<StockTransaction> history = stockDAO.getAllTransactions();
            req.setAttribute("history", history);
            req.getRequestDispatcher("/views/inventory/stock_history.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        String recordedBy = (user != null) ? user.getFullName() : "Store Officer";

        String servletPath = req.getServletPath();
        try {
            int materialId = Integer.parseInt(req.getParameter("materialId"));
            int quantity = Integer.parseInt(req.getParameter("quantity"));
            String referenceNo = req.getParameter("referenceNo");
            String remarks = req.getParameter("remarks");

            if (materialId <= 0 || quantity <= 0) {
                throw new IllegalArgumentException("Material selection is required and quantity must be greater than zero.");
            }
            if (referenceNo == null || referenceNo.trim().isEmpty()) {
                throw new IllegalArgumentException("Reference / Challan number cannot be blank.");
            }
            if (servletPath.contains("outward") && (remarks == null || remarks.trim().isEmpty())) {
                throw new IllegalArgumentException("Equipment / Purpose is required for stock outward.");
            }

            if (servletPath.contains("inward")) {
                boolean success = stockDAO.recordStockInward(materialId, quantity, referenceNo, remarks, recordedBy);
                if (success) {
                    resp.sendRedirect(req.getContextPath() + "/inventory/materials?msg=Stock+Inward+recorded+successfully!+Inventory+updated.");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/inventory/inward?error=Failed+to+record+stock+inward.");
                }
            } else if (servletPath.contains("outward")) {
                stockDAO.recordStockOutward(materialId, quantity, referenceNo, remarks, recordedBy);
                resp.sendRedirect(req.getContextPath() + "/inventory/materials?msg=Stock+Outward+issued+successfully!+Balance+deducted.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", e.getMessage() != null ? e.getMessage() : "Unable to record stock transaction.");
            req.setAttribute("materials", materialDAO.getAllMaterials());
            if (servletPath.contains("outward")) {
                req.getRequestDispatcher("/views/inventory/stock_outward.jsp").forward(req, resp);
            } else {
                req.getRequestDispatcher("/views/inventory/stock_inward.jsp").forward(req, resp);
            }
        }
    }
}
