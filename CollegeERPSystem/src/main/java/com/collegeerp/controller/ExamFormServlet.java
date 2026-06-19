package com.collegeerp.controller;

import java.io.IOException;
import java.sql.*;
import java.util.*;

import javax.servlet.*;
import javax.servlet.http.*;

import com.collegeerp.dao.DBConnection;

public class ExamFormServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;
        PreparedStatement psCheck = null;
        PreparedStatement psStudent = null;
        PreparedStatement psSub = null;
        ResultSet rsCheck = null;
        ResultSet rsStudent = null;
        ResultSet rsSub = null;

        try {

            HttpSession session = request.getSession();

            Object studentObj = session.getAttribute("studentId");

            if (studentObj == null) {
                response.sendRedirect("login.jsp?msg=Please login first");
                return;
            }

            int studentId = (int) studentObj;

            con = DBConnection.getConnection();

            // 🔥 CHECK EXISTING FORM + STATUS
            psCheck = con.prepareStatement(
                "SELECT status FROM exam_form WHERE student_id=?"
            );
            psCheck.setInt(1, studentId);
            rsCheck = psCheck.executeQuery();

            if (rsCheck.next()) {

                String status = rsCheck.getString("status");

                // 🔥 If still pending → go to status page
                if ("PENDING".equalsIgnoreCase(status)) {
                    response.sendRedirect("student/receipt.jsp");
                    return;
                }

                // 🔥 If approved → also go to status page (or view page)
                if ("APPROVED".equalsIgnoreCase(status)) {
                    response.sendRedirect("student/receipt.jsp");
                    return;
                }
            }

            // 🔹 Get student details
            psStudent = con.prepareStatement(
                "SELECT year, department_id FROM student WHERE id=?"
            );
            psStudent.setInt(1, studentId);
            rsStudent = psStudent.executeQuery();

            int year = 0;
            int deptId = 0;

            if (rsStudent.next()) {
                year = rsStudent.getInt("year");
                deptId = rsStudent.getInt("department_id");
            } else {
                response.getWriter().println("<h3>❌ Student not found</h3>");
                return;
            }

            // 🔹 Convert year → semester
            int semester = 0;
            if (year == 1) semester = 1;
            else if (year == 2) semester = 3;
            else if (year == 3) semester = 5;
            else if (year == 4) semester = 7;

            // 🔹 Fetch subjects
            psSub = con.prepareStatement(
                "SELECT name FROM subject WHERE department_id=? AND semester=?"
            );
            psSub.setInt(1, deptId);
            psSub.setInt(2, semester);

            rsSub = psSub.executeQuery();

            List<String> subjects = new ArrayList<>();

            while (rsSub.next()) {
                subjects.add(rsSub.getString("name"));
            }

            if (subjects.isEmpty()) {
                response.getWriter().println("<h3>❌ No subjects found for your semester</h3>");
                return;
            }

            // 🔹 Send data to JSP
            request.setAttribute("subjects", subjects);
            request.setAttribute("semester", semester);

            // ✅ FIXED PATH
            RequestDispatcher rd = request.getRequestDispatcher("/student/examFormFill.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");
        } finally {
            try { if (rsCheck != null) rsCheck.close(); } catch (Exception ignored) {}
            try { if (rsStudent != null) rsStudent.close(); } catch (Exception ignored) {}
            try { if (rsSub != null) rsSub.close(); } catch (Exception ignored) {}
            try { if (psCheck != null) psCheck.close(); } catch (Exception ignored) {}
            try { if (psStudent != null) psStudent.close(); } catch (Exception ignored) {}
            try { if (psSub != null) psSub.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }
}