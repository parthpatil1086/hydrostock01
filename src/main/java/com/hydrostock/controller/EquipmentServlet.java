package com.hydrostock.controller;

import com.hydrostock.dao.EquipmentDAO;
import com.hydrostock.dao.MaterialDAO;
import com.hydrostock.model.Equipment;
import com.hydrostock.model.MaintenanceRecord;
import com.hydrostock.model.Material;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/equipment", "/admin/maintenance"})
public class EquipmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private EquipmentDAO equipmentDAO = new EquipmentDAO();
    private MaterialDAO materialDAO = new MaterialDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Equipment> equipmentList = equipmentDAO.getAllEquipment();
        List<MaintenanceRecord> maintenanceList = equipmentDAO.getAllMaintenanceRecords();
        List<Material> materials = materialDAO.getAllMaterials();

        req.setAttribute("equipmentList", equipmentList);
        req.setAttribute("maintenanceList", maintenanceList);
        req.setAttribute("materials", materials);

        req.getRequestDispatcher("/views/admin/equipment.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Record maintenance activity
        MaintenanceRecord mr = new MaintenanceRecord();
        mr.setEquipmentId(Integer.parseInt(req.getParameter("equipmentId")));
        mr.setIssueDescription(req.getParameter("issueDescription"));
        mr.setPerformedBy(req.getParameter("performedBy"));

        String matIdStr = req.getParameter("materialUsedId");
        if (matIdStr != null && !matIdStr.trim().isEmpty() && !matIdStr.equals("0")) {
            mr.setMaterialUsedId(Integer.parseInt(matIdStr));
            mr.setQuantityUsed(Integer.parseInt(req.getParameter("quantityUsed")));
        } else {
            mr.setQuantityUsed(0);
        }

        mr.setMaintenanceDate(Date.valueOf(req.getParameter("maintenanceDate")));
        mr.setStatus(req.getParameter("status"));
        mr.setRemarks(req.getParameter("remarks"));

        equipmentDAO.addMaintenanceRecord(mr);
        resp.sendRedirect(req.getContextPath() + "/admin/equipment?msg=Maintenance+log+recorded+successfully");
    }
}
