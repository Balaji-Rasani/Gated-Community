<%@ page import="java.util.List" %>
<%@ page import="com.Message" %>
<%@ page import="com.User" %>
<%@ page session="true" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"resident".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/residentlogin.jsp");
        return;
    }

    List<Message> messages = (List<Message>) request.getAttribute("messages");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Chat with Admin</title>
    <style>
        #chatBox {
            border: 1px solid #ccc;
            width: 500px;
            height: 300px;
            overflow-y: scroll;
            padding: 10px;
            margin-bottom: 10px;
            background-color: #f9f9f9;
        }
        .message {
            margin: 5px 0;
        }
        .resident {
            color: blue;
        }
        .admin {
            color: green;
        }
    </style>
</head>
<body>
    <h2>Chat with Admin</h2>
    <div id="chatBox">
        <% if (messages != null && !messages.isEmpty()) {
               for (Message msg : messages) { %>
            <div class="message <%= msg.getSenderRole().equals("resident") ? "resident" : "admin" %>">
                <strong><%= msg.getSenderRole().equals("resident") ? "You" : "Admin" %>:</strong>
                <%= msg.getContent() %>
                <br><small><%= msg.getSentAt() %></small>
            </div>
        <%   }
           } else { %>
            <p>No chat history available.</p>
        <% } %>
    </div>

    <form action="ChatServlet" method="post">
        <textarea name="message" rows="3" cols="50" placeholder="Type your message here..." required></textarea><br>
        <button type="submit">Send</button>
    </form>

    <br>
    <a href="residentdashboard.jsp">Back to Dashboard</a>
</body>
</html>
