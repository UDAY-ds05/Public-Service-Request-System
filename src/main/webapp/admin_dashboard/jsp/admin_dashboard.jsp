<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DBConnection" %>
<%@ page import="javax.servlet.http.Cookie" %>

<%
HttpSession sess = request.getSession(false);

if (sess == null || sess.getAttribute("username") == null ||
   !"ADMIN".equalsIgnoreCase((String) sess.getAttribute("role"))) {
    response.sendRedirect(request.getContextPath() + "/loginmodule/html/select_role.html");
    return;
}

String rawAdmin  = (String) sess.getAttribute("username");
String adminName = rawAdmin.toUpperCase();
String sessionId = sess.getId();

String theme = "light";
Cookie[] cookies = request.getCookies();
if (cookies != null) {
    for (Cookie c : cookies) {
        if ("theme".equals(c.getName())) theme = c.getValue();
    }
}

String pageName = request.getParameter("page");
if (pageName == null) pageName = "allocate";

/* ── quick stats for banner ── */
int totalRequests = 0, pendingRequests = 0, resolvedRequests = 0;
Connection conStats = null; PreparedStatement psStats = null; ResultSet rsStats = null;
try {
    conStats = DBConnection.getConnection();
    psStats  = conStats.prepareStatement("SELECT COUNT(*) FROM requests");
    rsStats  = psStats.executeQuery();
    if (rsStats.next()) totalRequests = rsStats.getInt(1);
    rsStats.close(); psStats.close();

    psStats = conStats.prepareStatement("SELECT COUNT(*) FROM requests WHERE status='PENDING'");
    rsStats = psStats.executeQuery();
    if (rsStats.next()) pendingRequests = rsStats.getInt(1);
    rsStats.close(); psStats.close();

    psStats = conStats.prepareStatement("SELECT COUNT(*) FROM requests WHERE status='RESOLVED'");
    rsStats = psStats.executeQuery();
    if (rsStats.next()) resolvedRequests = rsStats.getInt(1);
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
<title>Admin Dashboard — PSRS</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet">

<style>
/* ═══════════════════════════════════════
   TOKENS
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
  font-weight: 700; font-size: 16px;
  color: rgba(255,255,255,0.90); letter-spacing: 0.2px;
  display: flex; align-items: center; gap: 10px;
}
.header-title::before { content: '🛡️'; font-size: 18px; }

.header-right { display: flex; align-items: center; gap: 16px; }

.admin-badge {
  font-size: 12px; font-weight: 600;
  color: rgba(255,255,255,0.55);
  background: rgba(255,255,255,0.08);
  border: 1px solid rgba(255,255,255,0.12);
  padding: 5px 14px; border-radius: 100px; letter-spacing: 0.3px;
}
.admin-badge strong { color: rgba(255,255,255,0.88); }

.session-tag {
  font-size: 10px; font-family: 'Courier New', monospace;
  color: rgba(255,255,255,0.30); letter-spacing: 0.5px;
}

/* ═══════════════════════════════════════
   SIDEBAR
═══════════════════════════════════════ */
nav {
  width: var(--sidebar-w);
  background: #0a1f44;
  height: 100vh;
  position: fixed; top: 0; left: 0;
  display: flex; flex-direction: column;
  z-index: 400;
  box-shadow: 2px 0 20px rgba(10,31,68,0.20);
  transition: background 0.3s ease;
}
body.dark nav { background: #080f1e; }

.nav-brand {
  height: var(--header-h);
  display: flex; align-items: center; gap: 10px;
  padding: 0 24px;
  border-bottom: 1px solid rgba(255,255,255,0.07);
  flex-shrink: 0;
}
.nav-brand-icon {
  width: 32px; height: 32px; border-radius: 8px;
  background: rgba(59,130,246,0.30);
  display: flex; align-items: center; justify-content: center;
  font-size: 16px; flex-shrink: 0;
}
.nav-brand-text { font-size: 13px; font-weight: 700; color: rgba(255,255,255,0.85); line-height: 1.3; }

/* role chip */
.nav-role-chip {
  display: inline-block;
  font-size: 9px; font-weight: 700; letter-spacing: 1px;
  text-transform: uppercase; color: #93c5fd;
  background: rgba(37,99,235,0.25);
  border: 1px solid rgba(59,130,246,0.35);
  border-radius: 100px; padding: 2px 8px;
  margin-top: 2px;
}

.nav-links { display: flex; flex-direction: column; padding: 20px 14px; gap: 4px; flex: 1; }

nav a {
  display: flex; align-items: center; gap: 12px;
  color: rgba(255,255,255,0.60);
  text-decoration: none; padding: 11px 14px;
  border-radius: 10px; font-size: 14px; font-weight: 500;
  letter-spacing: 0.1px;
  transition: all 0.25s var(--ease); position: relative;
}
nav a .nav-icon { font-size: 16px; flex-shrink: 0; }
nav a:hover { background: rgba(255,255,255,0.08); color: rgba(255,255,255,0.95); transform: translateX(4px); }
nav a.active { background: rgba(37,99,235,0.30); color: #93c5fd; font-weight: 600; }
nav a.active::before {
  content: ''; position: absolute; left: 0; top: 25%; bottom: 25%;
  width: 3px; border-radius: 0 3px 3px 0; background: var(--blue-light);
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

/* ── welcome banner ── */
.welcome-banner {
  background: var(--white);
  border: 1px solid var(--border);
  border-radius: 24px;
  padding: 36px 48px;
  margin-bottom: 36px;
  box-shadow: var(--shadow-md);
  display: flex; align-items: center; justify-content: space-between;
  position: relative; overflow: hidden;
  animation: fadeUp 0.55s var(--ease) both;
}
.welcome-banner::before {
  content: ''; position: absolute; top: 0; left: 0; right: 0; height: 4px;
  background: linear-gradient(90deg, #0a1f44, #1a56db, #3b82f6);
}
.welcome-banner::after {
  content: 'ADMIN';
  position: absolute; right: 28px; bottom: -12px;
  font-family: var(--ff-display);
  font-size: 72px; font-weight: 800;
  color: rgba(10,31,68,0.035); letter-spacing: -3px;
  pointer-events: none; user-select: none;
}
body.dark .welcome-banner::after { color: rgba(255,255,255,0.03); }

.welcome-text h1 {
  font-family: var(--ff-display);
  font-size: 30px; font-weight: 800;
  color: var(--navy); letter-spacing: -0.3px; margin-bottom: 6px;
}
.welcome-text h1 .name { color: var(--blue-mid); }
.welcome-text p { font-size: 14px; color: var(--muted); }

.welcome-stats { display: flex; gap: 16px; }
.stat-pill {
  background: var(--sky); border: 1px solid var(--border);
  border-radius: 14px; padding: 14px 20px; text-align: center; min-width: 90px;
}
.stat-pill .stat-num { font-size: 24px; font-weight: 800; color: var(--blue-mid); display: block; line-height: 1; }
.stat-pill .stat-label { font-size: 10px; font-weight: 600; letter-spacing: 0.5px; color: var(--muted); text-transform: uppercase; margin-top: 4px; display: block; }
.stat-pill.green .stat-num { color: #059669; }
.stat-pill.green { background: rgba(5,150,105,0.08); border-color: rgba(5,150,105,0.25); }
.stat-pill.amber .stat-num { color: #d97706; }
.stat-pill.amber { background: rgba(217,119,6,0.08); border-color: rgba(217,119,6,0.25); }

/* ── section label ── */
.section-label {
  font-size: 11px; font-weight: 700; letter-spacing: 3px;
  text-transform: uppercase; color: var(--blue);
  margin-bottom: 20px;
  display: flex; align-items: center; gap: 12px;
  animation: fadeUp 0.55s var(--ease) 0.05s both;
}
.section-label::after { content: ''; flex: 1; height: 1px; background: var(--border); }

/* ── content card ── */
.content-card {
  background: var(--white);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 32px 36px;
  box-shadow: var(--shadow-md);
  animation: fadeUp 0.5s var(--ease) 0.10s both;
}

/* ── global form element overrides (theme-aware) ── */
select, input[type="text"], input[type="email"],
input[type="password"], input[type="number"], textarea {
  background: var(--sky);
  color: var(--text);
  border: 1px solid var(--border);
  border-radius: 10px;
  padding: 10px 14px;
  font-size: 14px;
  font-family: var(--ff);
  transition: border-color 0.25s ease, box-shadow 0.25s ease;
  outline: none;
  appearance: none; -webkit-appearance: none;
}
select:focus, input:focus, textarea:focus {
  border-color: var(--blue-mid);
  box-shadow: 0 0 0 3px rgba(37,99,235,0.12);
}
select:hover, input:hover { border-color: var(--blue-light); }
select option { background: var(--white); color: var(--text); }

button {
  padding: 9px 18px;
  background: var(--blue-mid); color: #fff;
  border: none; border-radius: 10px;
  font-size: 13px; font-weight: 600; font-family: var(--ff);
  cursor: pointer; letter-spacing: 0.2px;
  transition: all 0.25s var(--ease);
}
button:hover { background: var(--blue); transform: translateY(-2px); box-shadow: 0 6px 18px rgba(37,99,235,0.32); }
button:active { transform: translateY(0); }

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
  .welcome-banner { flex-direction: column; gap: 24px; align-items: flex-start; padding: 28px 24px; }
  .welcome-text h1 { font-size: 24px; }
  .welcome-stats { flex-wrap: wrap; }
}
</style>
</head>

<body class="<%= "dark".equals(theme) ? "dark" : "" %>">

<!-- ═══ SIDEBAR ═══ -->
<nav>
  <div class="nav-brand">
    <div class="nav-brand-icon">🛡️</div>
    <div>
      <div class="nav-brand-text">PSRS</div>
      <span class="nav-role-chip">Admin</span>
    </div>
  </div>

  <div class="nav-links">
    <a href="admin_dashboard.jsp?page=allocate" class="<%= "allocate".equals(pageName) ? "active" : "" %>">
      <span class="nav-icon">👷</span> Allocate Officers
    </a>
    <a href="admin_dashboard.jsp?page=profile" class="<%= "profile".equals(pageName) ? "active" : "" %>">
      <span class="nav-icon">👤</span> Profile
    </a>
  </div>

  <div class="nav-divider"></div>

  <div class="nav-bottom">
    <a href="#" id="themeToggle">
      <span class="nav-icon" id="themeIcon">🌙</span> Toggle Theme
    </a>
    <a href="<%= request.getContextPath() %>/LogoutServlet" style="color:rgba(248,113,113,0.70);">
      <span class="nav-icon">🚪</span> Logout
    </a>
  </div>
</nav>

<!-- ═══ HEADER ═══ -->
<header>
  <div class="header-title">Admin Dashboard</div>
  <div class="header-right">
    <span class="admin-badge">👋 <strong><%= adminName %></strong></span>
    <span class="session-tag">ID: <%= sessionId.substring(0, Math.min(10, sessionId.length())) %>…</span>
  </div>
</header>

<!-- ═══ MAIN ═══ -->
<main>

  <!-- Welcome Banner -->
  <div class="welcome-banner">
    <div class="welcome-text">
      <h1>Welcome, <span class="name"><%= adminName %></span> 👋</h1>
      <p>Here's a live overview of all citizen service requests.</p>
    </div>
    <div class="welcome-stats">
      <div class="stat-pill">
        <span class="stat-num"><%= totalRequests %></span>
        <span class="stat-label">Total</span>
      </div>
      <div class="stat-pill amber">
        <span class="stat-num"><%= pendingRequests %></span>
        <span class="stat-label">Pending</span>
      </div>
      <div class="stat-pill green">
        <span class="stat-num"><%= resolvedRequests %></span>
        <span class="stat-label">Resolved</span>
      </div>
    </div>
  </div>

  <!-- Section Label -->
  <div class="section-label">
    <%= "allocate".equals(pageName) ? "Officer Allocation" : "Admin Profile" %>
  </div>

  <!-- Content Card -->
  <div class="content-card">
    <%
        if ("allocate".equals(pageName)) {
    %>
        <jsp:include page="allocate_officers.jsp"/>
    <%
        } else if ("profile".equals(pageName)) {
    %>
        <jsp:include page="admin_profile.jsp"/>
    <%
        }
    %>
  </div>

</main>

<script>
document.getElementById("themeToggle").addEventListener("click", function(e) {
    e.preventDefault();
    document.body.classList.toggle("dark");
    const newTheme = document.body.classList.contains("dark") ? "dark" : "light";
    document.cookie = "theme=" + newTheme +
        "; path=<%= request.getContextPath() %>; max-age=" + (60 * 60 * 24 * 30);
    document.getElementById("themeIcon").textContent = newTheme === "dark" ? "☀️" : "🌙";
});
</script>

</body>
</html>
