<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("currentUser") != null) {
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    } else {
        response.sendRedirect(request.getContextPath() + "/auth?action=login");
    }
%>
