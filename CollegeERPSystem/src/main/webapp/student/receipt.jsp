<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.collegeerp.dao.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
<title>Payment Receipt</title>

<style>
    body {
        font-family: 'Segoe UI', Arial;
        background: #f4f6f9;
    }

    .page {
        width: 210mm;
        min-height: 297mm;
        margin: auto;
        background: white;
        padding: 30px;
        box-shadow: 0 0 12px rgba(0,0,0,0.2);
    }

    .header {
        text-align: center;
        border-bottom: 2px solid #000;
        padding-bottom: 10px;
    }

    .header h2 {
        margin: 3px;
        color: #003366;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 12px;
    }

    td, th {
        border: 1px solid #444;
        padding: 8px;
        font-size: 14px;
    }

    th {
        background: #eaeaea;
    }

    .section-title {
        background: #003366;
        color: white;
        padding: 6px;
        margin-top: 15px;
        font-weight: bold;
    }

    .center { text-align: center; }

    .approved {
        color: green;
        font-weight: bold;
    }

    .pending {
        color: red;
        font-weight: bold;
    }

    .sign-box {
        height: 60px;
    }

    .print {
        text-align: center;
        margin-top: 30px;
    }

    .print button {
        padding: 10px 25px;
        background: #c62828;
        color: white;
        border: none;
        border-radius: 5px;
        font-size: 16px;
        cursor: pointer;
    }

    @media print {
        .print { display: none; }
    }

</style>

</head>

<body>

<div class="page">

<%
int studentId = (int) session.getAttribute("studentId");

Connection con = DBConnection.getConnection();

PreparedStatement ps = con.prepareStatement(
    "SELECT s.name, s.enrollment, s.email, ef.amount, ef.payment_id, ef.status, ef.date " +
    "FROM exam_form ef " +
    "JOIN student s ON ef.student_id = s.id " +
    "WHERE ef.student_id=? ORDER BY ef.id DESC LIMIT 1"
);

ps.setInt(1, studentId);
ResultSet rs = ps.executeQuery();

if(rs.next()){

String name = rs.getString("name");
String enrollment = rs.getString("enrollment");
String email = rs.getString("email");
int amount = rs.getInt("amount");
String txn = rs.getString("payment_id");
String status = rs.getString("status");   // APPROVED / PENDING
String date = rs.getString("date");
%>

<!-- 🔥 HEADER -->
<div class="header">
    <h2>Dev Institute of Technology & Engineering</h2>
    <h3>Fees Challan Cum Receipt</h3>
    <h4>Academic Year: 2025-26</h4>
</div>

<!-- 🔥 STUDENT INFO -->
<table>
<tr>
    <td><b>Name</b></td>
    <td><%=name%></td>
    <td><b>Enrollment</b></td>
    <td><%=enrollment%></td>
</tr>

<tr>
    <td><b>Email</b></td>
    <td><%=email%></td>
    <td><b>Date</b></td>
    <td><%=date%></td>
</tr>

<tr>
    <td><b>Transaction ID</b></td>
    <td colspan="3"><%=txn%></td>
</tr>
</table>

<!-- 🔥 PAYMENT -->
<div class="section-title">Payment Details</div>

<table>
<tr>
    <th>Particulars</th>
    <th>Amount</th>
</tr>

<tr>
    <td>Exam Fees</td>
    <td class="center">&#8377; <%=amount%></td>
</tr>

<tr>
    <td><b>Total</b></td>
    <td class="center"><b>&#8377; <%=amount%></b></td>
</tr>
</table>

<br>

<!-- 🔥 STATUS FIX -->
<p>
<b>Status:</b> 
<span class="<%= "APPROVED".equalsIgnoreCase(status) ? "approved" : "pending" %>">
    <%=status%>
</span>
</p>

<p><b>Mode:</b> Online Payment</p>

<p><b>Amount in Words:</b> Rupees One Hundred Fifty Only</p>

<!-- 🔥 SIGNATURE -->
<div class="section-title">Authorization</div>

<table>
<tr>
    <td class="center sign-box">Student Signature</td>
    <td class="center sign-box">Authorized Signatory</td>
</tr>
</table>

<p style="font-size:12px;">
This is a computer generated receipt.
</p>

<!-- 🔥 PRINT CONDITION FIX -->
<% if("APPROVED".equalsIgnoreCase(status)){ %>
<div class="print">
    <button onclick="window.print()">Download / Print Receipt</button>
</div>
<% } else { %>
<h3 class="pending center">⏳ Waiting for Approval</h3>
<% } %>

<% } else { %>

<h3 style="color:red; text-align:center;">❌ No Payment Found</h3>

<% } %>

</div>

</body>
</html>