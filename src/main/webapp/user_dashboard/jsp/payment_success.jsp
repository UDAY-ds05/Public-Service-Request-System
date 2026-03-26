<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Payment Success</title>

<style>

body{
    font-family:'Segoe UI', sans-serif;
    background:#f4f6f8;
    display:flex;
    justify-content:center;
    align-items:center;
    height:100vh;
}

/* Card */

.success-card{
    background:white;
    padding:40px;
    border-radius:12px;
    text-align:center;
    box-shadow:0 10px 25px rgba(0,0,0,0.2);
}

/* Icon */

.success-icon{
    font-size:60px;
    color:#22c55e;
    margin-bottom:20px;
}

/* Button */

.btn{
    margin-top:20px;
    padding:10px 18px;
    background:#2F80ED;
    color:white;
    border:none;
    border-radius:6px;
    cursor:pointer;
    transition:0.3s;
}

.btn:hover{
    background:#2563EB;
}

</style>

</head>

<body>

<div class="success-card">

    <div class="success-icon">✔</div>

    <h2>Payment Successful!</h2>

    <p>Your payment has been processed successfully.</p>

    <button class="btn" onclick="goToDashboard()">Go to Dashboard</button>

</div>

<script>
function goToDashboard(){
    window.location.href = "user_dashboard.jsp";
}
</script>

</body>
</html>