package com.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.Message;
import com.User;
import com.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminChatServlet")
public class AdminChatServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private List<Message> getAllMessages() throws SQLException, ClassNotFoundException {
        List<Message> messages = new ArrayList<>();
        String sql = "SELECT id, sender_username, sender_role, content, sent_at " +
                     "FROM chat_messages ORDER BY sent_at ASC";

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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check login and role
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/adminlogin.jsp");
            return;
        }
        User user = (User) session.getAttribute("user");
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/adminlogin.jsp");
            return;
        }

        try {
            List<Message> messages = getAllMessages();
            request.setAttribute("messages", messages);
            request.getRequestDispatcher("/adminChat.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unable to load chat messages.");
            request.getRequestDispatcher("/adminChat.jsp").forward(request, response);
        }
    }
}
