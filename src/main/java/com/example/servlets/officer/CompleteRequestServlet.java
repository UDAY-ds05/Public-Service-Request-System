package com.example.servlets.officer;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.*;

import util.DBConnection;

public class CompleteRequestServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int requestId = Integer.parseInt(request.getParameter("requestId"));

            Connection con = DBConnection.getConnection();

            // 1️⃣ Mark request completed
            String updateSql = "UPDATE request SET status='COMPLETED' WHERE request_id=?";
            PreparedStatement ps1 = con.prepareStatement(updateSql);
            ps1.setInt(1, requestId);
            ps1.executeUpdate();
            ps1.close();

            // 2️⃣ Get username of that request
            String getUser = "SELECT username FROM request WHERE request_id=?";
            PreparedStatement ps2 = con.prepareStatement(getUser);
            ps2.setInt(1, requestId);

            ResultSet rs = ps2.executeQuery();

            String username = null;

            if(rs.next()){
                username = rs.getString("username");
            }

            rs.close();
            ps2.close();

            // 3️⃣ Insert payment entry
            String paymentSql =
            "INSERT INTO payments(username, request_id, amount, payment_status) VALUES(?,?,?,?)";

            PreparedStatement ps3 = con.prepareStatement(paymentSql);

            ps3.setString(1, username);
            ps3.setInt(2, requestId);
            ps3.setDouble(3, 500);   // example service charge
            ps3.setString(4, "PENDING");

            ps3.executeUpdate();

            ps3.close();
            con.close();

            response.sendRedirect(
                request.getContextPath() + "/officer_dashboard/jsp/officer_dashboard.jsp?page=requests"
            );

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error updating request");
        }
    }
}