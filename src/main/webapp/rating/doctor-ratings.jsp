<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Doctor Ratings — Upachar</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
	<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
</head>
<body>
<div class="site">
	<div class="page-shell">
		<header class="topbar">
			<div class="topbar-inner container">
				<a class="brand" href="${pageContext.request.contextPath}/">
					<span class="brand-mark"></span>
					<span>Doctor Ratings<small>Search by doctor ID</small></span>
				</a>
				<nav class="top-links">
					<a href="${pageContext.request.contextPath}/">Home</a>
					<a href="${pageContext.request.contextPath}/rating/add-rating.jsp">Add Rating</a>
					<a href="${pageContext.request.contextPath}/ViewRatingServlet">View Ratings</a>
					<a class="active" href="${pageContext.request.contextPath}/DoctorRatingServlet">Doctor Search</a>
				</nav>
			</div>
		</header>

		<main class="container">
			<section class="hero-banner">
				<div class="hero-card">
					<div class="hero-copy">
						<span class="eyebrow">Doctor-focused insights</span>
						<h1>Find every rating linked to a specific doctor.</h1>
						<p>Use the doctor ID to filter feedback instantly and review the patient experience in a structured format.</p>
					</div>
					<aside class="hero-aside">
						<div>
							<h3 class="aside-title">Search benefits</h3>
							<p style="margin:0;color:rgba(255,255,255,.82);line-height:1.7;">Ideal for reviewing service quality, follow-up performance, and patient response by doctor.</p>
						</div>
						<div class="aside-list">
							<div class="aside-item"><span>Filter</span><strong>Doctor ID</strong></div>
							<div class="aside-item"><span>View</span><strong>All linked ratings</strong></div>
							<div class="aside-item"><span>Use case</span><strong>Quality review</strong></div>
						</div>
					</aside>
				</div>
			</section>

			<section class="section">
				<div class="form-layout">
					<section class="panel">
						<div class="panel-header">
							<div>
								<h2>Search by Doctor ID</h2>
								<p>Enter a doctor identifier to load all relevant feedback.</p>
							</div>
						</div>

						<form action="${pageContext.request.contextPath}/DoctorRatingServlet" method="get" class="form-stack">
							<div>
								<label for="doctorId">Doctor ID</label>
								<input id="doctorId" type="number" min="1" name="doctorId" value="${doctorId}" placeholder="Enter doctor ID">
							</div>
							<div class="actions">
								<button type="submit" class="btn">Search</button>
								<a class="btn secondary" href="${pageContext.request.contextPath}/ViewRatingServlet">Show All Ratings</a>
							</div>
						</form>
					</section>

					<aside class="sidebar-card">
						<h3 style="margin-top:0;">Helpful pointers</h3>
						<div class="summary-list">
							<div class="summary-line"><span>Numeric doctor ID</span><strong>Required</strong></div>
							<div class="summary-line"><span>Results scope</span><strong>Only matching records</strong></div>
							<div class="summary-line"><span>Fallback option</span><strong>All ratings view</strong></div>
						</div>
					</aside>
				</div>
			</section>

			<c:if test="${not empty doctorId}">
				<section class="section">
					<div class="panel badge">Showing results for Doctor ID ${doctorId}</div>
				</section>
			</c:if>

			<c:choose>
				<c:when test="${not empty doctorRatings}">
					<section class="section">
						<div class="panel-header">
							<div>
								<h2>Matched Ratings</h2>
								<p>All feedback records linked to the selected doctor.</p>
							</div>
						</div>

						<div class="table-card">
							<table>
								<thead>
									<tr>
										<th>ID</th>
										<th>Patient</th>
										<th>Appointment</th>
										<th>Score</th>
										<th>Review</th>
										<th>Created</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="rating" items="${doctorRatings}">
										<tr>
											<td>${rating.id}</td>
											<td>${rating.patientId}</td>
											<td>${rating.appointmentId}</td>
											<td>${rating.score}</td>
											<td>${rating.review}</td>
											<td>${rating.createdAt}</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</section>
				</c:when>
				<c:otherwise>
					<section class="section">
						<div class="panel empty">No ratings found. Enter a doctor ID and search to see results here.</div>
					</section>
				</c:otherwise>
			</c:choose>
		</main>

		<footer class="footer container">
			<div class="link-row">
				<a href="${pageContext.request.contextPath}/">Home</a>
				<a href="${pageContext.request.contextPath}/rating/add-rating.jsp">Add Rating</a>
				<a href="${pageContext.request.contextPath}/ViewRatingServlet">All Ratings</a>
			</div>
		</footer>
	</div>
</div>

</body>
</html>

