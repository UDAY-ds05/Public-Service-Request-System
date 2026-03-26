package com.example.servlets.request;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class SubmitRequestServlet extends HttpServlet {

    private static final String URL = "jdbc:mysql://localhost:3306/online_public_service";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "luffy2005";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("loginmodule/html/select_role.html");
            return;
        }

        String username = (String) session.getAttribute("username");

        String category = request.getParameter("category");
        String description = request.getParameter("description");
        String street = request.getParameter("street");
        String houseNo = request.getParameter("houseNo");
        String area = request.getParameter("area");
        String city = request.getParameter("city");
        String priority = request.getParameter("priority");
        String contact = request.getParameter("contact");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection conn = DriverManager.getConnection(URL, DB_USER, DB_PASS);

            String sql = "INSERT INTO request " +
                    "(username, category, description, street, house_no, area, city, priority, contact, status) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, username);
            ps.setString(2, category);
            ps.setString(3, description);
            ps.setString(4, street);
            ps.setString(5, houseNo);
            ps.setString(6, area);
            ps.setString(7, city);
            ps.setString(8, priority);
            ps.setString(9, contact);
            ps.setString(10, "PENDING");

            ps.executeUpdate();

            ps.close();
            conn.close();

            response.sendRedirect("user_dashboard/jsp/user_dashboard.jsp?success=true");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error submitting request.");
        }
    }
}
