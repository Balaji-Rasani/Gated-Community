<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Resident Signup - Ananda Nilayam</title>
<style>
    body {
        font-family: 'Segoe UI', sans-serif;
        background-color: #f1f8e9;
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

        /* ✅ Added black border */
        border: 3px solid black;
    }
    h2 {
        color: #2e7d32;
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
        border: 1px solid #ccc;
        font-size: 16px;
        background-color: #f9fbe7;
    }
    button {
        width: 100%;
        padding: 12px;
        background-color: #2e7d32;
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 16px;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }
    button:hover {
        background-color: #1b5e20;
    }
    .login-link {
        text-align: center;
        margin-top: 20px;
        font-size: 14px;
    }
    .login-link a {
        color: #2e7d32;
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
    <h2>🏡 Resident Signup</h2>

    <% 
       String success = request.getParameter("success");
       if ("true".equals(success)) { 
    %>
        <script>
            alert("✅ Resident registered successfully!");
        </script>
    <% 
       } else if ("PasswordMismatch".equals(request.getParameter("error"))) {
    %>
        <script>
            alert("❌ Passwords do not match");
        </script>
    <% 
       } else if ("InsertFailed".equals(request.getParameter("error"))) {
    %>
        <script>
            alert("❌ Could not register. Please try again.");
        </script>
    <% 
       } else if ("Exception".equals(request.getParameter("error"))) {
    %>
        <script>
            alert("⚠ An unexpected error occurred.");
        </script>
    <% 
       } 
    %>

    <form action="<%=request.getContextPath()%>/ResidentRegister" method="post">
        <div class="form-row">
            <label>Full Name:</label>
            <input type="text" name="name" placeholder="👤 Full Name" required>
        </div>
        <div class="form-row">
            <label>User Name/Email:</label>
            <input type="text" name="username" placeholder="📧 Username / Email" required>
        </div>
        <div class="form-row">
            <label>Password:</label>
            <input type="password" name="password" placeholder="🔒 Password" required>
        </div>
        <div class="form-row">
            <label>Confirm Password:</label>
            <input type="password" name="confirmpassword" placeholder="🔒 Confirm Password" required>
        </div>
        <div class="form-row">
            <label>Flat No:</label>
            <input type="text" name="flat_no" placeholder="🏢 Flat Number" required>
        </div>
        <button type="submit">📝 Sign Up</button>
    </form>

    <div class="login-link">
        Already have an account? <a href="residentlogin.jsp">Login</a>
    </div>
</div>
</body>
</html>
