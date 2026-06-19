package com.collegeerp.controller;

import java.io.IOException;
import java.sql.*;

import javax.servlet.*;
import javax.servlet.http.*;

import com.collegeerp.dao.DBConnection;

public class PaymentSuccessServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String paymentId = request.getParameter("payment_id");

            HttpSession session = request.getSession();
            int studentId = (int) session.getAttribute("studentId");
            String subjects = (String) session.getAttribute("subjects");
            int semester = Integer.parseInt((String) session.getAttribute("semester"));

            Connection con = DBConnection.getConnection();

            // Save exam form
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO exam_form(student_id, semester, subjects, amount, payment_id, status) VALUES (?,?,?,?,?,?)"
            );
            ps.setInt(1, studentId);
            ps.setInt(2, semester);
            ps.setString(3, subjects);
            ps.setInt(4, 150);
            ps.setString(5, paymentId);
            ps.setString(6, "PAID");
            ps.executeUpdate();

            // Save payment history
            PreparedStatement ps2 = con.prepareStatement(
                "INSERT INTO payment_history(student_id, amount, payment_id, status) VALUES (?,?,?,?)"
            );
            ps2.setInt(1, studentId);
            ps2.setInt(2, 150);
            ps2.setString(3, paymentId);
            ps2.setString(4, "SUCCESS");
            ps2.executeUpdate();

            response.sendRedirect("student/dashboard.jsp?msg=Payment Successful");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}