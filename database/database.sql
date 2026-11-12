-- ========================================================================
-- HydroStock: Hydroelectric Power Plant Inventory & Billing Management System
-- Academic Year 2026-2027 | TKIET Warananagar
-- MySQL 5.7 / 8.0+ Compatible Database Script
-- ========================================================================

DROP DATABASE IF EXISTS hydrostock_db;
CREATE DATABASE hydrostock_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hydrostock_db;

-- ------------------------------------------------------------------------
-- Table: roles
-- ------------------------------------------------------------------------
CREATE TABLE roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255)
) ENGINE=InnoDB;

INSERT INTO roles (role_id, role_name, description) VALUES
(1, 'ADMIN', 'System Administrator with full access'),
(2, 'INVENTORY_MANAGER', 'Store keeper & inventory manager'),
(3, 'PURCHASE_MANAGER', 'Purchasing and billing officer'),
(4, 'SUPPLIER', 'Registered material & spare supplier'),
(5, 'PLANT_ENGINEER', 'Plant maintenance and field engineer');

-- ------------------------------------------------------------------------
-- Table: users
-- ------------------------------------------------------------------------
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    role_id INT NOT NULL,
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

INSERT INTO users (user_id, username, password, full_name, email, phone, role_id, status) VALUES
(1, 'admin', 'admin123', 'Rajesh K. Shinde (Chief Engineer)', 'admin@hydrostock.power.gov', '+91 9822011223', 1, 'ACTIVE'),
(2, 'store_officer', 'store123', 'Prakash Deshmukh (Store In-Charge)', 'store@hydrostock.power.gov', '+91 9822044556', 2, 'ACTIVE'),
(3, 'purchase_officer', 'purchase123', 'Sunil V. Patil (Accounts Officer)', 'accounts@hydrostock.power.gov', '+91 9822077889', 3, 'ACTIVE'),
(4, 'bhel_supplier', 'supplier123', 'Bharat Heavy Electricals Ltd (BHEL)', 'sales.bhel@supplier.com', '+91 9422012345', 4, 'ACTIVE'),
(5, 'turbine_tech', 'tech123', 'Anand Kulkarni (Senior Turbine Tech)', 'anand.k@hydrostock.power.gov', '+91 9823098765', 5, 'ACTIVE');

-- ------------------------------------------------------------------------
-- Table: categories
-- ------------------------------------------------------------------------
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
) ENGINE=InnoDB;

INSERT INTO categories (category_id, category_name, description) VALUES
(1, 'Turbine Spares & Bearings', 'Hydro turbine runner blades, guide bearings, thrust pads, and shaft seals'),
(2, 'Penstock & Hydraulic Valves', 'Butterfly valves, spherical shut-off valves, bypass piping, and high-pressure seals'),
(3, 'Generator & Excitation', 'Generator stator coils, rotor poles, carbon brushes, and excitation switchgear'),
(4, 'Lubricants & Dielectric Oils', 'Turbine governor oils ISO VG 46/68, synthetic gear oil, and transformer cooling oil'),
(5, 'Instrumentation & Sensors', 'Vibration probes, water head pressure transmitters, RTD temperature sensors'),
(6, 'Fasteners & High-Pressure Gaskets', 'High-tensile turbine bolts, spiral wound gaskets, O-rings, and hydraulic clamps');

-- ------------------------------------------------------------------------
-- Table: materials (Inventory Spares)
-- ------------------------------------------------------------------------
CREATE TABLE materials (
    material_id INT AUTO_INCREMENT PRIMARY KEY,
    material_code VARCHAR(30) NOT NULL UNIQUE,
    material_name VARCHAR(150) NOT NULL,
    category_id INT NOT NULL,
    unit_of_measure VARCHAR(30) NOT NULL,
    current_stock INT NOT NULL DEFAULT 0,
    min_stock_level INT NOT NULL DEFAULT 5,
    unit_price DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    location_rack VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

INSERT INTO materials (material_id, material_code, material_name, category_id, unit_of_measure, current_stock, min_stock_level, unit_price, location_rack) VALUES
(1, 'MAT-TURB-001', 'Francis Turbine Guide Bearing Pad (Segmented)', 1, 'Units', 8, 4, 85000.00, 'Rack-A1-Bay02'),
(2, 'MAT-TURB-002', 'Kaplan Runner Blade Carbon Shaft Seal Kit', 1, 'Sets', 3, 5, 42000.00, 'Rack-A1-Bay04'),
(3, 'MAT-VALV-003', 'Hydraulic Penstock Butterfly Valve Seal (DN 1200)', 2, 'Pieces', 2, 3, 68000.00, 'Rack-B2-Bay01'),
(4, 'MAT-VALV-004', 'Governor Servo Actuator Solenoid Valve 24VDC', 2, 'Units', 12, 6, 24500.00, 'Rack-B2-Bay03'),
(5, 'MAT-GEN-005', 'Hydro Generator Carbon Brush Holder Set (Grade RE65)', 3, 'Sets', 45, 20, 3200.00, 'Rack-C1-Bay01'),
(6, 'MAT-GEN-006', 'Stator Temperature RTD Sensor PT100 Duplex', 5, 'Pieces', 18, 10, 4800.00, 'Rack-C2-Bay02'),
(7, 'MAT-LUB-007', 'Turbine Governor Hydraulic Oil ISO VG 46 (205L Drum)', 4, 'Drums', 15, 8, 38500.00, 'Oil-Yard-Tank03'),
(8, 'MAT-LUB-008', 'Transformer Inhibited Dielectric Mineral Oil (205L Drum)', 4, 'Drums', 4, 10, 44000.00, 'Oil-Yard-Tank01'),
(9, 'MAT-SENS-009', 'Turbine Shaft Proximity Vibration Probe Eddy Current', 5, 'Sets', 6, 6, 52000.00, 'Rack-D1-Bay03'),
(10, 'MAT-FAST-010', 'High Tensile Spiral Wound Flange Gasket 400mm', 6, 'Pieces', 35, 15, 1850.00, 'Rack-D2-Bay05');

-- ------------------------------------------------------------------------
-- Table: suppliers
-- ------------------------------------------------------------------------
CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    company_name VARCHAR(150) NOT NULL,
    contact_person VARCHAR(100) NOT NULL,
    gst_number VARCHAR(20) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    rating DECIMAL(2, 1) DEFAULT 4.5,
    status ENUM('ACTIVE', 'BLOCKED') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB;

INSERT INTO suppliers (supplier_id, user_id, company_name, contact_person, gst_number, phone, email, address, rating) VALUES
(1, 4, 'Bharat Heavy Electricals Ltd (BHEL)', 'S. Ramanathan', '27AAACB1234A1Z5', '+91 9422012345', 'sales.bhel@supplier.com', 'Industrial Area, Phase 2, Pune, Maharashtra', 4.9),
(2, NULL, 'Voith Hydro Power Spares India Pvt Ltd', 'Rohan Mehta', '27AABCV9876K1Z2', '+91 9822187654', 'orders@voith-hydro-india.com', 'MIDC Industrial Zone, Bhosari, Pune', 4.7),
(3, NULL, 'Hydro-Pneumatic Seals & Gaskets Corp', 'K. G. Shirodkar', '27AAACH5544P1Z8', '+91 9765412389', 'info@hydropneumatic.in', 'Shiroli MIDC, Kolhapur, Maharashtra', 4.4),
(4, NULL, 'Apar Industries Lubricants & Transformer Oils', 'Vikram Joshi', '27AAACA1122F1Z3', '+91 9890123456', 'lubricants@apar.com', 'Taloja Industrial Estate, Navi Mumbai', 4.8);

-- ------------------------------------------------------------------------
-- Table: equipment
-- ------------------------------------------------------------------------
CREATE TABLE equipment (
    equipment_id INT AUTO_INCREMENT PRIMARY KEY,
    equipment_code VARCHAR(30) NOT NULL UNIQUE,
    equipment_name VARCHAR(150) NOT NULL,
    location_plant_unit VARCHAR(100) NOT NULL,
    installation_date DATE,
    status ENUM('OPERATIONAL', 'MAINTENANCE_REQUIRED', 'UNDER_REPAIR', 'STANDBY') DEFAULT 'OPERATIONAL'
) ENGINE=InnoDB;

INSERT INTO equipment (equipment_id, equipment_code, equipment_name, location_plant_unit, installation_date, status) VALUES
(1, 'EQ-TURB-U1', 'Unit 1 Francis Turbine (60 MW)', 'Machine Hall - Bay 1', '2015-04-10', 'OPERATIONAL'),
(2, 'EQ-GEN-U1', 'Unit 1 Synchronous Generator (75 MVA)', 'Machine Hall - Bay 1', '2015-04-10', 'OPERATIONAL'),
(3, 'EQ-TURB-U2', 'Unit 2 Francis Turbine (60 MW)', 'Machine Hall - Bay 2', '2015-08-20', 'MAINTENANCE_REQUIRED'),
(4, 'EQ-PEN-VALV1', 'Main Inlet Spherical Valve Unit 1 (DN 2000)', 'Penstock Gallery 1', '2014-12-15', 'OPERATIONAL'),
(5, 'EQ-XFRM-01', 'Main Step-up Power Transformer 220kV/11kV', 'Switchyard Yard A', '2016-01-25', 'OPERATIONAL');

-- ------------------------------------------------------------------------
-- Table: maintenance_records
-- ------------------------------------------------------------------------
CREATE TABLE maintenance_records (
    maintenance_id INT AUTO_INCREMENT PRIMARY KEY,
    equipment_id INT NOT NULL,
    issue_description TEXT NOT NULL,
    performed_by VARCHAR(100) NOT NULL,
    material_used_id INT NULL,
    quantity_used INT DEFAULT 0,
    maintenance_date DATE NOT NULL,
    status ENUM('SCHEDULED', 'IN_PROGRESS', 'COMPLETED') DEFAULT 'COMPLETED',
    remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id) ON DELETE RESTRICT,
    FOREIGN KEY (material_used_id) REFERENCES materials(material_id) ON DELETE SET NULL
) ENGINE=InnoDB;

INSERT INTO maintenance_records (maintenance_id, equipment_id, issue_description, performed_by, material_used_id, quantity_used, maintenance_date, status, remarks) VALUES
(1, 1, 'Routine inspection of Francis turbine guide bearing pads and temperature sensor calibration', 'Anand Kulkarni (Senior Tech)', 6, 2, '2026-10-15', 'COMPLETED', '2 units of RTD sensors replaced due to erratic temperature readings.'),
(2, 3, 'High vibration alarm recorded at top guide bearing during peak load generation', 'Pravin R. Patil', 1, 2, '2026-11-02', 'IN_PROGRESS', 'Replacement guide bearing pad requisition issued to stores.'),
(3, 5, 'Annual filtration and top-up of dielectric insulating transformer oil', 'Suresh Jadhav', 8, 2, '2026-11-08', 'COMPLETED', 'Dielectric breakdown voltage restored to 68 kV.');

-- ------------------------------------------------------------------------
-- Table: stock_transactions
-- ------------------------------------------------------------------------
CREATE TABLE stock_transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    material_id INT NOT NULL,
    transaction_type ENUM('INWARD', 'OUTWARD') NOT NULL,
    quantity INT NOT NULL,
    reference_no VARCHAR(100) NOT NULL,
    remarks TEXT,
    created_by VARCHAR(100) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (material_id) REFERENCES materials(material_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

INSERT INTO stock_transactions (transaction_id, material_id, transaction_type, quantity, reference_no, remarks, created_by) VALUES
(1, 1, 'INWARD', 10, 'DC-BHEL-2026-089', 'Consignment received against PO-2026-001', 'Prakash Deshmukh'),
(2, 1, 'OUTWARD', 2, 'ISSUE-U2-MAINT-104', 'Issued for Unit 2 Guide Bearing Overhaul', 'Prakash Deshmukh'),
(3, 7, 'INWARD', 20, 'INV-APAR-552', 'Quarterly supply of turbine governor oil', 'Prakash Deshmukh'),
(4, 7, 'OUTWARD', 5, 'ISSUE-GOV-U1-88', 'Top-up of hydraulic governor tank Unit 1', 'Prakash Deshmukh'),
(5, 8, 'OUTWARD', 6, 'ISSUE-XFRM-301', 'Used for Transformer Yard filtration', 'Prakash Deshmukh');

-- ------------------------------------------------------------------------
-- Table: purchase_orders
-- ------------------------------------------------------------------------
CREATE TABLE purchase_orders (
    po_id INT AUTO_INCREMENT PRIMARY KEY,
    po_number VARCHAR(50) NOT NULL UNIQUE,
    supplier_id INT NOT NULL,
    order_date DATE NOT NULL,
    expected_delivery DATE NOT NULL,
    total_amount DECIMAL(14, 2) NOT NULL DEFAULT 0.00,
    status ENUM('PENDING', 'APPROVED', 'DISPATCHED', 'DELIVERED', 'CANCELLED') DEFAULT 'PENDING',
    created_by VARCHAR(100) NOT NULL,
    approved_by VARCHAR(100) NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

INSERT INTO purchase_orders (po_id, po_number, supplier_id, order_date, expected_delivery, total_amount, status, created_by, approved_by, notes) VALUES
(1, 'PO-2026-001', 1, '2026-10-01', '2026-10-20', 850000.00, 'DELIVERED', 'Sunil V. Patil', 'Rajesh K. Shinde', '10 sets of Francis Guide Bearing Pads delivered and verified.'),
(2, 'PO-2026-002', 3, '2026-10-25', '2026-11-15', 204000.00, 'DISPATCHED', 'Sunil V. Patil', 'Rajesh K. Shinde', 'Hydraulic Penstock Butterfly Valve Seals (DN 1200) in transit via VRL Logistics.'),
(3, 'PO-2026-003', 4, '2026-11-05', '2026-11-25', 440000.00, 'APPROVED', 'Sunil V. Patil', 'Rajesh K. Shinde', '10 Drums Transformer Inhibited Dielectric Mineral Oil required for winter outage.');

-- ------------------------------------------------------------------------
-- Table: purchase_items
-- ------------------------------------------------------------------------
CREATE TABLE purchase_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    po_id INT NOT NULL,
    material_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(12, 2) NOT NULL,
    subtotal DECIMAL(14, 2) NOT NULL,
    FOREIGN KEY (po_id) REFERENCES purchase_orders(po_id) ON DELETE CASCADE,
    FOREIGN KEY (material_id) REFERENCES materials(material_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

INSERT INTO purchase_items (item_id, po_id, material_id, quantity, unit_price, subtotal) VALUES
(1, 1, 1, 10, 85000.00, 850000.00),
(2, 2, 3, 3, 68000.00, 204000.00),
(3, 3, 8, 10, 44000.00, 440000.00);

-- ------------------------------------------------------------------------
-- Table: invoices (GST Billing)
-- ------------------------------------------------------------------------
CREATE TABLE invoices (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_number VARCHAR(50) NOT NULL UNIQUE,
    po_id INT NOT NULL,
    invoice_date DATE NOT NULL,
    subtotal DECIMAL(14, 2) NOT NULL,
    cgst_rate DECIMAL(5, 2) DEFAULT 9.00,
    cgst_amount DECIMAL(14, 2) NOT NULL,
    sgst_rate DECIMAL(5, 2) DEFAULT 9.00,
    sgst_amount DECIMAL(14, 2) NOT NULL,
    igst_rate DECIMAL(5, 2) DEFAULT 0.00,
    igst_amount DECIMAL(14, 2) DEFAULT 0.00,
    grand_total DECIMAL(14, 2) NOT NULL,
    payment_status ENUM('UNPAID', 'PARTIALLY_PAID', 'PAID') DEFAULT 'UNPAID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_invoice_per_po (po_id),
    FOREIGN KEY (po_id) REFERENCES purchase_orders(po_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

INSERT INTO invoices (invoice_id, invoice_number, po_id, invoice_date, subtotal, cgst_rate, cgst_amount, sgst_rate, sgst_amount, igst_rate, igst_amount, grand_total, payment_status) VALUES
(1, 'INV-HS-2026-001', 1, '2026-10-22', 850000.00, 9.00, 76500.00, 9.00, 76500.00, 0.00, 0.00, 1003000.00, 'PAID'),
(2, 'INV-HS-2026-002', 2, '2026-11-10', 204000.00, 9.00, 18360.00, 9.00, 18360.00, 0.00, 0.00, 240720.00, 'PARTIALLY_PAID'),
(3, 'INV-HS-2026-003', 3, '2026-11-11', 440000.00, 9.00, 39600.00, 9.00, 39600.00, 0.00, 0.00, 519200.00, 'UNPAID');

-- ------------------------------------------------------------------------
-- Table: payments
-- ------------------------------------------------------------------------
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT NOT NULL,
    payment_date DATE NOT NULL,
    amount_paid DECIMAL(14, 2) NOT NULL,
    payment_mode ENUM('NEFT_RTGS', 'CHEQUE', 'DIRECT_BANK_TRANSFER', 'TREASURY_BILL') NOT NULL,
    transaction_reference VARCHAR(100) NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

INSERT INTO payments (payment_id, invoice_id, payment_date, amount_paid, payment_mode, transaction_reference, notes) VALUES
(1, 1, '2026-10-28', 1003000.00, 'NEFT_RTGS', 'RTGS-SBI-89912048', 'Full payment released upon storekeeper inward clearance'),
(2, 2, '2026-11-11', 120000.00, 'NEFT_RTGS', 'RTGS-SBI-91124401', 'Advance 50% mobilization payment released against dispatch notice');

-- ------------------------------------------------------------------------
-- Table: notifications
-- ------------------------------------------------------------------------
CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    role_target VARCHAR(50) DEFAULT 'ALL',
    title VARCHAR(150) NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT INTO notifications (notification_id, user_id, role_target, title, message, is_read) VALUES
(1, NULL, 'INVENTORY_MANAGER', 'CRITICAL LOW STOCK ALERT', 'Transformer Mineral Oil (MAT-LUB-008) is at 4 drums, below safety threshold (10 drums).', FALSE),
(2, NULL, 'INVENTORY_MANAGER', 'LOW STOCK ALERT', 'Kaplan Shaft Seal Kit (MAT-TURB-002) is at 3 units, below safety threshold (5 units).', FALSE),
(3, NULL, 'ADMIN', 'Purchase Order Approval Required', 'Purchase Order PO-2026-003 for 10 Drums Transformer Oil awaits Chief Engineer approval.', FALSE),
(4, 4, 'SUPPLIER', 'New Purchase Order Received', 'PO-2026-001 has been confirmed by HydroStock Accounts Department.', TRUE);
