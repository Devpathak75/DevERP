<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
<title>Fill Exam Form</title>

<style>
    body {
        font-family: 'Segoe UI', Arial;
        background: #f4f6f9;
        margin: 0;
    }

    /* 🔥 HEADER */
    .header {
        background: #0d47a1;
        color: white;
        text-align: center;
        padding: 18px;
        font-size: 22px;
        font-weight: bold;
        box-shadow: 0 3px 10px rgba(0,0,0,0.2);
    }

    /* 🔥 MAIN CARD */
    .container {
        width: 600px;
        margin: 40px auto;
        background: white;
        border-radius: 12px;
        padding: 25px;
        box-shadow: 0 10px 25px rgba(0,0,0,0.15);
    }

    .section {
        margin-bottom: 20px;
        padding: 15px;
        border-radius: 10px;
        background: #fafafa;
        border: 1px solid #e0e0e0;
    }

    .section-title {
        font-weight: bold;
        margin-bottom: 10px;
        color: #0d47a1;
        font-size: 16px;
    }

    .subject-list {
        max-height: 150px;
        overflow-y: auto;
        padding-left: 5px;
    }

    .subject-list label {
        display: block;
        margin-bottom: 6px;
        cursor: pointer;
        font-size: 14px;
    }

    input[type="checkbox"] {
        accent-color: #0d47a1;
        margin-right: 8px;
    }

    .amount-box {
        text-align: center;
        font-size: 22px;
        color: #d32f2f;
        font-weight: bold;
        margin-bottom: 10px;
    }

    .qr-box {
        text-align: center;
    }

    .qr-box img {
        border: 1px solid #ccc;
        border-radius: 10px;
        padding: 5px;
    }

    input[type="text"] {
        width: 100%;
        padding: 12px;
        border-radius: 8px;
        border: 1px solid #ccc;
        margin-top: 10px;
        font-size: 14px;
    }

    input[type="text"]:focus {
        outline: none;
        border-color: #0d47a1;
    }

    .btn {
        width: 100%;
        padding: 14px;
        margin-top: 15px;
        background: #0d47a1;
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 16px;
        cursor: pointer;
        transition: 0.3s;
    }

    .btn:hover {
        background: #1565c0;
    }

</style>

</head>

<body>

<div class="header">
    Fill Exam Form
</div>

<div class="container">

<%
List<String> subjects = (List<String>) request.getAttribute("subjects");
int semester = (int) request.getAttribute("semester");
%>

<div class="section">
    <div class="section-title">Current Semester</div>
    <p><b>Semester <%=semester%></b></p>
</div>

<form action="<%=request.getContextPath()%>/SubmitExamFormServlet" method="post">

<!-- 🔥 SUBJECTS -->
<div class="section">
    <div class="section-title">Select Subjects</div>

    <div class="subject-list">
    <%
    for(String sub : subjects){
    %>
        <label>
            <input type="checkbox" name="subjects" value="<%=sub%>" checked>
            <%=sub%>
        </label>
    <%
    }
    %>
    </div>
</div>

<input type="hidden" name="semester" value="<%=semester%>">

<!-- 🔥 PAYMENT -->
<div class="section">

    <div class="section-title">Exam Fee Payment</div>

    <div class="amount-box">₹150</div>

    <div class="qr-box">
        <img src="<%=request.getContextPath()%>/images/qr.png" width="180">
    </div>

    <p style="text-align:center;">Scan QR & pay using any UPI app</p>

    <label><b>Transaction ID</b></label>
    <input type="text" name="txn_id" placeholder="Enter UPI Transaction ID" required>

</div>

<!-- 🔥 SUBMIT -->
<button type="submit" class="btn">Submit Exam Form</button>

</form>

</div>

</body>
</html>