<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Exam Form</title>

<style>
    body {
        font-family: 'Segoe UI', Arial;
        background: #f0f2f5;
    }

    /* 🔥 A4 PAGE */
    .page {
        width: 210mm;
        min-height: 297mm;
        margin: 20px auto;
        background: white;
        padding: 25px;

        /* 🔥 SQUARE BORDER */
        border: 3px solid #000;

        box-shadow: 0 0 12px rgba(0,0,0,0.2);
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 10px;
    }

    td, th {
        border: 1px solid #444;
        padding: 8px;
        font-size: 14px;
    }

    th {
        background: #e6e6e6;
    }

    .center {
        text-align: center;
    }

    .header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        border-bottom: 2px solid #000;
        padding-bottom: 10px;
    }

    .header img {
        height: 85px;
    }

    .title {
        text-align: center;
    }

    .title h2 {
        margin: 2px;
        color: #003366;
    }

    .title h4 {
        margin: 2px;
        font-weight: normal;
    }

    .section-title {
        background: #003366;
        color: white;
        padding: 6px;
        font-size: 15px;
        margin-top: 15px;
    }

    .status-approved {
        color: green;
        font-weight: bold;
    }

    .status-pending {
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
        font-size: 16px;
        background: #c62828;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }

    /* 🔥 PRINT FIX */
    @media print {
        body {
            background: white;
            margin: 0;
        }

        .page {
            margin: 0;
            box-shadow: none;
            border: 2px solid black;
        }

        .print {
            display: none;
        }
    }
</style>

</head>

<body>

<div class="page">

<%
String name = (String) request.getAttribute("name");
String enrollment = (String) request.getAttribute("enrollment");
String dept = (String) request.getAttribute("dept");
Integer semester = (Integer) request.getAttribute("semester");
String subjects = (String) request.getAttribute("subjects");
Integer amount = (Integer) request.getAttribute("amount");
String payment_id = (String) request.getAttribute("payment_id");
String status = (String) request.getAttribute("status");
String date = (String) request.getAttribute("date");

if(name == null){
%>
<h3 style="color:red; text-align:center;">❌ No Exam Form Data Found</h3>
<%
return;
}
%>

<!-- 🔥 HEADER -->
<div class="header">
    <img src="images/college.png">

    <div class="title">
        <h2>Dev Institute of Technology & Engineering</h2>
        <h4>(Autonomous Institute Affiliated to Dev Pathak University)</h4>
        <h4>NASHIK, MAHARASHTRA - 422213</h4>
        <h4>TY (2023 Pattern) January 2026</h4>
        <h3 style="color:#c62828;">EXAM FORM - SEM <%=semester%></h3>
    </div>

    <img src="images/university.png">
</div>

<!-- 🔥 STUDENT INFO -->
<div class="section-title">Student Information</div>

<table>
<tr>
    <td><b>Name</b></td>
    <td><%=name%></td>
    <td><b>Enrollment No</b></td>
    <td><%=enrollment%></td>
</tr>

<tr>
    <td><b>Department</b></td>
    <td><%=dept%></td>
    <td><b>Semester</b></td>
    <td><%=semester%></td>
</tr>
</table>

<!-- 🔥 SUBJECTS -->
<div class="section-title">Subjects Registered</div>

<table>
<tr class="center">
    <th>Sr No</th>
    <th>Subject Name</th>
    <th>Status</th>
</tr>

<%
String[] subArr = subjects.split(",");
for(int i=0;i<subArr.length;i++){
%>
<tr>
    <td class="center"><%=i+1%></td>
    <td><%=subArr[i]%></td>
    <td class="center">Registered</td>
</tr>
<% } %>

</table>

<!-- 🔥 PAYMENT -->
<div class="section-title">Payment Details</div>

<table>
<tr>
    <td><b>Fees</b></td>
    <td>₹ <%=amount%></td>
    <td><b>Transaction ID</b></td>
    <td><%=payment_id%></td>
</tr>

<tr>
    <td><b>Status</b></td>
    <td colspan="3" class="<%= "APPROVED".equalsIgnoreCase(status) ? "status-approved" : "status-pending" %>">
        <%=status%>
    </td>
</tr>

<tr>
    <td><b>Date</b></td>
    <td colspan="3"><%=date%></td>
</tr>
</table>

<!-- 🔥 SIGNATURE -->
<div class="section-title">Authorization</div>

<table>
<tr>
    <td class="center sign-box">Student Signature</td>
    <td class="center sign-box">Exam Cell</td>
    <td class="center sign-box">HOD Signature</td>
</tr>
</table>

<p style="margin-top:10px; font-size:13px;">
* This form is valid only after approval by the institute.
</p>

<!-- 🔥 PRINT -->
<% if("APPROVED".equalsIgnoreCase(status)){ %>
<div class="print">
    <button onclick="window.print()">Download</button>
</div>
<% } else { %>
<h3 class="center status-pending">⏳ Waiting for Approval</h3>
<% } %>

</div>

</body>
</html>