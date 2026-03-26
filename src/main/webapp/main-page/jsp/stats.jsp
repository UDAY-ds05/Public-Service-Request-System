<%@ page import="java.sql.*, util.DBConnection" %>
<%
    response.setContentType("text/xml");
    response.setHeader("Cache-Control", "no-cache");
    Connection conn = null;
    PreparedStatement ps;
    ResultSet rs;
    int citizens = 0;
    int officers = 0;
    int requests = 0;
    int resolved = 0;
    try {
        conn = DBConnection.getConnection();
        ps = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE role = ?");
        ps.setString(1, "Citizen");
        rs = ps.executeQuery();
        if(rs.next()) citizens = rs.getInt(1);
        ps = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE role = ?");
        ps.setString(1, "Officer");
        rs = ps.executeQuery();
        if(rs.next()) officers = rs.getInt(1);
        ps = conn.prepareStatement("SELECT COUNT(*) FROM request");
        rs = ps.executeQuery();
        if(rs.next()) requests = rs.getInt(1);
        ps = conn.prepareStatement("SELECT COUNT(*) FROM request WHERE status = ?");
        ps.setString(1, "Completed");
        rs = ps.executeQuery();
        if(rs.next()) resolved = rs.getInt(1);
    } catch(Exception e) {
        e.printStackTrace();
    }
%>

<stats>
    <citizens><%= citizens %></citizens>
    <officers><%= officers %></officers>
    <requests><%= requests %></requests>
    <resolved><%= resolved %></resolved>
</stats>