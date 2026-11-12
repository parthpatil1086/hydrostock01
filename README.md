# HydroStock – Hydroelectric Power Plant Inventory and Billing Management System

**Academic Year:** 2026–2027  
**Department:** Department of Computer Applications, TKIET, Warananagar  
**Project Guide:** Prof. Rupali Sokande  
**Project Team:**  
- Vrushali Vasant Ghotane (Roll No. 22)  
- Bhakti Prakash Koli (Roll No. 38)  
- Prachi Arvind Patil (Roll No. 78)  
- Sanika Sanjay Patil (Roll No. 88)  

---

## 🌟 Overview & Key Modules
HydroStock is an enterprise-grade web application developed in **Java (JSP, Servlets, JDBC, MySQL)** designed specifically for hydroelectric power stations (e.g., Francis, Kaplan, and Pelton hydro turbines).

### 4 Main Panels
1. **Admin Panel:** Complete system control, user & employee accounts management, equipment master, live KPI dashboard, and financial reports.
2. **Inventory / Store Management Panel:** Spares catalog, categories, automated stock inward/outward ledger, and critical low stock alerts.
3. **Purchase & Billing Panel:** Dynamic multi-item purchase order generation, status workflow approvals, automatic GST tax calculation (CGST/SGST/IGST), printable official tax invoices, and payment tracking.
4. **Supplier Portal:** Vendor login, purchase order acknowledgments, consignment dispatch/tracking updates, and invoice ledger.

---

## 🚀 Quick Setup Instructions

### 1. Import Database in XAMPP phpMyAdmin
1. Open XAMPP Control Panel and start **MySQL** and **Tomcat**.
2. Open your browser: [http://localhost/phpmyadmin](http://localhost/phpmyadmin)
3. Click on the **SQL** tab or create a database named `hydrostock_db`.
4. Import the file:
   📁 `database/database.sql`

### 2. Open Project in VS Code
1. Open VS Code.
2. Click **File ➔ Open Folder...**
3. Select:
   📁 `C:\Users\Hp\.gemini\antigravity\scratch\HydroStock`

### 3. Build & Deploy
Double-click `build_and_deploy.bat` in the root folder. It compiles all Java classes and deploys directly into:
`C:\xampp\tomcat\webapps\HydroStock`

### 4. Open in Browser
👉 **[http://localhost:8080/HydroStock](http://localhost:8080/HydroStock)**

---

## 🔐 Default Login Credentials

| Role | Username | Password | Access / Panel |
| :--- | :--- | :--- | :--- |
| **Admin (Chief Engineer)** | `admin` | `admin123` | Full Access (All 4 Panels &amp; Reports) |
| **Store In-Charge** | `store_officer` | `store123` | Inventory Panel (Inward, Outward, Spares) |
| **Accounts Officer** | `purchase_officer` | `purchase123` | Purchase &amp; Billing Panel (PO &amp; GST Bills) |
| **Supplier (BHEL)** | `bhel_supplier` | `supplier123` | Supplier Portal (Orders &amp; Invoices) |
| **Senior Turbine Tech** | `turbine_tech` | `tech123` | Inventory &amp; Maintenance Logs |

*(Or click any of the 1-click demo badges on the login screen)*
