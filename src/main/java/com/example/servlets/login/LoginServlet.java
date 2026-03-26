package com.example.servlets.login;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import util.DBConnection;
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String loginType = request.getParameter("loginType"); 
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT user_id, username, role FROM users WHERE username=? AND password=?";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                String dbRole = rs.getString("role");

                if (!dbRole.equalsIgnoreCase(loginType)) {
                    response.sendRedirect(
                        request.getContextPath() + "/loginmodule/html/select_role.html?error=role"
                    );
                    return;
                }

                HttpSession session = request.getSession();

                session.setAttribute("userId", rs.getInt("user_id"));        
                session.setAttribute("username", rs.getString("username"));
                session.setAttribute("role", dbRole);
                switch (dbRole.toUpperCase()) {
                    case "ADMIN":
                        response.sendRedirect(
                            request.getContextPath() + "/admin_dashboard/jsp/admin_dashboard.jsp"
                        );
                        break;
                    case "OFFICER":
                        response.sendRedirect(
                            request.getContextPath() + "/officer_dashboard/jsp/officer_dashboard.jsp"
                        );
                        break;
                    case "CITIZEN":
                        response.sendRedirect(
                            request.getContextPath() + "/user_dashboard/jsp/user_dashboard.jsp"
                        );
                        break;
                    default:
                        response.sendRedirect(
                            request.getContextPath() + "/loginmodule/html/select_role.html"
                        );
                }
            } else {
                response.sendRedirect(
                    request.getContextPath() + "/loginmodule/html/select_role.html?error=invalid"
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Login Error");
        }
    }
}
