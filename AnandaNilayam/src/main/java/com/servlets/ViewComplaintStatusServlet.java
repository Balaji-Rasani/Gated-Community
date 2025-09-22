package com.servlets;

import com.Complaint;
import com.User;
import com.dao.ComplaintDAO;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/ViewComplaintStatusServlet")
public class ViewComplaintStatusServlet extends HttpServlet {
    private ComplaintDAO complaintDAO = new ComplaintDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/residentlogin.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user == null || !"resident".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/residentlogin.jsp");
            return;
        }

        try {
            List<Complaint> complaints = complaintDAO.getComplaintsByResidentName(user.getUsername());
            request.setAttribute("complaints", complaints);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Unable to load complaints.");
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/ViewComplaintStatus.jsp");
        dispatcher.forward(request, response);
    }
}
