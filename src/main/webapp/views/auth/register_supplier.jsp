<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String appPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Supplier Onboarding - HydroStock</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #0A2540 0%, #0D3B66 100%);
            min-height: 100vh;
            padding: 40px 15px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .reg-card {
            background: #FFFFFF;
            border-radius: 16px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.25);
            max-width: 650px;
            margin: auto;
            overflow: hidden;
        }
        .reg-header {
            background-color: #0A2540;
            color: white;
            padding: 24px;
            border-bottom: 4px solid #00A896;
        }
    </style>
</head>
<body>

<div class="reg-card">
    <div class="reg-header text-center">
        <i class="fa-solid fa-industry fa-2x mb-2 text-info"></i>
        <h4 class="mb-0 fw-bold">Supplier Portal Registration</h4>
        <small class="text-white-50">Hydroelectric Power Plant Equipment &amp; Spares Vendor Registration</small>
    </div>

    <div class="p-4">
        <% String err = (String) request.getAttribute("errorMessage"); %>
        <% if (err != null) { %>
            <div class="alert alert-danger py-2" role="alert">
                <i class="fa-solid fa-circle-exclamation me-1"></i> <%= err %>
            </div>
        <% } %>

        <form action="<%= appPath %>/auth" method="POST" id="supplierRegistrationForm">
            <input type="hidden" name="action" value="registerSupplier">

            <div class="row g-3">
                <div class="col-md-12">
                    <label class="form-label fw-semibold">Company / Firm Name *</label>
                    <input type="text" name="companyName" class="form-control" placeholder="e.g. Voith Hydro Spares Ltd" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-semibold">Contact Person *</label>
                    <input type="text" name="contactPerson" class="form-control" placeholder="e.g. Anand Sharma" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-semibold">GSTIN Number *</label>
                    <input type="text" name="gstNumber" class="form-control" placeholder="e.g. 27AAACB1234A1Z5" pattern="[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}" maxlength="15" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-semibold">Official Email *</label>
                    <input type="email" name="email" class="form-control" placeholder="vendor@domain.com" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-semibold">Phone / Mobile *</label>
                    <input type="tel" name="phone" class="form-control" placeholder="+91 9822000000" pattern="(?:\+91[ -]?)?[6-9][0-9]{9}" required>
                </div>

                <div class="col-12">
                    <label class="form-label fw-semibold">Factory / Office Address *</label>
                    <textarea name="address" class="form-control" rows="2" placeholder="Full postal address" required></textarea>
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-semibold">Choose Username *</label>
                    <input type="text" name="username" class="form-control" placeholder="Portal login username" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-semibold">Set Password *</label>
                    <input type="password" name="password" class="form-control" placeholder="Minimum 6 characters" minlength="6" required>
                </div>
            </div>

            <div class="mt-4">
                <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold" style="background-color: #00A896; border-color: #00A896;">
                    <i class="fa-solid fa-file-signature me-1"></i> Register Supplier Account
                </button>
            </div>
        </form>

        <div class="text-center mt-3">
            <a href="<%= appPath %>/auth?action=login" class="text-decoration-none text-muted" style="font-size: 0.88rem;">
                <i class="fa-solid fa-arrow-left me-1"></i> Back to Login
            </a>
        </div>
    </div>
</div>

</body>
</html>
