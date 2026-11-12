package com.hydrostock.controller;

import com.hydrostock.dao.BillingDAO;
import com.hydrostock.dao.MaterialDAO;
import com.hydrostock.dao.PurchaseDAO;
import com.hydrostock.dao.StockDAO;
import com.hydrostock.model.Bill;
import com.hydrostock.model.Material;
import com.hydrostock.model.PurchaseOrder;
import com.hydrostock.model.StockTransaction;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/reports")
public class ReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private MaterialDAO materialDAO = new MaterialDAO();
    private PurchaseDAO purchaseDAO = new PurchaseDAO();
    private BillingDAO billingDAO = new BillingDAO();
    private StockDAO stockDAO = new StockDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Material> materials = materialDAO.getAllMaterials();
        List<PurchaseOrder> orders = purchaseDAO.getAllPurchaseOrders();
        List<Bill> invoices = billingDAO.getAllInvoices();
        List<StockTransaction> transactions = stockDAO.getAllTransactions();

        double totalValuation = materialDAO.getTotalInventoryValuation();
        double totalBilled = billingDAO.getTotalBilledAmount();

        req.setAttribute("materials", materials);
        req.setAttribute("orders", orders);
        req.setAttribute("invoices", invoices);
        req.setAttribute("transactions", transactions);
        req.setAttribute("totalValuation", totalValuation);
        req.setAttribute("totalBilled", totalBilled);

        req.getRequestDispatcher("/views/admin/reports.jsp").forward(req, resp);
    }
}
