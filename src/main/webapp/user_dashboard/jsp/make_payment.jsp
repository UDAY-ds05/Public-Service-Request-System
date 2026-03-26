<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.Cookie" %>

<%
HttpSession sess = request.getSession(false);
if (sess == null || sess.getAttribute("username") == null) {
    response.sendRedirect("../loginmodule/html/select_role.html");
    return;
}

String paymentId = request.getParameter("paymentId");

String theme = "light";
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
<title>Make Payment — PSRS</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet">

<style>
/* ═══════════════════════════════════════
   TOKENS — identical to dashboard
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
.header-title::before { content: '💳'; font-size: 18px; }

.header-badge {
  font-size: 12px; font-weight: 600;
  color: rgba(255,255,255,0.55);
  background: rgba(255,255,255,0.08);
  border: 1px solid rgba(255,255,255,0.12);
  padding: 5px 14px; border-radius: 100px; letter-spacing: 0.3px;
}
.header-badge strong { color: rgba(255,255,255,0.88); }

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

/* ── page banner ── */
.page-banner {
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
.page-banner::before {
  content: ''; position: absolute; top: 0; left: 0; right: 0; height: 4px;
  background: linear-gradient(90deg, #0a1f44, #1a56db, #3b82f6);
}
.page-banner::after {
  content: 'PAY';
  position: absolute; right: 28px; bottom: -12px;
  font-family: var(--ff-display);
  font-size: 90px; font-weight: 800;
  color: rgba(10,31,68,0.035); letter-spacing: -4px;
  pointer-events: none; user-select: none;
}
body.dark .page-banner::after { color: rgba(255,255,255,0.03); }

.banner-text h1 {
  font-family: var(--ff-display);
  font-size: 30px; font-weight: 800;
  color: var(--navy); letter-spacing: -0.3px; margin-bottom: 6px;
}
.banner-text h1 .accent { color: var(--blue-mid); }
.banner-text p { font-size: 14px; color: var(--muted); }

.banner-pill {
  background: var(--sky); border: 1px solid var(--border);
  border-radius: 14px; padding: 14px 22px; text-align: center; min-width: 130px;
}
.banner-pill .pill-num { font-size: 22px; font-weight: 800; color: var(--blue-mid); display: block; line-height: 1; font-family: monospace; }
.banner-pill .pill-label { font-size: 11px; font-weight: 600; letter-spacing: 0.5px; color: var(--muted); text-transform: uppercase; margin-top: 4px; display: block; }

/* ── section label ── */
.section-label {
  font-size: 11px; font-weight: 700; letter-spacing: 3px;
  text-transform: uppercase; color: var(--blue);
  margin-bottom: 20px;
  display: flex; align-items: center; gap: 12px;
  animation: fadeUp 0.55s var(--ease) 0.05s both;
}
.section-label::after { content: ''; flex: 1; height: 1px; background: var(--border); }

/* ── payment cards grid ── */
.payment-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
}

.payment-card {
  background: var(--white);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 32px 28px;
  position: relative; overflow: hidden;
  box-shadow: var(--shadow-sm);
  transition: transform 0.35s var(--ease), box-shadow 0.35s var(--ease), border-color 0.35s var(--ease);
}

/* colored top bar */
.payment-card::before {
  content: ''; position: absolute; top: 0; left: 0; right: 0; height: 4px;
  background: linear-gradient(90deg, var(--c, var(--blue)), var(--c2, var(--blue-light)));
  border-radius: var(--radius) var(--radius) 0 0;
  transform: scaleX(0); transform-origin: left;
  transition: transform 0.4s var(--ease);
}
.payment-card::after {
  content: ''; position: absolute; bottom: -40px; right: -40px;
  width: 110px; height: 110px; border-radius: 50%;
  background: var(--c, var(--blue)); opacity: 0.05;
  transition: opacity 0.35s ease, transform 0.4s var(--ease);
}
.payment-card:hover { transform: translateY(-6px); border-color: var(--c, var(--blue)); box-shadow: 0 18px 48px rgba(10,31,68,0.13), 0 0 0 1px var(--c, var(--blue)); }
.payment-card:hover::before { transform: scaleX(1); }
.payment-card:hover::after  { opacity: 0.10; transform: scale(1.5); }

.payment-card:nth-child(1) { --c:#1a56db; --c2:#60a5fa; animation: fadeUp 0.5s var(--ease) 0.10s both; }
.payment-card:nth-child(2) { --c:#7c3aed; --c2:#a78bfa; animation: fadeUp 0.5s var(--ease) 0.15s both; }
.payment-card:nth-child(3) { --c:#059669; --c2:#34d399; animation: fadeUp 0.5s var(--ease) 0.20s both; }

.card-title {
  font-size: 17px; font-weight: 700; color: var(--text);
  margin-bottom: 10px;
  transition: color 0.3s ease;
}
.payment-card:hover .card-title { color: var(--c, var(--blue)); }

.card-desc {
  font-size: 13.5px; color: var(--muted); line-height: 1.75; margin-bottom: 20px;
}

/* QR section */
.qr-section {
  display: flex; align-items: center; gap: 20px; margin-bottom: 20px;
}
.qr-img {
  width: 130px; height: 130px; border-radius: 12px;
  border: 2px solid var(--border); object-fit: cover;
  background: var(--sky);
}
.qr-details { font-size: 13px; color: var(--body); display: flex; flex-direction: column; gap: 6px; }
.qr-details span { display: flex; flex-direction: column; }
.qr-details .label { font-size: 10px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; color: var(--muted); margin-bottom: 1px; }
.qr-details .value { font-weight: 600; color: var(--text); }

/* inputs */
.input-group { margin-bottom: 14px; }
.input-group label { display: block; font-size: 11px; font-weight: 700; letter-spacing: 0.8px; text-transform: uppercase; color: var(--muted); margin-bottom: 6px; }

.input-box {
  width: 100%; padding: 11px 14px;
  background: var(--sky); color: var(--text);
  border: 1px solid var(--border); border-radius: 10px;
  font-size: 14px; font-family: var(--ff);
  transition: border-color 0.25s ease, box-shadow 0.25s ease;
  outline: none;
}
.input-box:focus { border-color: var(--blue-mid); box-shadow: 0 0 0 3px rgba(37,99,235,0.12); }
.input-box option { background: var(--white); color: var(--text); }

.input-row { display: flex; gap: 12px; }
.input-row .input-group { flex: 1; }

/* pay button */
.pay-btn {
  width: 100%; padding: 13px;
  background: var(--blue-mid); color: #fff;
  border: none; border-radius: 12px;
  font-size: 14px; font-weight: 700; font-family: var(--ff);
  cursor: pointer; letter-spacing: 0.3px;
  transition: all 0.25s var(--ease);
  margin-top: 4px;
}
.pay-btn:hover { background: var(--blue); transform: translateY(-2px); box-shadow: 0 8px 22px rgba(37,99,235,0.38); }
.pay-btn:active { transform: translateY(0); }

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
  .qr-section { flex-direction: column; align-items: flex-start; }
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
    <a href="#">
      <span class="nav-icon">👤</span> Profile
    </a>
    <a href="#">
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
  <div class="header-title">Make Payment</div>
  <div class="header-right" style="display:flex;align-items:center;gap:16px;">
    <span class="header-badge">ID: <strong>#PAY-<%= paymentId != null ? paymentId : "—" %></strong></span>
  </div>
</header>

<!-- ═══ MAIN ═══ -->
<main>

  <!-- Banner -->
  <div class="page-banner">
    <div class="banner-text">
      <h1>Select <span class="accent">Payment</span> Method 💳</h1>
      <p>Choose how you'd like to complete your payment for request <strong>#PAY-<%= paymentId != null ? paymentId : "—" %></strong>.</p>
    </div>
    <div class="banner-pill">
      <span class="pill-num">#<%= paymentId != null ? paymentId : "—" %></span>
      <span class="pill-label">Payment ID</span>
    </div>
  </div>

  <!-- Section Label -->
  <div class="section-label">Payment Methods</div>

  <!-- Payment Cards -->
  <div class="payment-grid">

    <!-- UPI -->
    <div class="payment-card">
      <h3 class="card-title">📱 UPI Payment</h3>
      <p class="card-desc">
        Scan the QR code using PhonePe, Google Pay, or Paytm.
        After completing the payment, click <strong>I Have Paid</strong>.
      </p>
      <div class="qr-section">
        <img src="qr.jpeg" class="qr-img" alt="UPI QR Code">
        <div class="qr-details">
          <span>
            <span class="label">UPI ID</span>
            <span class="value">civicpay@upi</span>
          </span>
          <span>
            <span class="label">Receiver</span>
            <span class="value">Municipal Services</span>
          </span>
          <span>
            <span class="label">Remarks</span>
            <span class="value">Include Payment ID</span>
          </span>
        </div>
      </div>
      <form action="/MyWebApp/PayServlet" method="post">
        <input type="hidden" name="paymentId" value="<%= paymentId %>">
        <input type="hidden" name="paymentMethod" value="UPI">
        <button class="pay-btn" type="submit">✔ I Have Paid</button>
      </form>
    </div>

    <!-- Credit / Debit Card -->
    <div class="payment-card">
      <h3 class="card-title">💳 Credit / Debit Card</h3>
      <p class="card-desc">Enter your card details below. Your transaction is secured with 256-bit encryption.</p>
      <form action="/MyWebApp/PayServlet" method="post">
        <input type="hidden" name="paymentId" value="<%= paymentId %>">
        <input type="hidden" name="paymentMethod" value="CARD">
        <div class="input-group">
          <label>Card Number</label>
          <input type="text" placeholder="1234 5678 9012 3456" class="input-box" name="cardNumber" maxlength="19">
        </div>
        <div class="input-row">
          <div class="input-group">
            <label>Expiry</label>
            <input type="text" placeholder="MM / YY" class="input-box" name="expiry" maxlength="5">
          </div>
          <div class="input-group">
            <label>CVV</label>
            <input type="password" placeholder="•••" class="input-box" name="cvv" maxlength="3">
          </div>
        </div>
        <button class="pay-btn" type="submit">🔒 Pay Securely</button>
      </form>
    </div>

    <!-- Net Banking -->
    <div class="payment-card">
      <h3 class="card-title">🏦 Net Banking</h3>
      <p class="card-desc">Select your bank and you'll be redirected to your bank's secure portal to complete the payment.</p>
      <form action="/MyWebApp/PayServlet" method="post">
        <input type="hidden" name="paymentId" value="<%= paymentId %>">
        <input type="hidden" name="paymentMethod" value="NETBANKING">
        <div class="input-group">
          <label>Select Bank</label>
          <select class="input-box" name="bank">
            <option value="">— Choose your bank —</option>
            <option value="SBI">State Bank of India</option>
            <option value="HDFC">HDFC Bank</option>
            <option value="ICICI">ICICI Bank</option>
            <option value="AXIS">Axis Bank</option>
            <option value="KOTAK">Kotak Mahindra</option>
            <option value="BOB">Bank of Baroda</option>
          </select>
        </div>
        <button class="pay-btn" type="submit">🏦 Proceed to Bank</button>
      </form>
    </div>

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

/* Card number auto-spacing */
const cardInput = document.querySelector('input[name="cardNumber"]');
if (cardInput) {
    cardInput.addEventListener("input", function() {
        let v = this.value.replace(/\D/g, "").substring(0, 16);
        this.value = v.replace(/(.{4})/g, "$1 ").trim();
    });
}

/* Expiry auto-slash */
const expiryInput = document.querySelector('input[name="expiry"]');
if (expiryInput) {
    expiryInput.addEventListener("input", function() {
        let v = this.value.replace(/\D/g, "").substring(0, 4);
        if (v.length >= 3) v = v.substring(0,2) + " / " + v.substring(2);
        this.value = v;
    });
}
</script>

</body>
</html>
