package com.collegeerp.controller;

import java.io.IOException;
import java.sql.*;

import javax.servlet.*;
import javax.servlet.http.*;

import com.collegeerp.dao.DBConnection;

public class SubmitExamFormServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");

        Connection con = null;
        PreparedStatement check = null;
        PreparedStatement ps = null;
        PreparedStatement ps2 = null;
        ResultSet rs = null;

        try {

            System.out.println("👉 SubmitExamFormServlet called");

            HttpSession session = request.getSession(false);

            // 🔴 SESSION CHECK
            if (session == null || session.getAttribute("studentId") == null) {
                response.sendRedirect("login.jsp?error=sessionExpired");
                return;
            }

            int studentId = (int) session.getAttribute("studentId");

            // 🔹 GET FORM DATA
            String[] subjectsArr = request.getParameterValues("subjects");
            String semesterStr = request.getParameter("semester");
            String txnId = request.getParameter("txn_id");

            // 🔴 VALIDATION
            if (subjectsArr == null || semesterStr == null || txnId == null || txnId.trim().isEmpty()) {
                response.getWriter().println("<h3>❌ Invalid form submission</h3>");
                return;
            }

            String subjects = String.join(", ", subjectsArr);
            int semester = Integer.parseInt(semesterStr);

            System.out.println("Student ID: " + studentId);
            System.out.println("Subjects: " + subjects);
            System.out.println("Semester: " + semester);
            System.out.println("Transaction ID: " + txnId);

            con = DBConnection.getConnection();

            // 🔹 CHECK DUPLICATE
            check = con.prepareStatement(
                "SELECT id FROM exam_form WHERE student_id=?"
            );
            check.setInt(1, studentId);
            rs = check.executeQuery();

            if (rs.next()) {
                response.sendRedirect("student/examStatus.jsp?msg=AlreadySubmitted");
                return;
            }

            // 🔹 INSERT EXAM FORM
            ps = con.prepareStatement(
                "INSERT INTO exam_form(student_id, semester, subjects, amount, payment_id, status) VALUES (?,?,?,?,?,?)"
            );

            ps.setInt(1, studentId);
            ps.setInt(2, semester);
            ps.setString(3, subjects);
            ps.setInt(4, 150);
            ps.setString(5, txnId);
            ps.setString(6, "PENDING");

            ps.executeUpdate();

            // 🔹 INSERT PAYMENT HISTORY
            ps2 = con.prepareStatement(
                "INSERT INTO payment_history(student_id, amount, payment_id, status) VALUES (?,?,?,?)"
            );

            ps2.setInt(1, studentId);
            ps2.setInt(2, 150);
            ps2.setString(3, txnId);
            ps2.setString(4, "PENDING");

            ps2.executeUpdate();

            // 🔥 IMPORTANT CHANGE
            // 👉 Direct to PROFESSIONAL RECEIPT PAGE
            response.sendRedirect("student/receipt.jsp");

        } catch (Exception e) {

            e.printStackTrace();
            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");

        } finally {

            // 🔥 CLOSE ALL
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (check != null) check.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (ps2 != null) ps2.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }
}