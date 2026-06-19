<%@ page import="java.sql.*" %>
<%@ page import="com.collegeerp.dao.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
<title>Exam Form Approval</title>

<style>
    body {
        font-family: 'Segoe UI', Arial;
        background: #eef2f7;
        margin: 0;
    }

    .header {
        background: #0d47a1;
        color: white;
        padding: 15px;
        text-align: center;
        font-size: 22px;
        font-weight: bold;
    }

    .container {
        width: 95%;
        margin: 30px auto;
        background: white;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 0 15px rgba(0,0,0,0.2);
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 10px;
    }

    th, td {
        border: 1px solid #ccc;
        padding: 10px;
        text-align: center;
        font-size: 14px;
    }

    th {
        background: #0d47a1;
        color: white;
    }

    tr:nth-child(even) {
        background: #f9f9f9;
    }

    .btn {
        padding: 6px 12px;
        background: #2e7d32;
        color: white;
        text-decoration: none;
        border-radius: 5px;
        font-size: 13px;
    }

    .approved {
        color: green;
        font-weight: bold;
    }

    .pending {
        color: red;
        font-weight: bold;
    }

</style>

</head>

<body>

<div class="header">
    Exam Form Approval Panel (Admin)
</div>

<div class="container">

<h3>Student Exam Form Requests</h3>

<table>

<tr>
    <th>ID</th>
    <th>Name</th>
    <th>Enrollment</th>
    <th>Email</th>
    <th>Subjects</th>
    <th>Txn ID</th>
    <th>Status</th>
    <th>Action</th>
</tr>

<%
Connection con = DBConnection.getConnection();

PreparedStatement ps = con.prepareStatement(
    "SELECT ef.*, s.name, s.enrollment, s.email " +
    "FROM exam_form ef " +
    "JOIN student s ON ef.student_id = s.id"
);

ResultSet rs = ps.executeQuery();

while(rs.next()){
    String status = rs.getString("status");
%>

<tr>
    <td><%=rs.getInt("student_id")%></td>
    <td><%=rs.getString("name")%></td>
    <td><%=rs.getString("enrollment")%></td>
    <td><%=rs.getString("email")%></td>
    <td><%=rs.getString("subjects")%></td>
    <td><%=rs.getString("payment_id")%></td>

    <td class="<%=status.equals("PAID") ? "approved" : "pending"%>">
        <%=status%>
    </td>

    <td>
        <% if(status.equals("PENDING")){ %>
            <a class="btn" href="../ApproveExamServlet?id=<%=rs.getInt("id")%>">
                Approve
            </a>
        <% } else { %>
            <span class="approved">Approved</span>
        <% } %>
    </td>
</tr>

<% } %>

</table>

</div>

</body>
</html>