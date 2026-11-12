package com.hydrostock.controller;

import com.hydrostock.dao.*;
import com.hydrostock.model.Material;
import com.hydrostock.model.Notification;
import com.hydrostock.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private MaterialDAO materialDAO = new MaterialDAO();
    private SupplierDAO supplierDAO = new SupplierDAO();
    private PurchaseDAO purchaseDAO = new PurchaseDAO();
    private BillingDAO billingDAO = new BillingDAO();
    private EquipmentDAO equipmentDAO = new EquipmentDAO();
    private NotificationDAO notificationDAO = new NotificationDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        // KPI metrics
        int totalMaterials = materialDAO.getTotalMaterialsCount();
        int lowStockCount = materialDAO.getLowStockCount();
        int totalSuppliers = supplierDAO.getTotalSuppliersCount();
        int openPOCount = purchaseDAO.getOpenPOCount();
        double totalValuation = materialDAO.getTotalInventoryValuation();
        double totalBilled = billingDAO.getTotalBilledAmount();
        int totalUsers = userDAO.getTotalUsersCount();
        int maintenanceAlerts = equipmentDAO.getMaintenanceRequiredCount();

        List<Material> lowStockList = materialDAO.getLowStockMaterials();
        List<Notification> notifications = notificationDAO.getNotificationsForRole("ADMIN", user != null ? user.getUserId() : null);

        req.setAttribute("totalMaterials", totalMaterials);
        req.setAttribute("lowStockCount", lowStockCount);
        req.setAttribute("totalSuppliers", totalSuppliers);
        req.setAttribute("openPOCount", openPOCount);
        req.setAttribute("totalValuation", totalValuation);
        req.setAttribute("totalBilled", totalBilled);
        req.setAttribute("totalUsers", totalUsers);
        req.setAttribute("maintenanceAlerts", maintenanceAlerts);

        req.setAttribute("lowStockList", lowStockList);
        req.setAttribute("notifications", notifications);

        req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, resp);
    }
}
