<%@ page import="java.sql.*, util.DBConnection" %>

<div class="card">
<h3>Allocate Officers</h3>
<br>

<table border="1" width="100%" cellpadding="10" style="border-collapse:collapse;">
<tr>
    <th>Request ID</th>
    <th>Category</th>
    <th>Citizen</th>
    <th>Status</th>
    <th>Assign Officer</th>
    <th>Action</th>
</tr>
<%
Connection con = null;

try {
    con = DBConnection.getConnection();
    PreparedStatement ps = con.prepareStatement(
        "SELECT request_id, category, username, status FROM request where status = 'PENDING'"
    );

    ResultSet rs = ps.executeQuery();

    while(rs.next()){
%>
<tr>
    <td><%= rs.getInt("request_id") %></td>
    <td><%= rs.getString("category") %></td>
    <td><%= rs.getString("username") %></td>
    <td><%= rs.getString("status") %></td>

    <td>
        <form action="<%= request.getContextPath() %>/AllocateOfficerServlet" method="post">
            <input type="hidden" name="requestId" value="<%= rs.getInt("request_id") %>">

            <select name="officerId" required>
                <option value="">-- Select Officer --</option>

                <%
                    PreparedStatement ps2 = con.prepareStatement(
                        "SELECT user_id, username FROM users WHERE role='OFFICER'"
                    );
                    ResultSet rs2 = ps2.executeQuery();

                    while(rs2.next()){
                %>
                    <option value="<%= rs2.getInt("user_id") %>">
                        <%= rs2.getString("username") %>
                    </option>
                <%
                    }
                    rs2.close();
                    ps2.close();
                %>
            </select>
    </td>

    <td>
            <button type="submit">Assign</button>
        </form>
    </td>
</tr>

<%
    }
    rs.close();
    ps.close();

} catch(Exception e){
    e.printStackTrace();
}
%>
</table>
</div>
