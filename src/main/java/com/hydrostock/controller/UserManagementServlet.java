package com.hydrostock.controller;

import com.hydrostock.dao.UserDAO;
import com.hydrostock.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users")
public class UserManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("delete".equalsIgnoreCase(action)) {
            try {
                int uid = Integer.parseInt(req.getParameter("id"));
                userDAO.deleteUser(uid);
                resp.sendRedirect(req.getContextPath() + "/admin/users?msg=User+deleted+successfully");
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        List<User> userList = userDAO.getAllUsers();
        req.setAttribute("userList", userList);
        req.getRequestDispatcher("/views/admin/users.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("add".equalsIgnoreCase(action)) {
            User u = new User();
            u.setUsername(req.getParameter("username"));
            u.setPassword(req.getParameter("password"));
            u.setFullName(req.getParameter("fullName"));
            u.setEmail(req.getParameter("email"));
            u.setPhone(req.getParameter("phone"));
            u.setRoleId(Integer.parseInt(req.getParameter("roleId")));
            u.setStatus(req.getParameter("status"));
            userDAO.addUser(u);
            resp.sendRedirect(req.getContextPath() + "/admin/users?msg=New+user+added+successfully");
        } else if ("edit".equalsIgnoreCase(action)) {
            User u = new User();
            u.setUserId(Integer.parseInt(req.getParameter("userId")));
            u.setFullName(req.getParameter("fullName"));
            u.setEmail(req.getParameter("email"));
            u.setPhone(req.getParameter("phone"));
            u.setRoleId(Integer.parseInt(req.getParameter("roleId")));
            u.setStatus(req.getParameter("status"));
            userDAO.updateUser(u);
            resp.sendRedirect(req.getContextPath() + "/admin/users?msg=User+details+updated+successfully");
        }
    }
}
