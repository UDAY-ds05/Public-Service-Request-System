package com.example.servlets.registration;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import util.DBConnection;  

//@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fname = request.getParameter("fname");
        String lname = request.getParameter("lname");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String mobile = request.getParameter("mobile");
        String gender = request.getParameter("gender");
        String role = request.getParameter("role");
        String address = request.getParameter("address");
        String password = request.getParameter("password");

        try {
            Connection con = DBConnection.getConnection();

            String sql = "INSERT INTO users (first_name, last_name, username, email, mobile, gender, role, address, password) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, fname);
            ps.setString(2, lname);
            ps.setString(3, username);
            ps.setString(4, email);
            ps.setString(5, mobile);
            ps.setString(6, gender);
            ps.setString(7, role);
            ps.setString(8, address);
            ps.setString(9, password);

            ps.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/loginmodule/html/select_role.html");

//            response.sendRedirect(request.getContextPath() + "/login-module/html/select_role.html");

            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Registration Failed");
        }
    }
}
