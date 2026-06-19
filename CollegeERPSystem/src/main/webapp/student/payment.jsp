<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>UPI Payment</title>
    <meta charset="UTF-8">

    <style>
        body {
            font-family: Arial;
            text-align: center;
            background: #f5f5f5;
        }
        .box {
            background: white;
            padding: 20px;
            margin: 50px auto;
            width: 400px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px gray;
        }
        .btn {
            padding: 10px 15px;
            background: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
        }
    </style>
</head>
<body>

<%
    // 🔹 Get data from previous page
    String[] subjects = request.getParameterValues("subjects");
    String semester = request.getParameter("semester");

    // 🔹 Store in session (VERY IMPORTANT FIX)
    if(subjects != null && semester != null){
        session.setAttribute("subjects", String.join(",", subjects));
        session.setAttribute("semester", semester);
    } else {
%>
        <h3 style="color:red;">❌ No subjects selected. Go back and try again.</h3>
<%
        return;
    }
%>

<div class="box">

<h2>Pay Exam Fee ₹150</h2>

<!-- 🔹 UPI Details -->
<h3>Pay using UPI</h3>

<p><b>UPI ID:</b> devpathak@upi</p>

<!-- 🔹 QR Code -->
<img src="<%=request.getContextPath()%>/images/upi_qr.png" width="200" height="200">

<br><br>

<h3>After Payment, Enter Transaction ID</h3>

<form action="<%=request.getContextPath()%>/SubmitExamFormServlet" method="post">

    <label>Transaction ID:</label><br>
    <input type="text" name="txn_id" required>

    <br><br>

    <button class="btn" type="submit">Submit Payment</button>

</form>

</div>

</body>
</html>