<%@ page import="java.sql.*, util.DBConnection" %>

<%
HttpSession sess = request.getSession(false);

if (sess == null || sess.getAttribute("username") == null) {
    return;
}

String username = (String) sess.getAttribute("username");
%>

<h2 style="margin-bottom:20px;">📊 Your Ongoing Requests</h2>

<div class="category-card">

<table style="width:100%; border-collapse:collapse;">

<thead style="background:var(--header-color); color:white;">
<tr>
    <th style="padding:10px;">Request ID</th>
    <th>Category</th>
    <th>Action</th>
</tr>
</thead>

<tbody>

<%
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

boolean hasData = false;

try {
    con = DBConnection.getConnection();

    ps = con.prepareStatement(
        "SELECT request_id, category FROM request WHERE username=? AND status!='COMPLETED'"
    );
    ps.setString(1, username);

    rs = ps.executeQuery();

    while(rs.next()){
        hasData = true;
%>

<tr style="text-align:center; border-bottom:1px solid #ccc;">
    <td><%= rs.getInt("request_id") %></td>
    <td><%= rs.getString("category") %></td>

    <td>
        <button onclick="viewProgress(<%= rs.getInt("request_id") %>)"
            style="padding:6px 12px; background:#2F80ED; color:white; border:none; border-radius:5px;">
            View
        </button>
    </td>
</tr>

<%
    }

    if(!hasData){
%>

<tr>
    <td colspan="3" style="padding:15px; text-align:center;">
        🎉 No active requests
    </td>
</tr>

<%
    }

} catch(Exception e){
    out.println("<tr><td colspan='3'>Error loading data</td></tr>");
}
finally{
    if(rs!=null) rs.close();
    if(ps!=null) ps.close();
    if(con!=null) con.close();
}
%>

</tbody>
</table>
<br>
<button onclick="loadDashboard()" 
style="padding:10px; background:#6B7280; color:white; border:none; border-radius:6px;">
⬅ Back
</button>

</div>