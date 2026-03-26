package com.example.servlets.admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import util.DBConnection;


public class AllocateOfficerServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int requestId = Integer.parseInt(request.getParameter("requestId"));
        int officerId = Integer.parseInt(request.getParameter("officerId"));

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "UPDATE request SET allocated_officer=?, status='ASSIGNED' WHERE request_id=?"
            );

            ps.setInt(1, officerId);
            ps.setInt(2, requestId);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect(
                request.getContextPath() + "/admin_dashboard/jsp/admin_dashboard.jsp?page=allocate"
            );

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
