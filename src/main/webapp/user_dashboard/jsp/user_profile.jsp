<%@ page import="java.sql.*, util.DBConnection" %>

<%
HttpSession sess = request.getSession(false);

if (sess == null || sess.getAttribute("username") == null) {
    response.sendRedirect(request.getContextPath() + "/loginmodule/html/select_role.html");
    return;
}

String username    = (String) sess.getAttribute("username");
String displayName = username.toUpperCase();
String sessionId   = sess.getId();

String firstName="", lastName="", email="", mobile="", gender="", address="";
int visitCount = 0;

try {
    Connection        con = DBConnection.getConnection();
    PreparedStatement ps  = con.prepareStatement("SELECT * FROM users WHERE username=?");
    ps.setString(1, username);
    ResultSet rs = ps.executeQuery();
    if (rs.next()) {
        firstName  = rs.getString("first_name");
        lastName   = rs.getString("last_name");
        email      = rs.getString("email");
        mobile     = rs.getString("mobile");
        gender     = rs.getString("gender");
        address    = rs.getString("address");
        visitCount = rs.getInt("visit_count");
    }
    rs.close(); ps.close(); con.close();
} catch (Exception e) { e.printStackTrace(); }
%>

<style>
/* ── Profile styles (scoped, won't clash with dashboard) ── */
.profile-wrap {
  max-width: 720px;
  animation: fadeUp 0.5s var(--ease, cubic-bezier(0.22,1,0.36,1)) both;
}

.profile-header {
  background: var(--white, #fff);
  border: 1px solid var(--border, #d1dff8);
  border-radius: 24px;
  padding: 40px 44px 36px;
  margin-bottom: 20px;
  box-shadow: var(--shadow-md, 0 8px 28px rgba(10,31,68,0.11));
  position: relative;
  overflow: hidden;
}
.profile-header::before {
  content: '';
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 4px;
  background: linear-gradient(90deg, #0a1f44, #1a56db, #3b82f6);
}

.profile-avatar {
  width: 72px; height: 72px;
  border-radius: 18px;
  background: var(--sky2, #dbeafe);
  border: 2px solid var(--border, #d1dff8);
  display: flex; align-items: center; justify-content: center;
  font-size: 30px;
  margin-bottom: 16px;
  box-shadow: 0 4px 16px rgba(10,31,68,0.10);
}

.profile-header h2 {
  font-family: 'Playfair Display', serif;
  font-size: 26px;
  font-weight: 800;
  color: var(--navy, #0a1f44);
  letter-spacing: -0.3px;
  margin-bottom: 4px;
  padding: 0; background: none; border-radius: 0;
  text-shadow: none; text-align: left;
}
.profile-header .profile-sub {
  font-size: 13px;
  font-weight: 400;
  color: var(--muted, #6b7fa8);
}

/* grid of info rows */
.profile-grid {
  background: var(--white, #fff);
  border: 1px solid var(--border, #d1dff8);
  border-radius: 20px;
  overflow: hidden;
  box-shadow: var(--shadow-sm, 0 2px 8px rgba(10,31,68,0.07));
  margin-bottom: 20px;
}

.profile-row {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 16px 28px;
  border-bottom: 1px solid var(--border, #d1dff8);
  transition: background 0.2s ease;
}
.profile-row:last-child { border-bottom: none; }
.profile-row:hover { background: var(--sky, #e8f0fe); }

.profile-row .row-icon {
  width: 36px; height: 36px;
  border-radius: 10px;
  background: var(--sky2, #dbeafe);
  display: flex; align-items: center; justify-content: center;
  font-size: 15px;
  flex-shrink: 0;
}

.profile-row .row-label {
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 1.5px;
  text-transform: uppercase;
  color: var(--muted, #6b7fa8);
  min-width: 110px;
  flex-shrink: 0;
}

.profile-row .row-value {
  font-size: 14px;
  font-weight: 600;
  color: var(--text, #0f1c35);
  word-break: break-all;
}

/* session row — monospace */
.profile-row.session-row .row-value {
  font-family: 'Courier New', monospace;
  font-size: 12px;
  color: var(--muted, #6b7fa8);
  font-weight: 400;
}

/* back button */
.profile-back-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 12px 26px;
  border: none;
  border-radius: 10px;
  background: var(--navy, #0a1f44);
  color: #fff;
  font-family: 'Plus Jakarta Sans', sans-serif;
  font-size: 14px;
  font-weight: 700;
  cursor: pointer;
  letter-spacing: 0.2px;
  box-shadow: 0 6px 20px rgba(10,31,68,0.22);
  transition: all 0.25s cubic-bezier(0.22,1,0.36,1);
  position: relative;
  overflow: hidden;
}
.profile-back-btn::before {
  content: '';
  position: absolute; inset: 0;
  background: linear-gradient(135deg, #1a56db, #3b82f6);
  opacity: 0;
  transition: opacity 0.25s ease;
}
.profile-back-btn:hover { transform: translateY(-2px); box-shadow: 0 12px 30px rgba(10,31,68,0.28); }
.profile-back-btn:hover::before { opacity: 1; }
.profile-back-btn span { position: relative; z-index: 1; }
</style>

<div class="profile-wrap">

  <!-- Header card -->
  <div class="profile-header">
    <div class="profile-avatar">👤</div>
    <h2><%= displayName %></h2>
    <p class="profile-sub">Citizen Account &nbsp;·&nbsp; <%= visitCount %> visit<%= visitCount != 1 ? "s" : "" %></p>
  </div>

  <!-- Info grid -->
  <div class="profile-grid">

    <div class="profile-row">
      <div class="row-icon">🧑</div>
      <span class="row-label">First Name</span>
      <span class="row-value"><%= firstName %></span>
    </div>

    <div class="profile-row">
      <div class="row-icon">🧑</div>
      <span class="row-label">Last Name</span>
      <span class="row-value"><%= lastName %></span>
    </div>

    <div class="profile-row">
      <div class="row-icon">🔖</div>
      <span class="row-label">Username</span>
      <span class="row-value"><%= displayName %></span>
    </div>

    <div class="profile-row">
      <div class="row-icon">📧</div>
      <span class="row-label">Email</span>
      <span class="row-value"><%= email %></span>
    </div>

    <div class="profile-row">
      <div class="row-icon">📱</div>
      <span class="row-label">Mobile</span>
      <span class="row-value"><%= mobile %></span>
    </div>

    <div class="profile-row">
      <div class="row-icon">⚧</div>
      <span class="row-label">Gender</span>
      <span class="row-value"><%= gender %></span>
    </div>

    <div class="profile-row">
      <div class="row-icon">📍</div>
      <span class="row-label">Address</span>
      <span class="row-value"><%= address %></span>
    </div>

    <div class="profile-row">
      <div class="row-icon">📊</div>
      <span class="row-label">Total Visits</span>
      <span class="row-value"><%= visitCount %></span>
    </div>

    <div class="profile-row session-row">
      <div class="row-icon">🔐</div>
      <span class="row-label">Session ID</span>
      <span class="row-value"><%= sessionId %></span>
    </div>

  </div>

  <!-- Back button -->
  <button class="profile-back-btn" onclick="loadDashboard()">
    <span>← Back to Dashboard</span>
  </button>

</div>
