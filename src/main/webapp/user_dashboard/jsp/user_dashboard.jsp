<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, javax.servlet.http.Cookie" %>
<%@ page import="java.sql.*, util.DBConnection" %>

<%! 
    public String formatName(String name) {
        if (name == null || name.trim().isEmpty()) return "Guest";
        return name.toUpperCase();
    }
%>

<%
HttpSession sess = request.getSession(false);

if (sess == null || sess.getAttribute("username") == null) {
    response.sendRedirect(request.getContextPath() + "/loginmodule/html/select_role.html");
    return;
}

String rawUsername = (String) sess.getAttribute("username");
String userName    = formatName(rawUsername);
int    visitCount  = 0;

try {
    Connection        con = DBConnection.getConnection();
    PreparedStatement ps  = con.prepareStatement("SELECT visit_count FROM users WHERE username=?");
    ps.setString(1, rawUsername);
    ResultSet rs = ps.executeQuery();
    if (rs.next()) visitCount = rs.getInt("visit_count");
    rs.close(); ps.close(); con.close();
} catch (Exception e) { e.printStackTrace(); }

String sessionId = sess.getId();

String   theme   = "light";
Cookie[] cookies = request.getCookies();
if (cookies != null) {
    for (Cookie c : cookies) {
        if ("theme".equals(c.getName())) theme = c.getValue();
    }
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Citizen Dashboard — PSRS</title>
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
  --shadow-lg:  0 20px 56px rgba(10,31,68,0.16);
  --radius:     16px;
  --ff:         'Plus Jakarta Sans', sans-serif;
  --ff-display: 'Playfair Display', serif;
  --ease:       cubic-bezier(0.22,1,0.36,1);
}

/* dark theme overrides */
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
*, *::before, *::after { margin:0; padding:0; box-sizing:border-box; }
html { scroll-behavior:smooth; }

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
  font-family: var(--ff);
  font-weight: 700;
  font-size: 16px;
  color: rgba(255,255,255,0.90);
  letter-spacing: 0.2px;
  display: flex;
  align-items: center;
  gap: 10px;
}
.header-title::before {
  content: '🏛️';
  font-size: 18px;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 16px;
}

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

.session-tag {
  font-size: 10px;
  font-family: 'Courier New', monospace;
  color: rgba(255,255,255,0.30);
  letter-spacing: 0.5px;
}

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
  padding: 0;
  z-index: 400;
  box-shadow: 2px 0 20px rgba(10,31,68,0.20);
  transition: background 0.3s ease;
}
body.dark nav { background: #080f1e; }

/* brand area */
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
  font-size: 16px;
  flex-shrink: 0;
}
.nav-brand-text {
  font-size: 13px;
  font-weight: 700;
  color: rgba(255,255,255,0.85);
  line-height: 1.3;
}

/* nav links */
.nav-links {
  display: flex;
  flex-direction: column;
  padding: 20px 14px;
  gap: 4px;
  flex: 1;
}

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
nav a:hover {
  background: rgba(255,255,255,0.08);
  color: rgba(255,255,255,0.95);
  transform: translateX(4px);
}
nav a.active {
  background: rgba(37,99,235,0.30);
  color: #93c5fd;
  font-weight: 600;
}
nav a.active::before {
  content: '';
  position: absolute;
  left: 0; top: 25%; bottom: 25%;
  width: 3px;
  border-radius: 0 3px 3px 0;
  background: var(--blue-light);
}

/* divider */
.nav-divider {
  height: 1px;
  background: rgba(255,255,255,0.07);
  margin: 8px 14px;
}

/* bottom links (theme, logout) */
.nav-bottom {
  padding: 14px;
  border-top: 1px solid rgba(255,255,255,0.07);
}
.nav-bottom a {
  margin: 0;
}

/* ═══════════════════════════════════════
   MAIN CONTENT
═══════════════════════════════════════ */
main {
  margin-left: var(--sidebar-w);
  padding-top: calc(var(--header-h) + 40px);
  padding-right: 40px;
  padding-bottom: 60px;
  padding-left: 40px;
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
  display: flex;
  align-items: center;
  justify-content: space-between;
  position: relative;
  overflow: hidden;
  animation: fadeUp 0.55s var(--ease) both;
}
.welcome-banner::before {
  content: '';
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 4px;
  background: linear-gradient(90deg, #0a1f44, #1a56db, #3b82f6);
}
.welcome-banner::after {
  content: 'PSRS';
  position: absolute;
  right: 28px; bottom: -12px;
  font-family: var(--ff-display);
  font-size: 90px;
  font-weight: 800;
  color: rgba(10,31,68,0.035);
  letter-spacing: -4px;
  pointer-events: none;
  user-select: none;
}
body.dark .welcome-banner::after { color: rgba(255,255,255,0.03); }

.welcome-text h1 {
  font-family: var(--ff-display);
  font-size: 30px;
  font-weight: 800;
  color: var(--navy);
  letter-spacing: -0.3px;
  margin-bottom: 6px;
}
.welcome-text h1 .name {
  color: var(--blue-mid);
}
.welcome-text p {
  font-size: 14px;
  color: var(--muted);
  font-weight: 400;
}

.welcome-stats {
  display: flex;
  gap: 20px;
}
.stat-pill {
  background: var(--sky);
  border: 1px solid var(--border);
  border-radius: 14px;
  padding: 14px 22px;
  text-align: center;
  min-width: 100px;
}
.stat-pill .stat-num {
  font-family: var(--ff);
  font-size: 26px;
  font-weight: 800;
  color: var(--blue-mid);
  display: block;
  line-height: 1;
}
.stat-pill .stat-label {
  font-size: 11px;
  font-weight: 600;
  letter-spacing: 0.5px;
  color: var(--muted);
  text-transform: uppercase;
  margin-top: 4px;
  display: block;
}

/* ── section heading ── */
.section-label {
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 3px;
  text-transform: uppercase;
  color: var(--blue);
  margin-bottom: 20px;
  display: flex;
  align-items: center;
  gap: 12px;
  animation: fadeUp 0.55s var(--ease) 0.05s both;
}
.section-label::after {
  content: '';
  flex: 1;
  height: 1px;
  background: var(--border);
}

/* ── CATEGORY CARDS ── */
.categories {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
}

.category-card {
  background: var(--white);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 32px 28px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  box-shadow: var(--shadow-sm);
  transition: transform 0.35s var(--ease),
              box-shadow 0.35s var(--ease),
              border-color 0.35s var(--ease);
}

/* colored top bar */
.category-card::before {
  content: '';
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--c, var(--blue)), var(--c2, var(--blue-light)));
  border-radius: var(--radius) var(--radius) 0 0;
  transform: scaleX(0);
  transform-origin: left;
  transition: transform 0.4s var(--ease);
}

/* glow circle */
.category-card::after {
  content: '';
  position: absolute;
  bottom: -40px; right: -40px;
  width: 110px; height: 110px;
  border-radius: 50%;
  background: var(--c, var(--blue));
  opacity: 0.05;
  transition: opacity 0.35s ease, transform 0.4s var(--ease);
}

.category-card:hover {
  transform: translateY(-8px);
  border-color: var(--c, var(--blue));
  box-shadow: 0 22px 55px rgba(10,31,68,0.13),
              0 0 0 1px var(--c, var(--blue));
}
.category-card:hover::before { transform: scaleX(1); }
.category-card:hover::after  { opacity: 0.10; transform: scale(1.5); }

/* per-card accent pairs */
.category-card:nth-child(1) { --c:#1a56db; --c2:#60a5fa; }
.category-card:nth-child(2) { --c:#0891b2; --c2:#22d3ee; }
.category-card:nth-child(3) { --c:#7c3aed; --c2:#a78bfa; }
.category-card:nth-child(4) { --c:#059669; --c2:#34d399; }
.category-card:nth-child(5) { --c:#d97706; --c2:#fbbf24; }
.category-card:nth-child(6) { --c:#dc2626; --c2:#f87171; }

.category-card h3 {
  font-family: var(--ff);
  font-weight: 700;
  font-size: 16px;
  color: var(--text);
  margin-bottom: 10px;
  transition: color 0.3s ease;
}
.category-card:hover h3 { color: var(--c, var(--blue)); }

.category-card p {
  font-size: 13.5px;
  font-weight: 400;
  color: var(--muted);
  line-height: 1.75;
}

/* staggered card animations */
.category-card:nth-child(1) { animation: fadeUp 0.5s var(--ease) 0.10s both; }
.category-card:nth-child(2) { animation: fadeUp 0.5s var(--ease) 0.15s both; }
.category-card:nth-child(3) { animation: fadeUp 0.5s var(--ease) 0.20s both; }
.category-card:nth-child(4) { animation: fadeUp 0.5s var(--ease) 0.25s both; }
.category-card:nth-child(5) { animation: fadeUp 0.5s var(--ease) 0.30s both; }
.category-card:nth-child(6) { animation: fadeUp 0.5s var(--ease) 0.35s both; }

/* ═══════════════════════════════════════
   ANIMATION
═══════════════════════════════════════ */
@keyframes fadeUp {
  from { opacity:0; transform:translateY(20px); }
  to   { opacity:1; transform:translateY(0); }
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
  nav { width: 200px; }
  main { margin-left: 200px; padding: calc(var(--header-h) + 28px) 24px 40px; }
  header { padding-left: calc(200px + 24px); }
}
@media (max-width: 640px) {
  nav { transform: translateX(-100%); }
  main { margin-left: 0; padding: calc(var(--header-h) + 20px) 16px 40px; }
  header { padding-left: 20px; }
  .welcome-banner { flex-direction: column; gap: 24px; align-items: flex-start; padding: 28px 24px; }
  .welcome-text h1 { font-size: 24px; }
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
    <a href="user_dashboard.jsp" class="active">
      <span class="nav-icon">🏠</span> Dashboard
    </a>
    <a href="#" onclick="loadProfile(); return false;">
      <span class="nav-icon">👤</span> Profile
    </a>
    <a href="#" onclick="loadProgress(); return false;">
      <span class="nav-icon">📊</span> Track Requests
    </a>
    <a href="user_payments.jsp">
      <span class="nav-icon">💳</span> Payments
    </a>
  </div>

  <div class="nav-divider"></div>

  <div class="nav-bottom">
    <a href="#" id="themeToggle">
      <span class="nav-icon">🌙</span> Toggle Theme
    </a>
    <a href="#" id="logoutBtn" style="color:rgba(248,113,113,0.70);">
      <span class="nav-icon">🚪</span> Logout
    </a>
  </div>
</nav>

<!-- ═══ HEADER ═══ -->
<header>
  <div class="header-title">Citizen Dashboard</div>
  <div class="header-right">
    <span class="visit-badge">Visits: <strong><%= visitCount %></strong></span>
    <span class="session-tag">ID: <%= sessionId.substring(0, Math.min(10, sessionId.length())) %>…</span>
  </div>
</header>

<!-- ═══ MAIN ═══ -->
<main>
  <div id="mainContent">

    <!-- Welcome Banner -->
    <div class="welcome-banner">
      <div class="welcome-text">
        <h1>Hello, <span class="name"><%= userName %></span> 👋</h1>
        <p>Select a service category below to raise a new request.</p>
      </div>
      <div class="welcome-stats">
        <div class="stat-pill">
          <span class="stat-num"><%= visitCount %></span>
          <span class="stat-label">Visits</span>
        </div>
      </div>
    </div>

    <!-- Category Label -->
    <div class="section-label">Service Categories</div>

    <!-- Category Cards -->
    <section class="categories">

      <div class="category-card" onclick="redirectToCategory('WATER')">
        <h3>🚰 Water Supply Issues</h3>
        <p>Report water-related issues and track resolution progress.</p>
      </div>

      <div class="category-card" onclick="redirectToCategory('ELECTRICITY')">
        <h3>⚡ Electricity Problems</h3>
        <p>Submit complaints about outages or wiring problems.</p>
      </div>

      <div class="category-card" onclick="redirectToCategory('ROAD')">
        <h3>🛣️ Road &amp; Infrastructure</h3>
        <p>Report potholes and unsafe infrastructure issues.</p>
      </div>

      <div class="category-card" onclick="redirectToCategory('SANITATION')">
        <h3>🗑️ Sanitation &amp; Waste</h3>
        <p>Flag garbage collection or hygiene problems.</p>
      </div>

      <div class="category-card" onclick="redirectToCategory('STREETLIGHT')">
        <h3>💡 Street Light Issues</h3>
        <p>Report non-functional or damaged street lights.</p>
      </div>

      <div class="category-card" onclick="redirectToCategory('PUBLICPROPERTY')">
        <h3>🏛️ Public Property Damage</h3>
        <p>Report damage to public facilities and property.</p>
      </div>

    </section>

  </div><!-- #mainContent -->
</main>

<jsp:include page="/components/chatbot.jsp" />

<script>
/* ── all original logic, unchanged ── */
function viewProgress(requestId) {
    fetch("view_progress.jsp?requestId=" + requestId)
        .then(res => res.text())
        .then(data => { document.getElementById("mainContent").innerHTML = data; });
}
function loadProgress() {
    fetch("user_progress.jsp")
        .then(response => response.text())
        .then(data => { document.getElementById("mainContent").innerHTML = data; })
        .catch(error => console.error("Error loading progress:", error));
}
function loadDashboard() { location.reload(); }
function loadProfile() {
    fetch("user_profile.jsp")
        .then(response => response.text())
        .then(data => { document.getElementById("mainContent").innerHTML = data; })
        .catch(error => console.error("Error loading profile:", error));
}
function redirectToCategory(category) {
    window.location.href = "raise_request.jsp?category=" + encodeURIComponent(category);
}

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
    const icon = this.querySelector(".nav-icon");
    icon.textContent = newTheme === "dark" ? "☀️" : "🌙";
});
</script>

</body>
</html>
