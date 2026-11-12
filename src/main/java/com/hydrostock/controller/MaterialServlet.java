package com.hydrostock.controller;

import com.hydrostock.dao.CategoryDAO;
import com.hydrostock.dao.MaterialDAO;
import com.hydrostock.model.Category;
import com.hydrostock.model.Material;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/inventory/materials", "/inventory/categories"})
public class MaterialServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private MaterialDAO materialDAO = new MaterialDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();

        if (servletPath.contains("categories")) {
            handleCategories(req, resp);
            return;
        }

        // Materials catalog
        String action = req.getParameter("action");
        if ("delete".equalsIgnoreCase(action)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                materialDAO.deleteMaterial(id);
                resp.sendRedirect(req.getContextPath() + "/inventory/materials?msg=Material+record+deleted");
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        List<Material> materials = materialDAO.getAllMaterials();
        List<Category> categories = categoryDAO.getAllCategories();
        req.setAttribute("materials", materials);
        req.setAttribute("categories", categories);
        req.getRequestDispatcher("/views/inventory/materials.jsp").forward(req, resp);
    }

    private void handleCategories(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("delete".equalsIgnoreCase(action)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                categoryDAO.deleteCategory(id);
                resp.sendRedirect(req.getContextPath() + "/inventory/categories?msg=Category+deleted");
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        List<Category> categories = categoryDAO.getAllCategories();
        req.setAttribute("categories", categories);
        req.getRequestDispatcher("/views/inventory/categories.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();

        if (servletPath.contains("categories")) {
            String action = req.getParameter("action");
            if ("add".equalsIgnoreCase(action)) {
                Category c = new Category();
                c.setCategoryName(req.getParameter("categoryName"));
                c.setDescription(req.getParameter("description"));
                categoryDAO.addCategory(c);
            } else if ("edit".equalsIgnoreCase(action)) {
                Category c = new Category();
                c.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
                c.setCategoryName(req.getParameter("categoryName"));
                c.setDescription(req.getParameter("description"));
                categoryDAO.updateCategory(c);
            }
            resp.sendRedirect(req.getContextPath() + "/inventory/categories?msg=Category+saved");
            return;
        }

        // Handle Material Add / Edit
        String action = req.getParameter("action");
        if ("add".equalsIgnoreCase(action)) {
            Material m = new Material();
            m.setMaterialCode(req.getParameter("materialCode"));
            m.setMaterialName(req.getParameter("materialName"));
            m.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
            m.setUnitOfMeasure(req.getParameter("unitOfMeasure"));
            m.setCurrentStock(Integer.parseInt(req.getParameter("currentStock")));
            m.setMinStockLevel(Integer.parseInt(req.getParameter("minStockLevel")));
            m.setUnitPrice(Double.parseDouble(req.getParameter("unitPrice")));
            m.setLocationRack(req.getParameter("locationRack"));
            materialDAO.addMaterial(m);
            resp.sendRedirect(req.getContextPath() + "/inventory/materials?msg=New+spare+part+added+to+inventory");
        } else if ("edit".equalsIgnoreCase(action)) {
            Material m = new Material();
            m.setMaterialId(Integer.parseInt(req.getParameter("materialId")));
            m.setMaterialCode(req.getParameter("materialCode"));
            m.setMaterialName(req.getParameter("materialName"));
            m.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
            m.setUnitOfMeasure(req.getParameter("unitOfMeasure"));
            m.setMinStockLevel(Integer.parseInt(req.getParameter("minStockLevel")));
            m.setUnitPrice(Double.parseDouble(req.getParameter("unitPrice")));
            m.setLocationRack(req.getParameter("locationRack"));
            materialDAO.updateMaterial(m);
            resp.sendRedirect(req.getContextPath() + "/inventory/materials?msg=Material+specifications+updated");
        }
    }
}
