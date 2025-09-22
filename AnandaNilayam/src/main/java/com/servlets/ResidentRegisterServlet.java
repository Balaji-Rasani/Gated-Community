package com.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.util.Constants;
import com.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ResidentRegister")
public class ResidentRegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmpassword");
        String flatNo = request.getParameter("flat_no");

        if (!password.equals(confirmPassword)) {
            response.sendRedirect(request.getContextPath() + "/residentsignup.jsp?error=PasswordMismatch");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                throw new Exception("Database connection is null");
            }

            String sql = "INSERT INTO " + Constants.RESIDENTS_TABLE +
                         " (full_name, username, password, flat_no) VALUES (?, ?, ?, ?)";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, name);
                ps.setString(2, username);
                ps.setString(3, password);
                ps.setString(4, flatNo);

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    response.sendRedirect(request.getContextPath() + "/residentsignup.jsp?success=true");
                } else {
                    response.sendRedirect(request.getContextPath() + "/residentsignup.jsp?error=InsertFailed");
                }
            }

        } catch (Exception e) {
            System.err.println("Error while registering resident: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/residentsignup.jsp?error=Exception");
        }
    }
}
