<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<%
    // Get the username from request parameter or session
    String userName = request.getParameter("username");
    if(userName == null || userName.isEmpty()) {
        userName = "Guest";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Dashboard</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
        }
        header {
            background-color: #4CAF50;
            color: white;
            padding: 15px 20px;
            text-align: center;
            font-size: 22px;
        }
        nav {
            width: 200px;
            background-color: #333;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            padding-top: 50px;
        }
        nav a {
            display: block;
            color: white;
            padding: 12px 20px;
            text-decoration: none;
        }
        nav a:hover {
            background-color: #575757;
        }
        main {
            margin-left: 200px;
            padding: 20px;
        }
        .welcome-card {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 3px 6px rgba(0,0,0,0.1);
            max-width: 400px;
        }
    </style>
</head>
<body>

<header>
    Online Public Service Request System
</header>

<nav>
    <a href="#">Dashboard</a>
    <a href="#">Profile</a>
    <a href="#">Requests</a>
    <a href="#">Settings</a>
    <a href="#">Logout</a>
</nav>

<main>
    <div class="welcome-card">
        <h2>Hello, <%= userName %>!</h2>
        <p>Welcome to your dashboard. Here you can manage your requests and profile.</p>
    </div>
</main>

</body>
</html>
