/**
 * HydroStock: Client-side dynamic handlers
 */

document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll("form[novalidate]").forEach(function (form) {
        form.addEventListener("submit", function (event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add("was-validated");
        });
    });
    // Auto-dismiss alerts after 5 seconds
    const alerts = document.querySelectorAll(".alert-dismissible");
    alerts.forEach(function (alert) {
        setTimeout(function () {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });

    // PO Dynamic Items Calculation
    const poTable = document.getElementById("poItemsTable");
    if (poTable) {
        setupPoCalculator();
    }
});

function setupPoCalculator() {
    const addItemBtn = document.getElementById("addItemBtn");
    const tbody = document.getElementById("poItemsBody");
    const grandTotalEl = document.getElementById("poGrandTotal");

    function calculateTotal() {
        let total = 0;
        const rows = tbody.querySelectorAll("tr");
        rows.forEach(row => {
            const qtyInput = row.querySelector(".item-qty");
            const priceInput = row.querySelector(".item-price");
            const subtotalInput = row.querySelector(".item-subtotal");

            const qty = parseFloat(qtyInput.value) || 0;
            const price = parseFloat(priceInput.value) || 0;
            const subtotal = qty * price;

            subtotalInput.value = subtotal.toFixed(2);
            total += subtotal;
        });

        if (grandTotalEl) {
            grandTotalEl.innerText = "₹ " + total.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        }
    }

    if (addItemBtn && tbody) {
        addItemBtn.addEventListener("click", function () {
            const firstRow = tbody.querySelector("tr");
            const newRow = firstRow.cloneNode(true);

            newRow.querySelector(".item-qty").value = 1;
            newRow.querySelector(".item-price").value = "0.00";
            newRow.querySelector(".item-price").min = "0.01";
            newRow.querySelector(".item-subtotal").value = "0.00";

            tbody.appendChild(newRow);
            bindRowEvents(newRow);
            calculateTotal();
        });
    }

    function bindRowEvents(row) {
        const matSelect = row.querySelector(".material-select");
        const qtyInput = row.querySelector(".item-qty");
        const priceInput = row.querySelector(".item-price");
        const removeBtn = row.querySelector(".remove-item-btn");

        if (matSelect) {
            matSelect.addEventListener("change", function () {
                const selectedOption = matSelect.options[matSelect.selectedIndex];
                const unitPrice = selectedOption.getAttribute("data-price") || 0;
                priceInput.value = parseFloat(unitPrice).toFixed(2);
                calculateTotal();
            });
        }

        if (qtyInput) qtyInput.addEventListener("input", calculateTotal);
        if (priceInput) priceInput.addEventListener("input", calculateTotal);

        if (removeBtn) {
            removeBtn.addEventListener("click", function () {
                const rows = tbody.querySelectorAll("tr");
                if (rows.length > 1) {
                    row.remove();
                    calculateTotal();
                } else {
                    alert("A purchase order must contain at least one item.");
                }
            });
        }
    }

    // Bind existing rows
    const existingRows = tbody ? tbody.querySelectorAll("tr") : [];
    existingRows.forEach(row => bindRowEvents(row));
    calculateTotal();
}
