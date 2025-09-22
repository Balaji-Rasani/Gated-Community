<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,com.User,com.util.DBConnection,com.util.Constants" %>
<%@ page session="true" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"resident".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/residentlogin.jsp");
        return;
    }

    String message = null;
    String error = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String flatNo = request.getParameter("flatNo");
        String mobileNo = request.getParameter("mobileNo");
        String complaintText = request.getParameter("complaintText");

        if (flatNo == null || flatNo.trim().isEmpty() ||
            mobileNo == null || mobileNo.trim().isEmpty() ||
            complaintText == null || complaintText.trim().isEmpty()) {
            error = "⚠️ All fields are required.";
        } else {
            try (Connection conn = DBConnection.getConnection()) {
                String sql = "INSERT INTO " + Constants.COMPLAINTS_TABLE +
                             " (resident_name, flat_no, mobile_no, complaint_text, status, date_submitted) " +
                             "VALUES (?, ?, ?, ?, 'pending', NOW())";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, user.getUsername());
                    ps.setString(2, flatNo);
                    ps.setString(3, mobileNo);
                    ps.setString(4, complaintText);

                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                        message = "✅ Complaint submitted successfully!";
                    } else {
                        error = "❌ Failed to submit complaint.";
                    }
                }
            } catch (Exception e) {
                error = "❗ Database error: " + e.getMessage();
                e.printStackTrace();
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>📝 Submit Complaint</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f8ff; /* light blueish */
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 520px;
            margin: auto;
            background: white;
            padding: 28px 30px;
            border-radius: 12px;
            border: 3px solid black;   /* ✅ Added black border */
            box-shadow: 0 6px 18px rgba(0,123,255,0.2);
        }
        h2 {
            text-align: center;
            color: #007bff;
            font-weight: 900;
            margin-bottom: 30px;
            letter-spacing: 1.1px;
        }
        label {
            font-weight: 700;
            display: block;
            margin-top: 18px;
            color: #333;
            font-size: 1.1rem;
        }
        input, textarea, button {
            width: 100%;
            padding: 12px 14px;
            margin-top: 6px;
            border-radius: 8px;
            border: 2px solid #007bff;
            font-size: 1rem;
            font-weight: 600;
            color: #222;
            transition: border-color 0.3s ease;
            box-sizing: border-box;
        }
        input:focus, textarea:focus {
            outline: none;
            border-color: #0056b3;
            background-color: #e7f0ff;
        }
        textarea {
            resize: vertical;
            min-height: 110px;
        }
        button {
            background-color: #007bff;
            color: white;
            border: none;
            cursor: pointer;
            margin-top: 28px;
            font-size: 1.2rem;
            font-weight: 900;
            letter-spacing: 0.06em;
            box-shadow: 0 4px 14px rgba(0,123,255,0.4);
            transition: background-color 0.3s ease;
        }
        button:hover {
            background-color: #0056b3;
            box-shadow: 0 6px 18px rgba(0,86,179,0.6);
        }
        .message {
            color: #28a745;
            font-weight: 700;
            text-align: center;
            margin-bottom: 12px;
            font-size: 1.1rem;
        }
        .error {
            color: #dc3545;
            font-weight: 700;
            text-align: center;
            margin-bottom: 12px;
            font-size: 1.1rem;
        }
        a {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #007bff;
            font-weight: 700;
            text-decoration: none;
            font-size: 1rem;
            transition: color 0.3s ease;
        }
        a:hover {
            color: #0056b3;
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>📝 Submit a Complaint</h2>

    <% if (message != null) { %>
        <div class="message"><%= message %></div>
    <% } %>
    <% if (error != null) { %>
        <div class="error"><%= error %></div>
    <% } %>

    <form method="post" novalidate>
        <label for="flatNo">🏠 Flat Number</label>
        <input type="text" name="flatNo" id="flatNo"
               placeholder="e.g., A01"
               value="<%= (user.getFlatNo() != null && !user.getFlatNo().isEmpty()) ? user.getFlatNo() : "" %>">

        <label for="mobileNo">📱 Mobile Number</label>
        <input type="text" name="mobileNo" id="mobileNo"
               placeholder="e.g., 9876543210"
               value="<%= (user.getMobileNo() != null && !user.getMobileNo().isEmpty()) ? user.getMobileNo() : "" %>">

        <label for="complaintText">📝 Complaint Description</label>
        <textarea name="complaintText" id="complaintText" placeholder="Describe your complaint here..."></textarea>

        <button type="submit">🚀 Submit Complaint</button>
    </form>

    <a href="complaintHistory.jsp">📜 View Complaint History</a>
</div>
</body>
</html>
