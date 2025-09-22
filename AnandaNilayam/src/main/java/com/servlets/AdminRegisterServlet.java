package com.servlets;

import com.dao.AdminDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/AdminRegisterServlet")
public class AdminRegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmpassword");

        // Password match check
        if (!password.equals(confirmPassword)) {
            response.sendRedirect("adminsignup.jsp?success=false&error=password_mismatch");
            return;
        }

        AdminDAO adminDAO = new AdminDAO();
        try {
            boolean isRegistered = adminDAO.registerAdmin(name, email, username, password);

            if (isRegistered) {
                response.sendRedirect("adminsignup.jsp?success=true");
            } else {
                response.sendRedirect("adminsignup.jsp?success=false&error=duplicate");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminsignup.jsp?success=false&error=database");
        }
    }
}
