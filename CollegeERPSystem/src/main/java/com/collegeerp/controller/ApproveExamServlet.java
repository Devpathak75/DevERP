package com.collegeerp.controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

import com.collegeerp.dao.DBConnection;

public class ApproveExamServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;
        ResultSet rs = null;

        try {
            int id = Integer.parseInt(request.getParameter("id"));

            con = DBConnection.getConnection();

            // 🔍 Step 1: Get student_id from exam_form
            ps1 = con.prepareStatement("SELECT student_id FROM exam_form WHERE id=?");
            ps1.setInt(1, id);
            rs = ps1.executeQuery();

            int studentId = 0;
            if (rs.next()) {
                studentId = rs.getInt("student_id");
            } else {
                response.sendRedirect("admin/examApproval.jsp?error=NotFound");
                return;
            }

            // 🔥 Step 2: Update exam_form status
            ps1 = con.prepareStatement(
                "UPDATE exam_form SET status='APPROVED' WHERE id=?"
            );
            ps1.setInt(1, id);
            ps1.executeUpdate();

            // 🔥 Step 3: ALSO update payment status
            ps2 = con.prepareStatement(
                "UPDATE payment SET status='SUCCESS' WHERE student_id=?"
            );
            ps2.setInt(1, studentId);
            ps2.executeUpdate();

            // ✅ Redirect
            response.sendRedirect("admin/examApproval.jsp?success=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin/examApproval.jsp?error=ServerError");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps1 != null) ps1.close(); } catch (Exception ignored) {}
            try { if (ps2 != null) ps2.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }
}