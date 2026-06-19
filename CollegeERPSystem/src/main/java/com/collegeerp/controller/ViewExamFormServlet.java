package com.collegeerp.controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

import com.collegeerp.dao.DBConnection;

public class ViewExamFormServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            // 🔥 GET SESSION (NOT PARAMETER)
            HttpSession session = request.getSession(false);

            if (session == null || session.getAttribute("studentId") == null) {
                response.sendRedirect("login.jsp?error=sessionExpired");
                return;
            }

            int studentId = (int) session.getAttribute("studentId");

            con = DBConnection.getConnection();

            // 🔥 CORRECT JOIN QUERY
            ps = con.prepareStatement(
                "SELECT s.name, s.enrollment, d.name AS dept, ef.semester, ef.subjects, ef.amount, ef.payment_id, ef.status, ef.date " +
                "FROM student s " +
                "JOIN exam_form ef ON s.id = ef.student_id " +
                "JOIN department d ON s.department_id = d.id " +
                "WHERE s.id=?"
            );

            ps.setInt(1, studentId);

            rs = ps.executeQuery();

            if (rs.next()) {

                // ✅ PASS DATA (NOT RESULTSET)
                request.setAttribute("name", rs.getString("name"));
                request.setAttribute("enrollment", rs.getString("enrollment"));
                request.setAttribute("dept", rs.getString("dept"));
                request.setAttribute("semester", rs.getInt("semester"));
                request.setAttribute("subjects", rs.getString("subjects"));
                request.setAttribute("amount", rs.getInt("amount"));
                request.setAttribute("payment_id", rs.getString("payment_id"));
                request.setAttribute("status", rs.getString("status"));
                request.setAttribute("date", rs.getString("date"));

                // 🔥 CORRECT PATH
                RequestDispatcher rd = request.getRequestDispatcher("/student/examFormView.jsp");
                rd.forward(request, response);

            } else {
                response.sendRedirect("student/examStatus.jsp?error=NoForm");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }
}