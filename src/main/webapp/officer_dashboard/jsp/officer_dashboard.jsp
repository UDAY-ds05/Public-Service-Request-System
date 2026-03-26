<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, util.DBConnection" %>
<%
HttpSession sess = request.getSession(false);

if (sess == null || sess.getAttribute("username") == null ||
   !"OFFICER".equalsIgnoreCase((String)sess.getAttribute("role"))) {

    response.sendRedirect(request.getContextPath() + "/loginmodule/html/select_role.html");
    return;
}

String officerName = ((String)sess.getAttribute("username")).toUpperCase();

String theme = "light";
Cookie[] cookies = request.getCookies();

if (cookies != null) {
    for (Cookie c : cookies) {
        if ("theme".equals(c.getName())) {
            theme = c.getValue();
        }
    }
}

String pageName = request.getParameter("page");
if(pageName == null) pageName = "requests";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Officer Dashboard</title>

<style>

*{
margin:0;
padding:0;
box-sizing:border-box;
font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif;
}

:root{
--bg-color:#f4f6f8;
--text-color:#111827;
--header-color:#2F80ED;
--sidebar-color:#1F2937;
--card-bg:white;
--card-hover:#f3f4f6;
}

body.dark{
--bg-color:#121212;
--text-color:#f1f1f1;
--header-color:#1e3a8a;
--sidebar-color:#111827;
--card-bg:#1f2937;
--card-hover:#2c2c2c;
}

body{
background-color:var(--bg-color);
color:var(--text-color);
transition:0.3s;
}

header{
background-color:var(--header-color);
color:white;
text-align:center;
padding:20px 0;
font-size:24px;
font-weight:bold;
box-shadow:0 2px 6px rgba(0,0,0,0.2);
}

nav{
width:220px;
background-color:var(--sidebar-color);
height:100vh;
position:fixed;
top:0;
left:0;
padding-top:80px;
display:flex;
flex-direction:column;
}

nav a{
color:white;
text-decoration:none;
padding:15px 25px;
margin:5px 0;
border-radius:5px;
transition:0.3s;
font-weight:500;
}

nav a:hover{
background-color:#2563EB;
transform:translateX(5px);
}

main{
margin-left:220px;
padding:30px;
}

.card{
background:var(--card-bg);
padding:20px;
border-radius:10px;
box-shadow:0 4px 8px rgba(0,0,0,0.1);
}

table{
width:100%;
border-collapse:collapse;
margin-top:20px;
background:var(--card-bg);
}

th,td{
padding:10px;
border:1px solid #ddd;
text-align:center;
}

button{
padding:8px 14px;
border-radius:6px;
border:none;
background-color:#007bff;
color:white;
cursor:pointer;
transition:0.3s;
}

button:hover{
background-color:#0056b3;
}

</style>
</head>

<body class="<%= "dark".equals(theme) ? "dark" : "" %>">

<header>
OFFICER DASHBOARD
</header>

<nav>

<a href="officer_dashboard.jsp?page=requests">Assigned Requests</a>

<a href="officer_dashboard.jsp?page=completed">Completed Requests</a>

<a href="#" id="themeToggle">Toggle Theme</a>

<a href="<%= request.getContextPath() %>/LogoutServlet">Logout</a>

</nav>

<main>

<h2>Welcome, <%= officerName %> 👮</h2>
<br>

<%
if("requests".equals(pageName)){
%>

<div class="card">

<h3>Assigned Requests</h3>

<div class="card">

<h3>Assigned Requests</h3>

<table>

<tr>
<th>ID</th>
<th>User</th>
<th>Category</th>
<th>Description</th>
<th>Location</th>
<th>Priority</th>
<th>Contact</th>
<th>Status</th>
<th>Action</th>
</tr>

<%

Connection con = DBConnection.getConnection();

PreparedStatement ps = con.prepareStatement(
"SELECT * FROM request WHERE allocated_officer=? AND status='ASSIGNED' ORDER BY created_at DESC"
);

ps.setInt(1, (Integer)sess.getAttribute("userId"));

ResultSet rs = ps.executeQuery();

while(rs.next()){

%>

<tr>

<td><%= rs.getInt("request_id") %></td>

<td><%= rs.getString("username") %></td>

<td><%= rs.getString("category") %></td>

<td><%= rs.getString("description") %></td>

<td>
<%= rs.getString("house_no") %>,
<%= rs.getString("street") %>,
<%= rs.getString("area") %>
</td>

<td><%= rs.getString("priority") %></td>

<td><%= rs.getString("contact") %></td>

<td><%= rs.getString("status") %></td>

<td>

<form action="<%= request.getContextPath() %>/CompleteRequestServlet" method="post">

<input type="hidden" name="requestId" value="<%= rs.getInt("request_id") %>">

<button>Mark Completed</button>

</form>

</td>

</tr>

<%
}
%>

</table>

</div>

<%
}

else if("completed".equals(pageName)){
%>

<div class="card">

<h3>Completed Requests</h3>

<p>Completed requests will appear here.</p>

</div>

<%
}
%>

</main>

<script>

document.getElementById("themeToggle").addEventListener("click", function(e) {

e.preventDefault();

const body = document.body;

body.classList.toggle("dark");

let newTheme = body.classList.contains("dark") ? "dark" : "light";

document.cookie = "theme=" + newTheme +
"; path=<%= request.getContextPath() %>; max-age=" + (60*60*24*30);

});

</script>

</body>
</html>