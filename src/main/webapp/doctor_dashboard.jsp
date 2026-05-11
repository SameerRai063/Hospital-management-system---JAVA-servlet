<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Doctor Dashboard</title>
</head>
<body>
<h1>Doctor Dashboard</h1>
<p>Welcome, doctor. View ratings and feedback for your patients here.</p>
<ul>
    <li><a href="${pageContext.request.contextPath}/ratings">My Ratings</a></li>
    <li><a href="${pageContext.request.contextPath}/ViewFeedbackServlet">Patient Feedback</a></li>
    <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
</ul>
</body>
</html>

