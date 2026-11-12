package com.hydrostock.controller;

import com.hydrostock.dao.SupplierDAO;
import com.hydrostock.dao.UserDAO;
import com.hydrostock.model.Supplier;
import com.hydrostock.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAO();
    private SupplierDAO supplierDAO = new SupplierDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "login";

        if ("logout".equalsIgnoreCase(action)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            resp.sendRedirect(req.getContextPath() + "/auth?action=login&msg=You+have+been+logged+out+successfully");
            return;
        } else if ("register".equalsIgnoreCase(action)) {
            req.getRequestDispatcher("/views/auth/register_supplier.jsp").forward(req, resp);
            return;
        }

        // Show login page
        req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("registerSupplier".equalsIgnoreCase(action)) {
            handleSupplierRegistration(req, resp);
            return;
        }

        // Default: Authenticate
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        User user = userDAO.authenticate(username, password);
        if (user != null) {
            HttpSession session = req.getSession(true);
            session.setAttribute("currentUser", user);

            String role = user.getRoleName();
            if ("ADMIN".equalsIgnoreCase(role)) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else if ("INVENTORY_MANAGER".equalsIgnoreCase(role) || "PLANT_ENGINEER".equalsIgnoreCase(role)) {
                resp.sendRedirect(req.getContextPath() + "/inventory/materials");
            } else if ("PURCHASE_MANAGER".equalsIgnoreCase(role)) {
                resp.sendRedirect(req.getContextPath() + "/purchase/orders");
            } else if ("SUPPLIER".equalsIgnoreCase(role)) {
                resp.sendRedirect(req.getContextPath() + "/supplier/portal");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            }
        } else {
            req.setAttribute("errorMessage", "Invalid Username or Password! Please verify your credentials.");
            req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
        }
    }

    private void handleSupplierRegistration(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = value(req, "username");
        String password = value(req, "password");
        String companyName = value(req, "companyName");
        String contactPerson = value(req, "contactPerson");
        String gstNumber = value(req, "gstNumber").toUpperCase();
        String email = value(req, "email");
        String phone = value(req, "phone");
        String address = value(req, "address");

        if (username.isEmpty() || password.length() < 6 || companyName.isEmpty() || contactPerson.isEmpty()
                || address.isEmpty() || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")
                || !phone.matches("(?:\\+91[ -]?)?[6-9][0-9]{9}")
                || !gstNumber.matches("^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$")) {
            req.setAttribute("errorMessage", "Please provide valid supplier details: GSTIN, email, 10-digit mobile number, and a password of at least 6 characters are required.");
            req.getRequestDispatcher("/views/auth/register_supplier.jsp").forward(req, resp);
            return;
        }

        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPassword(password);
        newUser.setFullName(companyName + " (" + contactPerson + ")");
        newUser.setEmail(email);
        newUser.setPhone(phone);
        newUser.setRoleId(4); // SUPPLIER role
        newUser.setStatus("ACTIVE");

        boolean userCreated = userDAO.addUser(newUser);
        if (userCreated) {
            User createdUser = userDAO.authenticate(username, password);
            Supplier s = new Supplier();
            if (createdUser != null) {
                s.setUserId(createdUser.getUserId());
            }
            s.setCompanyName(companyName);
            s.setContactPerson(contactPerson);
            s.setGstNumber(gstNumber);
            s.setEmail(email);
            s.setPhone(phone);
            s.setAddress(address);
            s.setRating(5.0);
            s.setStatus("ACTIVE");
            supplierDAO.addSupplier(s);

            resp.sendRedirect(req.getContextPath() + "/auth?action=login&msg=Registration+successful!+Please+sign+in+with+your+credentials.");
        } else {
            req.setAttribute("errorMessage", "Registration failed! Username may already be in use.");
            req.getRequestDispatcher("/views/auth/register_supplier.jsp").forward(req, resp);
        }
    }

    private String value(HttpServletRequest req, String name) {
        String value = req.getParameter(name);
        return value == null ? "" : value.trim();
    }
}
