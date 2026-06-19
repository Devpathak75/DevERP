package com.collegeerp.controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.collegeerp.dao.DBConnection;

@WebServlet("/studentLogin")
public class StudentLoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM student WHERE email=? AND password=?");

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();

                session.setAttribute("studentId", rs.getInt("id"));
                session.setAttribute("departmentId", rs.getInt("department_id")); // 🔥 VERY IMPORTANT
                session.setAttribute("role", "student");

                response.sendRedirect("student/dashboard.jsp");
            }
else {
                response.sendRedirect("login.jsp?error=student");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
