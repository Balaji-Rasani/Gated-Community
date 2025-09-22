package com.servlets;

import com.Message;
import com.User;
import com.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/ChatServlet")
public class ChatServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Save new message
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

    // Get all messages
    private List<Message> getAllMessages() throws SQLException, ClassNotFoundException {
        List<Message> messages = new ArrayList<>();
        String sql = "SELECT * FROM chat_messages ORDER BY sent_at ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Message m = new Message();
                m.setId(rs.getInt("id"));
                m.setSenderUsername(rs.getString("sender_username"));
                m.setSenderRole(rs.getString("sender_role"));
                m.setContent(rs.getString("content"));
                m.setSentAt(rs.getTimestamp("sent_at"));
                messages.add(m);
            }
        }
        return messages;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Message> messages = getAllMessages();
            request.setAttribute("messages", messages);
            request.getRequestDispatcher("/chatWithAdmin.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Unable to load chat messages");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Session expired");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "No user in session");
            return;
        }

        String senderUsername = user.getUsername();
        String senderRole = user.getRole();
        String content = request.getParameter("message");

        if (content == null || content.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid message");
            return;
        }

        Message msg = new Message();
        msg.setSenderUsername(senderUsername);
        msg.setSenderRole(senderRole);
        msg.setContent(content.trim());
        msg.setSentAt(new Timestamp(System.currentTimeMillis()));

        try {
            saveMessage(msg);
            // Redirect back to load updated chat
            response.sendRedirect(request.getContextPath() + "/ChatServlet");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Unable to save message");
        }
    }
}
