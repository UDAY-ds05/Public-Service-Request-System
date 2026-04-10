<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Public Service Request System</title>
    <link rel="stylesheet" href="../css/main-page.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        function goToLogin() {
            window.location.href = "../../loginmodule/html/select_role.html";
        }
    </script>
</head>
<body>

<!-- Dot-grid background -->
<div class="bg">
    <span></span>
    <span></span>
    <span></span>
</div>

<!-- ═══════════ HEADER ═══════════ -->
<header>
    <nav>
        <h2>Online Public Service Request System</h2>
        <button onclick="goToLogin()">Login</button>
    </nav>
</header>

<!-- ═══════════ MAIN ═══════════ -->
<main>

    <!-- HERO -->
    <section>
        <div>
            <img class="logo" src="public-service-logo.png" alt="Public Service Illustration">
        </div>
        <div>
            <h1>Report Public Issues <span class="highlight">Easily</span> &amp; Track Their Resolution</h1>
            <p>
                A unified platform for citizens to report public service issues such as
                water supply problems, electricity failures, road damage, sanitation concerns,
                and more — all from one place.
            </p>
        </div>
    </section>

    <!-- CATEGORIES -->
    <h2 class="cat-heading">Service Categories</h2>

    <section class="categories-section">

        <div data-index="01">
            <h3>🚰 Water Supply Issues</h3>
            <p>
                Report water leakages, low pressure, or irregular supply in your area.<br>
                Flag contaminated or unsafe water issues to the authorities.<br>
                Our team ensures complaints are resolved quickly and efficiently.<br>
                Stay updated on the status of your water supply requests.
            </p>
        </div>

        <div data-index="02">
            <h3>⚡ Electricity Problems</h3>
            <p>
                Submit complaints about power outages, flickering lights, or voltage issues.<br>
                Report damaged poles, transformers, or faulty wiring in your locality.<br>
                Our electricity department acts promptly to restore safe supply.<br>
                Track your complaint progress until it is fully resolved.
            </p>
        </div>

        <div data-index="03">
            <h3>🛣️ Road &amp; Infrastructure</h3>
            <p>
                Report potholes, damaged roads, or broken footpaths in your area.<br>
                Flag unsafe infrastructure, signage issues, or traffic hazards.<br>
                Authorities inspect and repair problems to ensure safe travel.<br>
                Stay informed on repairs and infrastructure improvements.
            </p>
        </div>

        <div data-index="04">
            <h3>🗑️ Sanitation &amp; Waste Management</h3>
            <p>
                Report overflowing garbage bins or irregular waste collection.<br>
                Flag blocked drains or unhygienic public areas in your locality.<br>
                Our sanitation team works to maintain cleanliness and health.<br>
                Track your complaints for timely cleaning and maintenance.
            </p>
        </div>

        <div data-index="05">
            <h3>💡 Street Light Issues</h3>
            <p>
                Report non-functional or flickering street lights in your area.<br>
                Flag damaged poles or poorly lit roads for safety improvements.<br>
                Authorities act quickly to restore proper public lighting.<br>
                Stay updated on the status of your street light complaints.
            </p>
        </div>

        <div data-index="06">
            <h3>🏛️ Public Property Damage</h3>
            <p>
                Report damage to parks, public toilets, or government buildings.<br>
                Flag broken benches, fences, or other public property issues.<br>
                Authorities inspect and repair to maintain public facilities.<br>
                Track your complaints until the damage is fully resolved.
            </p>
        </div>

    </section>

    <!-- HOW TO -->
    <section class="how-to">
        <h2>How to Raise a Request</h2>
        <ol>
            <li>Login or register as a citizen</li>
            <li>Select the appropriate service category</li>
            <li>Describe the issue and submit your request</li>
            <li>Track the request until it is resolved</li>
        </ol>
    </section>

    <!-- TRUST & TRANSPARENCY -->
    <section>
        <h2>Trust &amp; Transparency</h2>
        <h3>System Statistics</h3>
        <div class="chart-container">
            <canvas id="statsChart"></canvas>
        </div>
        <p>
            All requests are processed by authorized departments.
            Citizens can track the progress of their complaints in real time,
            ensuring accountability and transparency at every step.
        </p>
        <ul>
            <li>✔ Verified Government Authorities</li>
            <li>✔ Real-Time Status Updates</li>
            <li>✔ Transparent Resolution Workflow</li>
        </ul>
    </section>

</main>

<!-- ═══════════ FOOTER ═══════════ -->
<footer>
    <p>© 2026 Public Service Request System. All rights reserved.</p>
    <p>Contact | Privacy Policy | Terms of Service</p>
</footer>

<jsp:include page="/components/chatbot.jsp" />

<!-- ═══════════ STATS LOGIC (unchanged) ═══════════ -->
<script>
function loadStats() {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "../jsp/stats.jsp", true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && xhr.status == 200) {
            var xml = xhr.responseXML;
            var citizens = xml.getElementsByTagName("citizens")[0].textContent;
            var officers = xml.getElementsByTagName("officers")[0].textContent;
            var requests = xml.getElementsByTagName("requests")[0].textContent;
            var resolved = xml.getElementsByTagName("resolved")[0].textContent;
            createChart(citizens, officers, requests, resolved);
        }
    };
    xhr.send();
}

function createChart(citizens, officers, requests, resolved) {
    var ctx = document.getElementById("statsChart").getContext("2d");
    new Chart(ctx, {
        type: "bar",
        data: {
            labels: ["Citizens", "Officers", "Total Requests", "Resolved"],
            datasets: [{
                label: "System Statistics",
                data: [citizens, officers, requests, resolved],
                backgroundColor: [
                    "rgba(26,86,219,0.80)",
                    "rgba(8,145,178,0.80)",
                    "rgba(124,58,237,0.80)",
                    "rgba(5,150,105,0.80)"
                ],
                borderColor: ["#1a56db","#0891b2","#7c3aed","#059669"],
                borderWidth: 2,
                borderRadius: 10,
                borderSkipped: false
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    labels: {
                        color: "#374769",
                        font: { family: "'Plus Jakarta Sans', sans-serif", size: 13 }
                    }
                }
            },
            scales: {
                x: {
                    ticks: { color: "#6b7fa8", font: { family: "'Plus Jakarta Sans', sans-serif" } },
                    grid:  { color: "rgba(10,31,68,0.06)" }
                },
                y: {
                    ticks: { color: "#6b7fa8", font: { family: "'Plus Jakarta Sans', sans-serif" } },
                    grid:  { color: "rgba(10,31,68,0.06)" }
                }
            }
        }
    });
}

window.addEventListener("load", loadStats);
</script>

</body>
</html>