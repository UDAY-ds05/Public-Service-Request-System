<%@ page import="java.sql.*, util.DBConnection" %>

<%
HttpSession sess = request.getSession(false);

if (sess == null || sess.getAttribute("username") == null) {
    return;
}

int requestId = Integer.parseInt(request.getParameter("requestId"));

String status = "PENDING";

try {
    Connection con = DBConnection.getConnection();

    PreparedStatement ps = con.prepareStatement(
        "SELECT status FROM request WHERE request_id=?"
    );
    ps.setInt(1, requestId);

    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        status = rs.getString("status");
    }

    rs.close();
    ps.close();
    con.close();

} catch(Exception e){
    e.printStackTrace();
}
%>

<h2 style="margin-bottom:20px;">📊 Request Progress (ID: <%= requestId %>)</h2>

<div class="category-card">

<!-- FLOW CONTAINER -->
<div class="progress-container">

    <!-- STEP 1 -->
    <div class="step <%= "PENDING".equals(status) || "ASSIGNED".equals(status) || "COMPLETED".equals(status) ? "active" : "" %>">
        <div class="circle">1</div>
        <p>PENDING</p>
    </div>

    <!-- LINE -->
    <div class="line <%= "ASSIGNED".equals(status) || "COMPLETED".equals(status) ? "active" : "" %>"></div>

    <!-- STEP 2 -->
    <div class="step <%= "ASSIGNED".equals(status) || "COMPLETED".equals(status) ? "active" : "" %>">
        <div class="circle">2</div>
        <p>ASSIGNED</p>
    </div>

    <!-- LINE -->
    <div class="line <%= "COMPLETED".equals(status) ? "active" : "" %>"></div>

    <!-- STEP 3 -->
    <div class="step <%= "COMPLETED".equals(status) ? "active" : "" %>">
        <div class="circle">3</div>
        <p>COMPLETED</p>
    </div>

</div>

<br>

<p style="text-align:center; font-weight:bold;">
Current Status: <%= status %>
</p>

<br>

<button onclick="loadProgress()" 
style="padding:10px; background:#6B7280; color:white; border:none; border-radius:6px;">
⬅ Back
</button>

</div>

<style>

/* FLOW UI */

.progress-container{
    display:flex;
    align-items:center;
    justify-content:space-between;
    margin:30px 0;
}

.step{
    text-align:center;
    flex:1;
}

.circle{
    width:40px;
    height:40px;
    border-radius:50%;
    background:#ccc;
    color:white;
    display:flex;
    align-items:center;
    justify-content:center;
    margin:auto;
    font-weight:bold;
}

.step.active .circle{
    background:#2F80ED;
}

.step p{
    margin-top:8px;
    font-size:14px;
}

.line{
    height:4px;
    background:#ccc;
    flex:1;
}

.line.active{
    background:#2F80ED;
}

</style>