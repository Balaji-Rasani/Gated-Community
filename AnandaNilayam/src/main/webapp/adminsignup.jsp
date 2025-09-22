<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Signup - Ananda Nilayam</title>
<style>
    body {
        font-family: 'Segoe UI', sans-serif;
        background-color: #e3f2fd; /* Light blue background */
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        margin: 0;
    }
    .signup-container {
        background: white;
        padding: 40px 50px;
        border-radius: 15px;
        box-shadow: 0 6px 15px rgba(0, 0, 0, 0.2);
        width: 500px;

        /* ✅ Black border added */
        border: 3px solid black;
    }
    h2 {
        color: #0277bd; /* Blue heading */
        margin-bottom: 30px;
        font-size: 28px;
        text-align: center;
    }
    .form-row {
        display: flex;
        align-items: center;
        margin-bottom: 15px;
    }
    .form-row label {
        width: 150px;
        font-weight: bold;
        color: black;
    }
    .form-row input {
        flex: 1;
        padding: 10px;
        border-radius: 8px;
        border: 1px solid #90caf9; /* Light blue border */
        font-size: 16px;
        background-color: #f0f8ff; /* Very light blue input background */
    }
    button {
        width: 100%;
        padding: 12px;
        background-color: #0277bd; /* Blue button */
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 16px;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }
    button:hover {
        background-color: #01579b; /* Darker blue on hover */
    }
    .login-link {
        text-align: center;
        margin-top: 20px;
        font-size: 14px;
    }
    .login-link a {
        color: #0277bd;
        text-decoration: none;
        font-weight: bold;
    }
    .login-link a:hover {
        text-decoration: underline;
    }
</style>
</head>
<body>
<div class="signup-container">
    <h2>📝 Admin Signup</h2>

    <form action="<%=request.getContextPath()%>/AdminRegisterServlet" method="post">
        <div class="form-row">
            <label>Full Name:</label>
            <input type="text" name="name" placeholder="👤 Full Name" required>
        </div>
        <div class="form-row">
            <label>Email:</label>
            <input type="email" name="email" placeholder="📧 Email Address" required>
        </div>
        <div class="form-row">
            <label>Username:</label>
            <input type="text" name="username" placeholder="🔑 Username" required>
        </div>
        <div class="form-row">
            <label>Password:</label>
            <input type="password" name="password" placeholder="🔒 Password" required>
        </div>
        <div class="form-row">
            <label>Confirm:</label>
            <input type="password" name="confirmpassword" placeholder="🔒 Confirm Password" required>
        </div>
        <button type="submit">📝 Sign Up</button>
    </form>

    <div class="login-link">
        Already have an account? <a href="adminlogin.jsp">Login</a>
    </div>
</div>

<%
    String success = request.getParameter("success");
    if ("true".equals(success)) {
%>
<script>
    alert('✅ Admin Signup Successful! Redirecting to login page...');
    window.location.href = 'adminlogin.jsp';
</script>
<%
    }
%>

</body>
</html>
