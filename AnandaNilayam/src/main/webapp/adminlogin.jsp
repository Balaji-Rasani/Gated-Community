<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Login - Ananda Nilayam</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #ffe0b2, #fff8e1); /* warm peach to cream */
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .login-container {
            background: linear-gradient(135deg, #ffffff, #fff3e0); /* soft white to light peach */
            padding: 40px;
            border-radius: 20px;
            width: 480px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
            position: relative;
            border: 2px solid black; /* ✅ Added black border */
        }

        h2 {
            color: #e65100; /* deep orange heading */
            margin-bottom: 25px;
            font-size: 28px;
            text-align: center;
        }

        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 12px;
            margin: 12px 0;
            border-radius: 10px;
            border: 1px solid black; /* ✅ Changed border to black */
            background-color: #fffaf0;
            font-size: 16px;
        }

        button {
            width: 100%;
            padding: 14px;
            background-color: #ff9800; /* warm orange button */
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
        }

        button:hover {
            background-color: #ef6c00; /* darker orange on hover */
        }

        .error {
            color: red;
            font-weight: bold;
            margin-bottom: 15px;
            text-align: center;
        }

        .signup-link {
            margin-top: 20px;
            font-size: 14px;
            text-align: center;
        }

        .signup-link a {
            color: #ff9800;
            text-decoration: none;
            font-weight: bold;
        }

        .signup-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>🛠️ Admin Login</h2>

        <% 
            String errorParam = request.getParameter("error");
            if ("invalid".equals(errorParam)) {
        %>
            <div class="error">Invalid username or password</div>
        <% 
            } else if ("server".equals(errorParam)) {
        %>
            <div class="error">Server error. Please try again later.</div>
        <% 
            } 
        %>

        <form action="<%=request.getContextPath()%>/AdminLoginServlet" method="post">
            <input type="text" name="username" placeholder="👨‍💼 Enter Admin Username" required><br>
            <input type="password" name="password" placeholder="🔐 Enter Password" required><br>
            <button type="submit">🚪 Login</button>
        </form>

        <div class="signup-link">
            Don’t have an admin account? <a href="adminsignup.jsp">Sign up</a>
        </div>
    </div>
</body>
</html>
