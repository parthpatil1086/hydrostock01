<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String appPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - HydroStock Power Plant Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #0A2540 0%, #0D3B66 50%, #028090 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 20px;
        }
        .login-card {
            background: #FFFFFF;
            border-radius: 16px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.25);
            max-width: 480px;
            width: 100%;
            overflow: hidden;
        }
        .login-header {
            background-color: #0A2540;
            color: #FFFFFF;
            padding: 30px;
            text-align: center;
            border-bottom: 4px solid #00A896;
        }
        .login-body {
            padding: 35px 30px;
        }
        .form-control:focus {
            border-color: #00A896;
            box-shadow: 0 0 0 0.25rem rgba(0, 168, 150, 0.25);
        }
        .btn-hydro {
            background-color: #00A896;
            border-color: #00A896;
            color: #FFFFFF;
            font-weight: 600;
            padding: 12px;
            transition: all 0.2s;
        }
        .btn-hydro:hover {
            background-color: #028090;
            border-color: #028090;
            color: #FFFFFF;
        }
        .demo-badge {
            cursor: pointer;
            transition: all 0.2s;
            font-size: 0.75rem;
            padding: 6px 10px;
        }
        .demo-badge:hover {
            opacity: 0.85;
            transform: scale(1.02);
        }
    </style>
</head>
<body>

<div class="login-card">
    <div class="login-header">
        <i class="fa-solid fa-water fa-3x mb-2 text-info"></i>
        <h3 class="fw-bold mb-0">HYDROSTOCK</h3>
        <p class="mb-0 text-white-50" style="font-size: 0.85rem;">Hydroelectric Power Plant Inventory &amp; Billing</p>
    </div>

    <div class="login-body">
        <% String err = (String) request.getAttribute("errorMessage"); %>
        <% if (err == null) err = request.getParameter("error"); %>
        <% if (err != null && !err.trim().isEmpty()) { %>
            <div class="alert alert-danger py-2" role="alert" style="font-size: 0.88rem;">
                <i class="fa-solid fa-triangle-exclamation me-1"></i> <%= err %>
            </div>
        <% } %>

        <% String msg = request.getParameter("msg"); %>
        <% if (msg != null && !msg.trim().isEmpty()) { %>
            <div class="alert alert-success py-2" role="alert" style="font-size: 0.88rem;">
                <i class="fa-solid fa-circle-check me-1"></i> <%= msg %>
            </div>
        <% } %>

        <form action="<%= appPath %>/auth" method="POST">
            <div class="mb-3">
                <label class="form-label text-secondary fw-semibold" style="font-size: 0.85rem;">Username</label>
                <div class="input-group">
                    <span class="input-group-text bg-light"><i class="fa-solid fa-user text-muted"></i></span>
                    <input type="text" id="usernameField" name="username" class="form-control" placeholder="Enter username" required autofocus>
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label text-secondary fw-semibold" style="font-size: 0.85rem;">Password</label>
                <div class="input-group">
                    <span class="input-group-text bg-light"><i class="fa-solid fa-lock text-muted"></i></span>
                    <input type="password" id="passwordField" name="password" class="form-control" placeholder="Enter password" required>
                </div>
            </div>

            <button type="submit" class="btn btn-hydro w-100 rounded-pill shadow-sm mb-3">
                <i class="fa-solid fa-arrow-right-to-bracket me-2"></i> Secure Sign In
            </button>
        </form>

        <div class="text-center mt-3">
            <a href="<%= appPath %>/auth?action=register" class="text-decoration-none" style="font-size: 0.88rem; color: #028090;">
                <i class="fa-solid fa-handshake me-1"></i> New Supplier? Register Profile Here
            </a>
        </div>

        <hr class="my-4">

        <div>
            <div class="text-muted fw-semibold mb-2" style="font-size: 0.78rem; text-transform: uppercase;">
                Quick Demo Credentials (Click to Fill):
            </div>
            <div class="d-flex flex-wrap gap-2">
                <span class="badge bg-primary demo-badge" onclick="fillCreds('admin', 'admin123')">
                    <i class="fa-solid fa-user-shield me-1"></i> Admin
                </span>
                <span class="badge bg-success demo-badge" onclick="fillCreds('store_officer', 'store123')">
                    <i class="fa-solid fa-boxes-stacked me-1"></i> Store Manager
                </span>
                <span class="badge bg-warning text-dark demo-badge" onclick="fillCreds('purchase_officer', 'purchase123')">
                    <i class="fa-solid fa-file-invoice-dollar me-1"></i> Accounts Officer
                </span>
                <span class="badge bg-info text-dark demo-badge" onclick="fillCreds('bhel_supplier', 'supplier123')">
                    <i class="fa-solid fa-truck-field me-1"></i> BHEL Supplier
                </span>
            </div>
        </div>
    </div>
</div>

<script>
function fillCreds(user, pass) {
    document.getElementById('usernameField').value = user;
    document.getElementById('passwordField').value = pass;
}
</script>
</body>
</html>
