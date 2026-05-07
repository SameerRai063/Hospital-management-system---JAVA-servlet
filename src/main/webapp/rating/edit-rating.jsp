<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Edit Rating — Upachar</title>
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
					<span>Edit Rating<small>Update a feedback record</small></span>
				</a>
				<nav class="top-links">
					<a href="${pageContext.request.contextPath}/">Home</a>
					<a href="${pageContext.request.contextPath}/rating/add-rating.jsp">Add Rating</a>
					<a class="active" href="${pageContext.request.contextPath}/ViewRatingServlet">View Ratings</a>
				</nav>
			</div>
		</header>

		<main class="container">
			<section class="hero-banner">
				<div class="hero-card">
					<div class="hero-copy">
						<span class="eyebrow">Edit workflow</span>
						<h1>Refine the rating details with confidence.</h1>
						<p>Review and update the current record while keeping the structure consistent and easy to scan.</p>
					</div>
					<aside class="hero-aside">
						<div>
							<h3 class="aside-title">Editing checklist</h3>
							<p style="margin:0;color:rgba(255,255,255,.82);line-height:1.7;">Confirm IDs, adjust the score, and revise the review text before saving your changes.</p>
						</div>
						<div class="aside-list">
							<div class="aside-item"><span>Review record</span><strong>Current data</strong></div>
							<div class="aside-item"><span>Score update</span><strong>1 - 5</strong></div>
							<div class="aside-item"><span>Save action</span><strong>One click</strong></div>
						</div>
					</aside>
				</div>
			</section>

			<c:choose>
				<c:when test="${not empty rating}">
					<section class="section">
						<div class="form-layout">
							<section class="panel">
								<div class="panel-header">
									<div>
										<h2>Edit Rating</h2>
										<p>Update the selected rating below.</p>
									</div>
								</div>

								<form action="${pageContext.request.contextPath}/UpdateRatingServlet" method="post" class="form-stack">
									<input type="hidden" name="id" value="${rating.id}">

									<div class="form-layout two-col">
										<div>
											<label for="patientId">Patient ID</label>
											<input id="patientId" type="number" name="patientId" value="${rating.patientId}" min="1" required>
										</div>
										<div>
											<label for="doctorId">Doctor ID</label>
											<input id="doctorId" type="number" name="doctorId" value="${rating.doctorId}" min="1" required>
										</div>
									</div>

									<div class="form-layout two-col">
										<div>
											<label for="appointmentId">Appointment ID</label>
											<input id="appointmentId" type="number" name="appointmentId" value="${rating.appointmentId}" min="1" required>
										</div>
										<div>
											<label for="score">Score</label>
											<input id="score" type="number" name="score" min="1" max="5" value="${rating.score}" required>
										</div>
									</div>

									<div>
										<label for="review">Review</label>
										<textarea id="review" name="review">${rating.review}</textarea>
									</div>

									<div class="actions">
										<button type="submit" class="btn">Update Rating</button>
										<a class="btn secondary" href="${pageContext.request.contextPath}/ViewRatingServlet">Cancel</a>
										<a class="btn ghost" href="${pageContext.request.contextPath}/">Home</a>
									</div>
								</form>
							</section>

							<aside class="sidebar-card">
								<h3 style="margin-top:0;">Selected record</h3>
								<div class="summary-list">
									<div class="summary-line"><span>Rating ID</span><strong>${rating.id}</strong></div>
									<div class="summary-line"><span>Patient ID</span><strong>${rating.patientId}</strong></div>
									<div class="summary-line"><span>Doctor ID</span><strong>${rating.doctorId}</strong></div>
								</div>
							</aside>
						</div>
					</section>
				</c:when>
				<c:otherwise>
					<section class="section">
						<div class="panel empty">No rating selected. Return to the list and choose a record to edit.</div>
					</section>
				</c:otherwise>
			</c:choose>
		</main>

		<footer class="footer container">
			<div class="link-row">
				<a href="${pageContext.request.contextPath}/">Home</a>
				<a href="${pageContext.request.contextPath}/ViewRatingServlet">Back to Ratings</a>
			</div>
		</footer>
	</div>
</div>

</body>
</html>

