<%@ page import="java.util.List" %>
<%@ page import="com.Message" %>
<%@ page import="com.User" %>
<%@ page session="true" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/adminlogin.jsp");
        return;
    }

    List<Message> messages = (List<Message>) request.getAttribute("messages");
    if (messages == null) {
        messages = new java.util.ArrayList<>();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Chat with Resident</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #eef2f3;
        }
        #chatBox {
            border: 1px solid #ccc;
            width: 500px;
            height: 300px;
            overflow-y: scroll;
            padding: 10px;
            margin-bottom: 10px;
            background-color: white;
            border-radius: 8px;
        }
        .message {
            margin: 5px 0;
            padding: 8px 12px;
            border-radius: 15px;
            max-width: 70%;
            display: inline-block;
            clear: both;
        }
        .admin {
            background-color: #d4edda;
            float: right;
            text-align: right;
        }
        .resident {
            background-color: #cce5ff;
            float: left;
            text-align: left;
        }
        .timestamp {
            display: block;
            font-size: 0.75em;
            color: #555;
            margin-top: 4px;
        }
    </style>
</head>
<body>
    <h2>Chat with Resident</h2>
    <div id="chatBox">
        <% for (Message msg : messages) { %>
            <div class="message <%= msg.getSenderRole().equals("admin") ? "admin" : "resident" %>">
                <strong><%= msg.getSenderRole().equals("admin") ? "You" : msg.getSenderUsername() %>:</strong> 
                <%= msg.getContent() %>
                <span class="timestamp"><%= msg.getSentAt() %></span>
            </div>
        <% } %>
    </div>

    <form action="AdminChatSendServlet" method="post">
        <textarea name="message" rows="3" cols="50" placeholder="Type your reply here..." required></textarea><br>
        <button type="submit">Send</button>
    </form>

    <br>
    <a href="admindashboard.jsp">Back to Dashboard</a>

    <script>
        // Auto-scroll to bottom
        var chatBox = document.getElementById("chatBox");
        chatBox.scrollTop = chatBox.scrollHeight;
    </script>
</body>
</html>
