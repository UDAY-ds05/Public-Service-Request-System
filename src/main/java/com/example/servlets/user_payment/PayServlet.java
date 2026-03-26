package com.example.servlets.user_payment;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.http.*;

import util.DBConnection;

public class PayServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String paymentIdStr = request.getParameter("paymentId");
        if (paymentIdStr == null || paymentIdStr.isEmpty()) {
            response.getWriter().println("Invalid Payment ID");
            return;
        }
        int paymentId = Integer.parseInt(paymentIdStr);
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "UPDATE payments SET payment_status='PAID' WHERE payment_id=?"
            );

            ps.setInt(1, paymentId);
            ps.executeUpdate();

            ps.close();
            con.close();
            response.sendRedirect(request.getContextPath() + "/user_dashboard/jsp/payment_success.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}