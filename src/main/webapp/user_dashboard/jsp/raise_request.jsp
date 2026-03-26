<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String category = request.getParameter("category");
    if (category == null || category.trim().isEmpty()) category = "GENERAL";

    // emoji map per category
    String catIcon = "📋";
    if      (category.equals("WATER"))        catIcon = "🚰";
    else if (category.equals("ELECTRICITY"))  catIcon = "⚡";
    else if (category.equals("ROAD"))         catIcon = "🛣️";
    else if (category.equals("SANITATION"))   catIcon = "🗑️";
    else if (category.equals("STREETLIGHT"))  catIcon = "💡";
    else if (category.equals("PUBLICPROPERTY")) catIcon = "🏛️";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Raise Request — <%= category %></title>
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
    --shadow-sm:  0 2px 8px rgba(10,31,68,0.07);
    --shadow-md:  0 8px 28px rgba(10,31,68,0.11);
    --shadow-lg:  0 20px 56px rgba(10,31,68,0.16);
    --radius:     16px;
    --ff:         'Plus Jakarta Sans', sans-serif;
    --ff-display: 'Playfair Display', serif;
    --ease:       cubic-bezier(0.22,1,0.36,1);
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
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 48px 20px;
    color: var(--text);
  }

  /* ═══════════════════════════════════════
     CONTAINER
  ═══════════════════════════════════════ */
  .container {
    width: 100%;
    max-width: 680px;
    background: var(--white);
    border: 1px solid var(--border);
    border-radius: 28px;
    box-shadow: var(--shadow-lg);
    overflow: hidden;
    animation: fadeUp 0.55s var(--ease) both;
  }

  /* top gradient stripe */
  .container::before {
    content: none;
  }

  /* ═══════════════════════════════════════
     CARD TOP HEADER
  ═══════════════════════════════════════ */
  .card-top {
    background: var(--navy);
    padding: 36px 44px 32px;
    position: relative;
    overflow: hidden;
  }
  .card-top::after {
    content: '<%= category %>';
    position: absolute;
    right: 24px; bottom: -14px;
    font-family: var(--ff-display);
    font-size: 80px;
    font-weight: 800;
    color: rgba(255,255,255,0.04);
    letter-spacing: -3px;
    pointer-events: none;
    user-select: none;
  }
  /* rainbow bar at very top */
  .card-top::before {
    content: '';
    position: absolute;
    top: 0; left: 0; right: 0;
    height: 4px;
    background: linear-gradient(90deg, #3b82f6, #1a56db, #0a1f44);
  }

  .cat-badge {
    display: inline-flex;
    align-items: center;
    gap: 7px;
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 2.5px;
    text-transform: uppercase;
    color: var(--blue-light);
    background: rgba(59,130,246,0.15);
    border: 1px solid rgba(59,130,246,0.25);
    padding: 5px 14px;
    border-radius: 100px;
    margin-bottom: 16px;
  }

  .card-top h1 {
    font-family: var(--ff-display);
    font-size: 30px;
    font-weight: 800;
    color: var(--white);
    letter-spacing: -0.3px;
    margin-bottom: 8px;
    text-align: left;
    color: #fff;
  }
  .card-top p {
    font-size: 14px;
    font-weight: 400;
    color: rgba(255,255,255,0.50);
    line-height: 1.7;
    text-align: left;
    margin: 0;
  }

  /* ═══════════════════════════════════════
     FORM BODY
  ═══════════════════════════════════════ */
  .form-body {
    padding: 40px 44px 44px;
  }

  form { width: 100%; }

  /* section heading */
  .form-section-title {
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 3px;
    text-transform: uppercase;
    color: var(--blue);
    margin: 28px 0 18px;
  }
  .form-section-title:first-child { margin-top: 0; }
  .form-section-title::after {
    content: '';
    flex: 1;
    height: 1px;
    background: var(--border);
  }

  /* field group */
  .field-group {
    margin-bottom: 18px;
  }

  label {
    display: block;
    font-size: 12px;
    font-weight: 700;
    letter-spacing: 0.3px;
    color: var(--navy);
    margin-bottom: 7px;
    text-transform: none;
  }

  /* input wrapper with icon */
  .input-wrap {
    position: relative;
  }
  .input-wrap .f-icon {
    position: absolute;
    left: 14px;
    top: 50%;
    transform: translateY(-50%);
    font-size: 15px;
    pointer-events: none;
    opacity: 0.45;
  }
  .input-wrap.textarea-wrap .f-icon {
    top: 16px;
    transform: none;
  }

  input[type="text"],
  input[type="tel"],
  textarea,
  select {
    width: 100%;
    padding: 13px 14px 13px 42px;
    border-radius: 10px;
    border: 1.5px solid var(--border);
    background: var(--white);
    color: var(--text);
    font-family: var(--ff);
    font-size: 14px;
    font-weight: 500;
    transition: all 0.25s var(--ease);
    box-shadow: var(--shadow-sm);
    appearance: none;
    -webkit-appearance: none;
  }
  textarea {
    resize: vertical;
    min-height: 120px;
    padding-top: 13px;
    line-height: 1.65;
  }
  input::placeholder,
  textarea::placeholder {
    color: var(--muted);
    font-weight: 400;
  }
  input:focus,
  textarea:focus,
  select:focus {
    outline: none;
    border-color: var(--blue-mid);
    box-shadow: 0 0 0 3px rgba(37,99,235,0.12);
    background: var(--white);
  }

  /* select arrow */
  .select-wrap {
    position: relative;
  }
  .select-wrap::after {
    content: '▾';
    position: absolute;
    right: 14px;
    top: 50%;
    transform: translateY(-50%);
    color: var(--muted);
    font-size: 14px;
    pointer-events: none;
  }
  select { cursor: pointer; }

  /* 2-col grid for location fields */
  .grid-2 {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 16px;
  }

  /* priority pills */
  .priority-group {
    display: flex;
    gap: 10px;
  }
  .priority-group input[type="radio"] { display: none; }
  .priority-group label {
    flex: 1;
    text-align: center;
    padding: 11px 10px;
    border-radius: 10px;
    border: 1.5px solid var(--border);
    background: var(--white);
    font-size: 13px;
    font-weight: 600;
    color: var(--muted);
    cursor: pointer;
    transition: all 0.25s var(--ease);
    letter-spacing: 0.2px;
    margin: 0;
    text-transform: none;
  }
  .priority-group input[type="radio"]:checked + label {
    border-color: var(--p-color, var(--blue));
    background: var(--p-bg, var(--sky2));
    color: var(--p-color, var(--blue));
    box-shadow: 0 0 0 1px var(--p-color, var(--blue));
  }
  .priority-low   { --p-color:#059669; --p-bg:#d1fae5; }
  .priority-med   { --p-color:#d97706; --p-bg:#fef3c7; }
  .priority-high  { --p-color:#dc2626; --p-bg:#fee2e2; }
  .priority-group label:hover {
    background: var(--sky);
    border-color: var(--blue-light);
    color: var(--navy);
  }

  /* ── SUBMIT BUTTON ── */
  .submit-btn {
    width: 100%;
    margin-top: 32px;
    padding: 15px;
    border: none;
    border-radius: 12px;
    background: var(--navy);
    color: #fff;
    font-family: var(--ff);
    font-size: 15px;
    font-weight: 700;
    cursor: pointer;
    letter-spacing: 0.3px;
    box-shadow: 0 8px 24px rgba(10,31,68,0.22);
    transition: all 0.3s var(--ease);
    position: relative;
    overflow: hidden;
  }
  .submit-btn::before {
    content: '';
    position: absolute; inset: 0;
    background: linear-gradient(135deg, var(--blue-mid), var(--blue-light));
    opacity: 0;
    transition: opacity 0.3s ease;
  }
  .submit-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 14px 36px rgba(10,31,68,0.28);
  }
  .submit-btn:hover::before { opacity: 1; }
  .submit-btn:active { transform: scale(0.99); }
  .submit-btn span { position: relative; z-index: 1; }

  /* back link */
  .back-link {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    margin-top: 20px;
    font-size: 13px;
    font-weight: 600;
    color: var(--muted);
    text-decoration: none;
    cursor: pointer;
    transition: color 0.2s ease;
    background: none;
    border: none;
    padding: 0;
    width: auto;
    box-shadow: none;
  }
  .back-link:hover { color: var(--blue); }

  /* ═══════════════════════════════════════
     ANIMATION
  ═══════════════════════════════════════ */
  @keyframes fadeUp {
    from { opacity:0; transform:translateY(24px); }
    to   { opacity:1; transform:translateY(0); }
  }

  /* ═══════════════════════════════════════
     SCROLLBAR
  ═══════════════════════════════════════ */
  ::-webkit-scrollbar { width:6px; }
  ::-webkit-scrollbar-track { background:var(--offwhite); }
  ::-webkit-scrollbar-thumb { background:var(--border); border-radius:10px; }
  ::-webkit-scrollbar-thumb:hover { background:var(--blue); }

  /* ═══════════════════════════════════════
     RESPONSIVE
  ═══════════════════════════════════════ */
  @media (max-width: 600px) {
    .card-top, .form-body { padding-left: 24px; padding-right: 24px; }
    .grid-2 { grid-template-columns: 1fr; }
    .priority-group { flex-direction: column; }
    .card-top h1 { font-size: 24px; }
  }
  </style>
</head>
<body>

<div class="container">

  <!-- ── Card Top ── -->
  <div class="card-top">
    <div class="cat-badge"><%= catIcon %> &nbsp;<%= category %></div>
    <h1>Raise a Service Request</h1>
    <p>Describe the issue clearly. Accurate details help the concerned department resolve your request faster.</p>
  </div>

  <!-- ── Form Body ── -->
  <div class="form-body">

    <form action="/MyWebApp/submitRequest" method="post">
      <input type="hidden" name="category" value="<%= category %>">

      <!-- Problem Details -->
      <div class="form-section-title">Problem Details</div>

      <div class="field-group">
        <label for="description">Description</label>
        <div class="input-wrap textarea-wrap">
          <span class="f-icon">📝</span>
          <textarea id="description" name="description" rows="5" required
            placeholder="Explain the problem in detail..."></textarea>
        </div>
      </div>

      <!-- Location -->
      <div class="form-section-title">Location Information</div>

      <div class="grid-2">
        <div class="field-group">
          <label for="street">Street Name / No.</label>
          <div class="input-wrap">
            <span class="f-icon">🛣️</span>
            <input type="text" id="street" name="street" placeholder="Street name or number" required>
          </div>
        </div>
        <div class="field-group">
          <label for="houseNo">House / Flat No.</label>
          <div class="input-wrap">
            <span class="f-icon">🏠</span>
            <input type="text" id="houseNo" name="houseNo" placeholder="House or flat number" required>
          </div>
        </div>
      </div>

      <div class="grid-2">
        <div class="field-group">
          <label for="area">Area / Locality</label>
          <div class="input-wrap">
            <span class="f-icon">📍</span>
            <input type="text" id="area" name="area" placeholder="Area or locality" required>
          </div>
        </div>
        <div class="field-group">
          <label for="city">City</label>
          <div class="input-wrap">
            <span class="f-icon">🏙️</span>
            <input type="text" id="city" name="city" placeholder="City" required>
          </div>
        </div>
      </div>

      <!-- Additional Info -->
      <div class="form-section-title">Additional Information</div>

      <div class="field-group">
        <label>Priority Level</label>
        <div class="priority-group">

          <input type="radio" name="priority" id="p-low" value="LOW">
          <label for="p-low" class="priority-low">🟢 Low</label>

          <input type="radio" name="priority" id="p-med" value="MEDIUM" checked>
          <label for="p-med" class="priority-med">🟡 Medium</label>

          <input type="radio" name="priority" id="p-high" value="HIGH">
          <label for="p-high" class="priority-high">🔴 High</label>

        </div>
      </div>

      <div class="field-group">
        <label for="contact">Contact Number</label>
        <div class="input-wrap">
          <span class="f-icon">📞</span>
          <input type="tel" id="contact" name="contact" placeholder="Your contact number" required>
        </div>
      </div>

      <button type="submit" class="submit-btn">
        <span>Submit Request →</span>
      </button>

    </form>

    <button class="back-link" onclick="history.back()">← Back</button>

  </div>
</div>

<jsp:include page="/components/chatbot.jsp" />
</body>
</html>
