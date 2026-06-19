package com.collegeerp.controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

import com.collegeerp.dao.DBConnection;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

public class DownloadExamFormServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int studentId = (int) request.getSession().getAttribute("studentId");

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "SELECT s.name, e.* FROM exam_form e JOIN student s ON e.student_id=s.id WHERE e.student_id=?"
            );
            ps.setInt(1, studentId);

            ResultSet rs = ps.executeQuery();

            if(rs.next()){

                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", "attachment; filename=ExamForm.pdf");

                Document doc = new Document();
                PdfWriter.getInstance(doc, response.getOutputStream());

                doc.open();

                doc.add(new Paragraph("COLLEGE ERP EXAM FORM"));
                doc.add(new Paragraph(" "));
                doc.add(new Paragraph("Student Name: " + rs.getString("name")));
                doc.add(new Paragraph("Semester: " + rs.getInt("semester")));
                doc.add(new Paragraph("Subjects: " + rs.getString("subjects")));
                doc.add(new Paragraph("Amount: ₹150"));
                doc.add(new Paragraph("Transaction ID: " + rs.getString("payment_id")));
                doc.add(new Paragraph("Status: " + rs.getString("status")));

                doc.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}