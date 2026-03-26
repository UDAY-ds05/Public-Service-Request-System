<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBConnection" %>
<%@ page import="javax.servlet.http.Cookie" %>

<%
HttpSession sess = request.getSession(false);

if (sess == null || sess.getAttribute("username") == null) {
    response.sendRedirect("../loginmodule/html/select_role.html");
    return;
}

String username = (String) sess.getAttribute("username");

String theme = "light";
Cookie[] cookies = request.getCookies();
if (cookies != null) {
    for (Cookie c : cookies) {
        if ("theme".equals(c.getName())) theme = c.getValue();
    }
}

/* Count pending payments & total due for banner stats */
int    pendingCount = 0;
double totalDue     = 0.0;
Connection conStats = null;
PreparedStatement psStats = null;
ResultSet rsStats = null;
try {
    conStats = DBConnection.getConnection();
    psStats  = conStats.prepareStatement(
        "SELECT COUNT(*) AS cnt, SUM(amount) AS total FROM payments WHERE username=? AND payment_status='PENDING'"
    );
    psStats.setString(1, username);
    rsStats = psStats.executeQuery();
    if (rsStats.next()) {
        pendingCount = rsStats.getInt("cnt");
        totalDue     = rsStats.getDouble("total");
    }
} catch (Exception e) { e.printStackTrace(); }
finally {
    if (rsStats  != null) try { rsStats.close();  } catch(Exception ignored){}
    if (psStats  != null) try { psStats.close();  } catch(Exception ignored){}
    if (conStats != null) try { conStats.close(); } catch(Exception ignored){}
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Payments — PSRS</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet">

<style>
/* ═══════════════════════════════════════
   TOKENS — identical to user_dashboard.jsp
═══════════════════════════════════════ */
:root {
  --navy:       #0a1f44;
  --blue:       #1a56db;
  --blue-mid:   #2563eb;
  --blue-light: #3b82f6;
  --sky:        #e8f0fe;
  --sky2:       #dbeafe;
  --white:      #ffffff;
  --offwhite:   #f4f7ff;
  --border:     #d1dff8;
  --text:       #0f1c35;
  --body:       #374769;
  --muted:      #6b7fa8;
  --sidebar-w:  240px;
  --header-h:   64px;
  --shadow-sm:  0 2px 8px rgba(10,31,68,0.07);
  --shadow-md:  0 8px 28px rgba(10,31,68,0.11);
  --radius:     16px;
  --ff:         'Plus Jakarta Sans', sans-serif;
  --ff-display: 'Playfair Display', serif;
  --ease:       cubic-bezier(0.22,1,0.36,1);
}

body.dark {
  --navy:       #e8f0fe;
  --blue:       #60a5fa;
  --blue-mid:   #3b82f6;
  --blue-light: #93c5fd;
  --sky:        #1e2d45;
  --sky2:       #172036;
  --white:      #1a2640;
  --offwhite:   #111827;
  --border:     #1e3a5f;
  --text:       #e8eef8;
  --body:       #9ab0cc;
  --muted:      #5a7a99;
}

/* ═══════════════════════════════════════
   RESET
═══════════════════════════════════════ */
*, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
html { scroll-behavior: smooth; }

body {
  font-family: var(--ff);
  background: var(--offwhite);
  background-image: radial-gradient(circle, #c3d4f5 1px, transparent 1px);
  background-size: 32px 32px;
  color: var(--text);
  min-height: 100vh;
  transition: background 0.3s ease, color 0.3s ease;
}
body.dark {
  background-image: radial-gradient(circle, rgba(30,58,95,0.6) 1px, transparent 1px);
}

/* ═══════════════════════════════════════
   HEADER
═══════════════════════════════════════ */
header {
  position: fixed;
  top: 0; left: 0; right: 0;
  height: var(--header-h);
  z-index: 300;
  background: var(--navy);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 32px 0 calc(var(--sidebar-w) + 32px);
  box-shadow: 0 2px 16px rgba(10,31,68,0.25);
  transition: background 0.3s ease;
}
body.dark header { background: #0d1a2e; }

.header-title {
  font-weight: 700;
  font-size: 16px;
  color: rgba(255,255,255,0.90);
  letter-spacing: 0.2px;
  display: flex;
  align-items: center;
  gap: 10px;
}
.header-title::before { content: '💳'; font-size: 18px; }

.header-right { display: flex; align-items: center; gap: 16px; }

.visit-badge {
  font-size: 12px;
  font-weight: 600;
  color: rgba(255,255,255,0.55);
  background: rgba(255,255,255,0.08);
  border: 1px solid rgba(255,255,255,0.12);
  padding: 5px 14px;
  border-radius: 100px;
  letter-spacing: 0.3px;
}
.visit-badge strong { color: rgba(255,255,255,0.88); }

/* ═══════════════════════════════════════
   SIDEBAR
═══════════════════════════════════════ */
nav {
  width: var(--sidebar-w);
  background: #0a1f44;
  height: 100vh;
  position: fixed;
  top: 0; left: 0;
  display: flex;
  flex-direction: column;
  z-index: 400;
  box-shadow: 2px 0 20px rgba(10,31,68,0.20);
  transition: background 0.3s ease;
}
body.dark nav { background: #080f1e; }

.nav-brand {
  height: var(--header-h);
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 0 24px;
  border-bottom: 1px solid rgba(255,255,255,0.07);
  flex-shrink: 0;
}
.nav-brand-icon {
  width: 32px; height: 32px;
  border-radius: 8px;
  background: rgba(59,130,246,0.30);
  display: flex; align-items: center; justify-content: center;
  font-size: 16px; flex-shrink: 0;
}
.nav-brand-text { font-size: 13px; font-weight: 700; color: rgba(255,255,255,0.85); line-height: 1.3; }

.nav-links { display: flex; flex-direction: column; padding: 20px 14px; gap: 4px; flex: 1; }

nav a {
  display: flex;
  align-items: center;
  gap: 12px;
  color: rgba(255,255,255,0.60);
  text-decoration: none;
  padding: 11px 14px;
  border-radius: 10px;
  font-size: 14px;
  font-weight: 500;
  letter-spacing: 0.1px;
  transition: all 0.25s var(--ease);
  position: relative;
}
nav a .nav-icon { font-size: 16px; flex-shrink: 0; }
nav a:hover { background: rgba(255,255,255,0.08); color: rgba(255,255,255,0.95); transform: translateX(4px); }
nav a.active { background: rgba(37,99,235,0.30); color: #93c5fd; font-weight: 600; }
nav a.active::before {
  content: '';
  position: absolute; left: 0; top: 25%; bottom: 25%;
  width: 3px; border-radius: 0 3px 3px 0;
  background: var(--blue-light);
}

.nav-divider { height: 1px; background: rgba(255,255,255,0.07); margin: 8px 14px; }
.nav-bottom { padding: 14px; border-top: 1px solid rgba(255,255,255,0.07); }
.nav-bottom a { margin: 0; }

/* ═══════════════════════════════════════
   MAIN
═══════════════════════════════════════ */
main {
  margin-left: var(--sidebar-w);
  padding: calc(var(--header-h) + 40px) 40px 60px 40px;
  min-height: 100vh;
}

/* ── page banner ── */
.page-banner {
  background: var(--white);
  border: 1px solid var(--border);
  border-radius: 24px;
  padding: 36px 48px;
  margin-bottom: 36px;
  box-shadow: var(--shadow-md);
  display: flex;
  align-items: center;
  justify-content: space-between;
  position: relative;
  overflow: hidden;
  animation: fadeUp 0.55s var(--ease) both;
}
.page-banner::before {
  content: '';
  position: absolute; top: 0; left: 0; right: 0; height: 4px;
  background: linear-gradient(90deg, #0a1f44, #1a56db, #3b82f6);
}
.page-banner::after {
  content: 'PAY';
  position: absolute; right: 28px; bottom: -12px;
  font-family: var(--ff-display);
  font-size: 90px; font-weight: 800;
  color: rgba(10,31,68,0.035);
  letter-spacing: -4px;
  pointer-events: none; user-select: none;
}
body.dark .page-banner::after { color: rgba(255,255,255,0.03); }

.banner-text h1 {
  font-family: var(--ff-display);
  font-size: 30px; font-weight: 800;
  color: var(--navy);
  letter-spacing: -0.3px; margin-bottom: 6px;
}
.banner-text h1 .accent { color: var(--blue-mid); }
.banner-text p { font-size: 14px; color: var(--muted); }

.banner-stats { display: flex; gap: 20px; }
.stat-pill {
  background: var(--sky);
  border: 1px solid var(--border);
  border-radius: 14px;
  padding: 14px 22px;
  text-align: center;
  min-width: 110px;
}
.stat-pill .stat-num { font-size: 26px; font-weight: 800; color: var(--blue-mid); display: block; line-height: 1; }
.stat-pill .stat-label { font-size: 11px; font-weight: 600; letter-spacing: 0.5px; color: var(--muted); text-transform: uppercase; margin-top: 4px; display: block; }

/* ── section label ── */
.section-label {
  font-size: 11px; font-weight: 700; letter-spacing: 3px;
  text-transform: uppercase; color: var(--blue);
  margin-bottom: 20px;
  display: flex; align-items: center; gap: 12px;
  animation: fadeUp 0.55s var(--ease) 0.05s both;
}
.section-label::after { content: ''; flex: 1; height: 1px; background: var(--border); }

/* ── table card ── */
.table-card {
  background: var(--white);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  overflow: hidden;
  box-shadow: var(--shadow-md);
  animation: fadeUp 0.5s var(--ease) 0.10s both;
}

table { width: 100%; border-collapse: collapse; }

thead { background: linear-gradient(90deg, #0a1f44, #1a3a6e); }
body.dark thead { background: linear-gradient(90deg, #0d1a2e, #1e3a5f); }

thead th {
  padding: 16px 20px;
  font-size: 11px; font-weight: 700;
  letter-spacing: 1.5px; text-transform: uppercase;
  color: rgba(255,255,255,0.70);
  text-align: center;
}
thead th:first-child { text-align: left; }

tbody tr { border-bottom: 1px solid var(--border); transition: background 0.2s ease; }
tbody tr:last-child { border-bottom: none; }
tbody tr:hover { background: var(--sky); }

tbody td {
  padding: 16px 20px;
  font-size: 14px;
  color: var(--body);
  text-align: center;
  vertical-align: middle;
}
tbody td:first-child { text-align: left; }

/* id badges */
.id-badge {
  display: inline-flex; align-items: center;
  background: var(--sky2); color: var(--blue-mid);
  border: 1px solid var(--border);
  border-radius: 8px; padding: 4px 10px;
  font-size: 12px; font-weight: 700; font-family: monospace;
}

/* amount */
.amount-cell { font-weight: 700; font-size: 15px; color: var(--text); }
.amount-cell .currency { font-size: 12px; color: var(--muted); font-weight: 500; margin-right: 2px; }

/* status badge */
.status-badge {
  display: inline-flex; align-items: center; gap: 6px;
  padding: 5px 12px; border-radius: 100px;
  font-size: 12px; font-weight: 600; letter-spacing: 0.3px;
}
.status-pending { background: rgba(217,119,6,0.12); color: #d97706; border: 1px solid rgba(217,119,6,0.25); }
.status-pending::before { content: ''; width: 6px; height: 6px; border-radius: 50%; background: #d97706; display: inline-block; }

/* pay button */
.pay-btn {
  display: inline-flex; align-items: center; gap: 6px;
  background: var(--blue-mid); color: #fff;
  border: none; padding: 8px 18px;
  border-radius: 10px; font-size: 13px; font-weight: 600;
  cursor: pointer; text-decoration: none; letter-spacing: 0.2px;
  font-family: var(--ff);
  transition: all 0.25s var(--ease);
}
.pay-btn:hover { background: var(--blue); transform: translateY(-2px); box-shadow: 0 6px 18px rgba(37,99,235,0.35); }
.pay-btn:active { transform: translateY(0); }

/* empty state */
.empty-state {
  text-align: center; padding: 64px 20px;
  color: var(--muted);
}
.empty-state .empty-icon { font-size: 48px; display: block; margin-bottom: 16px; }
.empty-state h3 { font-size: 18px; font-weight: 700; color: var(--text); margin-bottom: 6px; }
.empty-state p { font-size: 14px; }

/* ═══════════════════════════════════════
   ANIMATION
═══════════════════════════════════════ */
@keyframes fadeUp {
  from { opacity: 0; transform: translateY(20px); }
  to   { opacity: 1; transform: translateY(0); }
}

/* ═══════════════════════════════════════
   SCROLLBAR
═══════════════════════════════════════ */
::-webkit-scrollbar { width: 6px; }
::-webkit-scrollbar-track { background: var(--offwhite); }
::-webkit-scrollbar-thumb { background: var(--border); border-radius: 10px; }
::-webkit-scrollbar-thumb:hover { background: var(--blue); }

/* ═══════════════════════════════════════
   RESPONSIVE
═══════════════════════════════════════ */
@media (max-width: 900px) {
  :root { --sidebar-w: 200px; }
  main { padding: calc(var(--header-h) + 28px) 24px 40px; }
  header { padding-left: calc(200px + 24px); }
}
@media (max-width: 640px) {
  nav { transform: translateX(-100%); }
  main { margin-left: 0; padding: calc(var(--header-h) + 20px) 16px 40px; }
  header { padding-left: 20px; }
  .page-banner { flex-direction: column; gap: 24px; align-items: flex-start; padding: 28px 24px; }
  .banner-text h1 { font-size: 24px; }
  .banner-stats { flex-wrap: wrap; }
  table { font-size: 13px; }
  thead th, tbody td { padding: 12px 10px; }
}
</style>
</head>

<body class="<%= "dark".equals(theme) ? "dark" : "" %>">

<!-- ═══ SIDEBAR ═══ -->
<nav>
  <div class="nav-brand">
    <div class="nav-brand-icon">⚙</div>
    <span class="nav-brand-text">PSRS</span>
  </div>

  <div class="nav-links">
    <a href="user_dashboard.jsp">
      <span class="nav-icon">🏠</span> Dashboard
    </a>
    <a href="#" onclick="loadProfile(); return false;">
      <span class="nav-icon">👤</span> Profile
    </a>
    <a href="#" onclick="loadProgress(); return false;">
      <span class="nav-icon">📊</span> Track Requests
    </a>
    <a href="user_payments.jsp" class="active">
      <span class="nav-icon">💳</span> Payments
    </a>
  </div>

  <div class="nav-divider"></div>

  <div class="nav-bottom">
    <a href="#" id="themeToggle">
      <span class="nav-icon" id="themeIcon">🌙</span> Toggle Theme
    </a>
    <a href="#" id="logoutBtn" style="color:rgba(248,113,113,0.70);">
      <span class="nav-icon">🚪</span> Logout
    </a>
  </div>
</nav>

<!-- ═══ HEADER ═══ -->
<header>
  <div class="header-title">Payments</div>
  <div class="header-right">
    <span class="visit-badge">Pending: <strong><%= pendingCount %></strong></span>
  </div>
</header>

<!-- ═══ MAIN ═══ -->
<main>

  <!-- Page Banner -->
  <div class="page-banner">
    <div class="banner-text">
      <h1>Your <span class="accent">Payments</span> 💳</h1>
      <p>Review and complete your pending payment requests below.</p>
    </div>
    <div class="banner-stats">
      <div class="stat-pill">
        <span class="stat-num"><%= pendingCount %></span>
        <span class="stat-label">Pending</span>
      </div>
      <div class="stat-pill">
        <span class="stat-num">₹<%= String.format("%.0f", totalDue) %></span>
        <span class="stat-label">Total Due</span>
      </div>
    </div>
  </div>

  <!-- Section Label -->
  <div class="section-label">Pending Payments</div>

  <!-- Table Card -->
  <div class="table-card">
    <table>
      <thead>
        <tr>
          <th>Payment ID</th>
          <th>Request ID</th>
          <th>Amount</th>
          <th>Status</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
<%
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;
try {
    con = DBConnection.getConnection();
    ps  = con.prepareStatement(
        "SELECT * FROM payments WHERE username=? AND payment_status='PENDING' ORDER BY payment_id DESC"
    );
    ps.setString(1, username);
    rs = ps.executeQuery();

    boolean hasRows = false;
    while (rs.next()) {
        hasRows = true;
%>
        <tr>
          <td><span class="id-badge">#PAY-<%= rs.getInt("payment_id") %></span></td>
          <td><span class="id-badge">#REQ-<%= rs.getInt("request_id") %></span></td>
          <td class="amount-cell"><span class="currency">₹</span><%= String.format("%.2f", rs.getDouble("amount")) %></td>
          <td><span class="status-badge status-pending">Pending</span></td>
          <td>
            <a class="pay-btn" href="make_payment.jsp?paymentId=<%= rs.getInt("payment_id") %>">
              Pay Now ↗
            </a>
          </td>
        </tr>
<%
    }

    if (!hasRows) {
%>
        <tr>
          <td colspan="5">
            <div class="empty-state">
              <span class="empty-icon">🎉</span>
              <h3>All Caught Up!</h3>
              <p>You have no pending payments at the moment.</p>
            </div>
          </td>
        </tr>
<%
    }
} catch (Exception e) {
    out.println("<tr><td colspan='5' style='text-align:center;padding:20px;color:red;'>Error loading payments: " + e.getMessage() + "</td></tr>");
} finally {
    if (rs  != null) try { rs.close();  } catch(Exception ignored) {}
    if (ps  != null) try { ps.close();  } catch(Exception ignored) {}
    if (con != null) try { con.close(); } catch(Exception ignored) {}
}
%>
      </tbody>
    </table>
  </div>

</main>

<jsp:include page="/components/chatbot.jsp" />

<script>
document.getElementById("logoutBtn").addEventListener("click", function(e) {
    e.preventDefault();
    localStorage.clear();
    window.location.href = "../../loginmodule/html/citizen_login.html";
});

document.getElementById("themeToggle").addEventListener("click", function(e) {
    e.preventDefault();
    document.body.classList.toggle("dark");
    const newTheme = document.body.classList.contains("dark") ? "dark" : "light";
    document.cookie = "theme=" + newTheme +
        "; path=<%= request.getContextPath() %>; max-age=" + (60 * 60 * 24 * 30);
    document.getElementById("themeIcon").textContent = newTheme === "dark" ? "☀️" : "🌙";
});

/* Keep these stubs so any included fragments that call them don't break */
function loadProfile()  { window.location.href = "user_dashboard.jsp"; }
function loadProgress() { window.location.href = "user_dashboard.jsp"; }
</script>

</body>
</html>
