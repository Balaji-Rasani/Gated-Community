<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Resident Login - Ananda Nilayam</title>
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
        .login-container {
            background: white;
            padding: 40px 50px;
            border-radius: 15px;
            border: 2px solid black; /* Black border for box */
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.2);
            text-align: center;
            width: 450px;
        }
        h2 {
            color: #2e7d32;
            margin-bottom: 30px;
            font-size: 28px;
        }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            border-radius: 8px;
            border: 1px solid black; /* Black border for inputs */
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
        .signup-link {
            margin-top: 20px;
            font-size: 14px;
        }
        .signup-link a {
            color: #2e7d32;
            text-decoration: none;
            font-weight: bold;
        }
        .signup-link a:hover {
            text-decoration: underline;
        }
        .error-message {
            color: red;
            font-weight: bold;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>🏠 Resident Login</h2>

        <% 
           String error = request.getParameter("error");
           if ("invalid".equals(error)) { 
        %>
            <div class="error-message">❌ Invalid username or password.</div>
        <% 
           } else if ("Exception".equals(error)) { 
        %>
            <div class="error-message">⚠ An error occurred. Please try again later.</div>
        <% } %>

        <form action="<%=request.getContextPath()%>/ResidentLoginServlet" method="post">
            <input type="text" name="username" placeholder="👤 Username" required />
            <input type="password" name="password" placeholder="🔑 Password" required />
            <button type="submit">➡️ Login</button>
        </form>

        <div class="signup-link">
            Don't have an account? <a href="residentsignup.jsp">Sign up</a>
        </div>
    </div>
</body>
</html>
