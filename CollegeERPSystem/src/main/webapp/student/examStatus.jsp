<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.collegeerp.dao.DBConnection" %>

<%
/* 🔥 CACHE FIX (VERY IMPORTANT) */
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html>
<head>
<title>Exam Form Status</title>

<style>
    body {
        font-family: 'Segoe UI', Arial;
        background: #eef2f7;
        text-align: center;
    }

    .box {
        background: white;
        padding: 30px;
        margin: 60px auto;
        width: 450px;
        border-radius: 14px;
        box-shadow: 0 12px 30px rgba(0,0,0,0.2);
    }

    h2 {
        color: #0d47a1;
        margin-bottom: 15px;
    }

    .info {
        margin: 10px 0;
        font-size: 15px;
    }

    .btn {
        display: inline-block;
        padding: 10px 18px;
        margin: 10px 5px;
        background: #0d47a1;
        color: white;
        text-decoration: none;
        border-radius: 6px;
        transition: 0.3s;
        font-size: 14px;
    }

    .btn:hover {
        background: #1565c0;
    }

    .pending {
        color: red;
        font-weight: bold;
    }

    .approved {
        color: green;
        font-weight: bold;
    }

</style>
</head>

<body>

<div class="box">

<h2>Exam Form Status</h2>

<%
Integer studentIdObj = (Integer) session.getAttribute("studentId");

if(studentIdObj == null){
    response.sendRedirect("../login.jsp?error=sessionExpired");
    return;
}

int studentId = studentIdObj;

Connection con = DBConnection.getConnection();

/* 🔥 FETCH LATEST RECORD ONLY */
PreparedStatement ps = con.prepareStatement(
    "SELECT * FROM exam_form WHERE student_id=? ORDER BY id DESC LIMIT 1"
);

ps.setInt(1, studentId);
ResultSet rs = ps.executeQuery();

if(rs.next()){
    String status = rs.getString("status");
%>

<div class="info">
    <b>Subjects:</b><br>
    <%=rs.getString("subjects")%>
</div>

<div class="info">
    <b>Status:</b><br>
    <span class="<%= "APPROVED".equalsIgnoreCase(status) ? "approved" : "pending" %>">
        <%=status%>
    </span>
</div>

<% if("APPROVED".equalsIgnoreCase(status)){ %>

    <h3 class="approved">✅ Exam Form Approved</h3>

    <!-- 🔥 VIEW FORM -->
    <a class="btn" href="<%=request.getContextPath()%>/ViewExamFormServlet">
        View Exam Form
    </a>

    <!-- 🔥 RECEIPT (NO SERVLET NOW) -->
    <a class="btn" href="receipt.jsp">
        View / Download Receipt
    </a>

<% } else { %>

    <h3 class="pending">⏳ Waiting for Admin Approval</h3>

<% } %>

<% } else { %>

<p>No exam form submitted</p>

<a class="btn" href="dashboard.jsp">Go Back</a>

<% } %>

</div>

</body>
</html>