<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, util.DBConnection" %>

<%
HttpSession sess = request.getSession(false);

if (sess == null || sess.getAttribute("username") == null ||
   !"ADMIN".equalsIgnoreCase((String)sess.getAttribute("role"))) {

    response.sendRedirect(request.getContextPath() + "/loginmodule/html/select_role.html");
    return;
}

String rawUsername = (String) sess.getAttribute("username");
String adminName = rawUsername.toUpperCase();
String role = (String) sess.getAttribute("role");
String sessionId = sess.getId();

int visitCount = 0;
String email = "Not Available";

try {
    Connection con = DBConnection.getConnection();

    PreparedStatement ps = con.prepareStatement(
        "SELECT visit_count, email FROM users WHERE username=?"
    );
    ps.setString(1, rawUsername);

    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        visitCount = rs.getInt("visit_count");
        email = rs.getString("email");
    }

    rs.close();
    ps.close();
    con.close();

} catch (Exception e) {
    e.printStackTrace();
}
%>

<style>
/* 🔥 PROFILE UI MATCHING DASHBOARD */

.profile-container {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
    gap: 18px;
}

.profile-card {
    background: var(--sky);
    border: 1px solid var(--border);
    border-radius: 14px;
    padding: 18px 20px;
    transition: all 0.25s ease;
    position: relative;
}

.profile-card:hover {
    transform: translateY(-4px);
    border-color: var(--blue-mid);
    box-shadow: 0 8px 20px rgba(10,31,68,0.10);
}

.profile-label {
    font-size: 11px;
    font-weight: 700;
    color: var(--muted);
    letter-spacing: 1px;
    text-transform: uppercase;
    margin-bottom: 6px;
}

.profile-value {
    font-size: 16px;
    font-weight: 600;
    color: var(--text);
    word-break: break-all;
}

/* Accent styles */
.profile-card.primary { border-left: 4px solid var(--blue-mid); }
.profile-card.green   { border-left: 4px solid #059669; }
.profile-card.amber   { border-left: 4px solid #d97706; }
.profile-card.purple  { border-left: 4px solid #7c3aed; }
.profile-card.gray    { border-left: 4px solid #6b7280; }

</style>

<!-- 🔥 USE DASHBOARD STRUCTURE -->
<div>

    <h2 style="margin-bottom: 20px; font-weight:700;">👤 Admin Profile</h2>

    <div class="profile-container">

        <div class="profile-card primary">
            <div class="profile-label">Username</div>
            <div class="profile-value"><%= adminName %></div>
        </div>

        <div class="profile-card purple">
            <div class="profile-label">Role</div>
            <div class="profile-value"><%= role %></div>
        </div>

        <div class="profile-card green">
            <div class="profile-label">Email</div>
            <div class="profile-value"><%= email %></div>
        </div>

        <div class="profile-card amber">
            <div class="profile-label">Total Visits</div>
            <div class="profile-value"><%= visitCount %></div>
        </div>

        <div class="profile-card gray">
            <div class="profile-label">Session ID</div>
            <div class="profile-value"><%= sessionId %></div>
        </div>

    </div>

</div>