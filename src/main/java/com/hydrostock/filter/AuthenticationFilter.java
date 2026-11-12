package com.hydrostock.filter;

import com.hydrostock.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {"/admin/*", "/inventory/*", "/purchase/*", "/supplier/*"})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        String uri = httpRequest.getRequestURI();

        if (loggedUser == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/auth?action=login&error=Please+login+to+access+HydroStock");
            return;
        }

        String role = loggedUser.getRoleName();

        // Admin has universal access
        if ("ADMIN".equalsIgnoreCase(role)) {
            chain.doFilter(request, response);
            return;
        }

        // Role-specific constraints
        if (uri.contains("/admin/") && !"ADMIN".equalsIgnoreCase(role)) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admin authorization required.");
            return;
        }

        if (uri.contains("/supplier/") && !"SUPPLIER".equalsIgnoreCase(role)) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Supplier portal access restricted.");
            return;
        }

        if (uri.contains("/inventory/") && !("INVENTORY_MANAGER".equalsIgnoreCase(role) || "PLANT_ENGINEER".equalsIgnoreCase(role))) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Store management clearance required.");
            return;
        }

        boolean supplierReadOnlyPurchaseView = "SUPPLIER".equalsIgnoreCase(role)
                && "GET".equalsIgnoreCase(httpRequest.getMethod())
                && (uri.endsWith("/purchase/view") || uri.endsWith("/purchase/invoice-print"));
        if (uri.contains("/purchase/") && !"PURCHASE_MANAGER".equalsIgnoreCase(role) && !supplierReadOnlyPurchaseView) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Accounts / Purchase department clearance required.");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
