package com.servlets;

import com.Message;
import com.User;
import com.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/AdminChatSendServlet")
public class AdminChatSendServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private void saveMessage(Message msg) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO chat_messages (sender_username, sender_role, content, sent_at) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, msg.getSenderUsername());
            ps.setString(2, msg.getSenderRole());
            ps.setString(3, msg.getContent());
            ps.setTimestamp(4, msg.getSentAt());
            ps.executeUpdate();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/adminlogin.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/adminlogin.jsp");
            return;
        }

        String content = request.getParameter("message");
        if (content == null || content.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/adminChat.jsp?error=empty");
            return;
        }

        Message msg = new Message();
        msg.setSenderUsername(user.getUsername());
        msg.setSenderRole("admin");
        msg.setContent(content.trim());
        msg.setSentAt(new Timestamp(System.currentTimeMillis()));

        try {
            saveMessage(msg);
            response.sendRedirect(request.getContextPath() + "/adminChat.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/adminChat.jsp?error=exception");
        }
    }
}
