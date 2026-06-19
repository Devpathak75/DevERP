package com.collegeerp.controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

import com.collegeerp.dao.DBConnection;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

public class DownloadReceiptServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            HttpSession session = request.getSession(false);

            if (session == null || session.getAttribute("studentId") == null) {
                response.sendRedirect("login.jsp?error=sessionExpired");
                return;
            }

            int studentId = (int) session.getAttribute("studentId");

            con = DBConnection.getConnection();

            // 🔥 FIXED QUERY (IMPORTANT)
            ps = con.prepareStatement(
                "SELECT s.name, s.enrollment, s.email, ef.amount, ef.payment_id, ef.status, ef.date " +
                "FROM exam_form ef " +
                "JOIN student s ON ef.student_id = s.id " +
                "WHERE ef.student_id=? ORDER BY ef.id DESC LIMIT 1"
            );

            ps.setInt(1, studentId);
            rs = ps.executeQuery();

            if (rs.next()) {

                String name = rs.getString("name");
                String enrollment = rs.getString("enrollment");
                String email = rs.getString("email");
                int amount = rs.getInt("amount");
                String txn = rs.getString("payment_id");
                String status = rs.getString("status");
                String date = rs.getString("date");

                // 🔥 ONLY ALLOW DOWNLOAD IF APPROVED
                if (!"APPROVED".equalsIgnoreCase(status)) {
                    response.getWriter().println("<h3>❌ Receipt not available until approved</h3>");
                    return;
                }

                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", "attachment; filename=Receipt.pdf");

                Document doc = new Document();
                PdfWriter.getInstance(doc, response.getOutputStream());

                doc.open();

                // 🔥 TITLE
                Font titleFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD);
                Paragraph title = new Paragraph("Dev Institute of Technology & Engineering", titleFont);
                title.setAlignment(Element.ALIGN_CENTER);
                doc.add(title);

                doc.add(new Paragraph("Fees Challan Cum Receipt\n\n"));

                // 🔥 DETAILS
                doc.add(new Paragraph("Name: " + name));
                doc.add(new Paragraph("Enrollment: " + enrollment));
                doc.add(new Paragraph("Email: " + email));
                doc.add(new Paragraph("Date: " + date));
                doc.add(new Paragraph(" "));

                doc.add(new Paragraph("Transaction ID: " + txn));
                doc.add(new Paragraph("Amount: ₹ " + amount));
                doc.add(new Paragraph("Status: " + status));

                doc.add(new Paragraph("\nMode: Online Payment"));
                doc.add(new Paragraph("Amount in Words: Rupees One Hundred Fifty Only"));

                doc.add(new Paragraph("\n\nThis is a computer generated receipt."));

                doc.close();
            } else {
                response.getWriter().println("<h3>No Receipt Found</h3>");
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