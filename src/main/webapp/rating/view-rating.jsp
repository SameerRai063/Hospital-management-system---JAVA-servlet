<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>View Ratings — Upachar</title>
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
					<span>View Ratings<small>Review and manage feedback</small></span>
				</a>
				<nav class="top-links">
					<a href="${pageContext.request.contextPath}/">Home</a>
					<a href="${pageContext.request.contextPath}/rating/add-rating.jsp">Add Rating</a>
					<a class="active" href="${pageContext.request.contextPath}/ViewRatingServlet">View Ratings</a>
					<a href="${pageContext.request.contextPath}/DoctorRatingServlet">Doctor Search</a>
				</nav>
			</div>
		</header>

		<main class="container">
			<section class="hero-banner">
				<div class="hero-card">
					<div class="hero-copy">
						<span class="eyebrow">Ratings registry</span>
						<h1>Browse every rating in a structured, readable format.</h1>
						<p>Search by rating ID, inspect details, and use clear edit/delete actions to keep the portal organized.</p>
					</div>
					<aside class="hero-aside">
						<div>
							<h3 class="aside-title">Management tools</h3>
							<p style="margin:0;color:rgba(255,255,255,.82);line-height:1.7;">A single place to search, review, and update feedback records without clutter.</p>
						</div>
						<div class="aside-list">
							<div class="aside-item"><span>Find by ID</span><strong>Fast lookup</strong></div>
							<div class="aside-item"><span>Record details</span><strong>Full view</strong></div>
							<div class="aside-item"><span>Actions</span><strong>Edit / Delete</strong></div>
						</div>
					</aside>
				</div>
			</section>

			<section class="section">
				<div class="form-layout">
					<section class="panel">
						<div class="panel-header">
							<div>
								<h2>Search Ratings</h2>
								<p>Find a specific rating by its ID or load the complete list.</p>
							</div>
						</div>

						<form action="${pageContext.request.contextPath}/ViewRatingServlet" method="get" class="form-stack">
							<div>
								<label for="id">Rating ID</label>
								<input id="id" type="number" min="1" name="id" placeholder="Enter rating ID">
							</div>
							<div class="actions">
								<button type="submit" class="btn">Search</button>
								<a class="btn secondary" href="${pageContext.request.contextPath}/ViewRatingServlet">Show All</a>
							</div>
						</form>
					</section>

					<aside class="sidebar-card">
						<h3 style="margin-top:0;">Review tips</h3>
						<div class="summary-list">
							<div class="summary-line"><span>Use clear IDs</span><strong>Faster lookup</strong></div>
							<div class="summary-line"><span>Edit if required</span><strong>Keep records current</strong></div>
							<div class="summary-line"><span>Delete carefully</span><strong>Confirm first</strong></div>
						</div>
					</aside>
				</div>
			</section>

			<c:choose>
				<c:when test="${not empty rating}">
					<section class="section">
						<div class="panel-header">
							<div>
								<h2>Selected Rating</h2>
								<p>Detailed view for a single rating record.</p>
							</div>
						</div>

						<div class="table-card">
							<table>
								<tbody>
									<tr><td><strong>ID</strong></td><td>${rating.id}</td></tr>
									<tr><td><strong>Patient ID</strong></td><td>${rating.patientId}</td></tr>
									<tr><td><strong>Doctor ID</strong></td><td>${rating.doctorId}</td></tr>
									<tr><td><strong>Appointment ID</strong></td><td>${rating.appointmentId}</td></tr>
									<tr><td><strong>Score</strong></td><td>${rating.score}</td></tr>
									<tr><td><strong>Review</strong></td><td>${rating.review}</td></tr>
									<tr><td><strong>Created At</strong></td><td>${rating.createdAt}</td></tr>
								</tbody>
							</table>
						</div>

						<div class="actions" style="margin-top:14px;">
							<a class="btn" href="${pageContext.request.contextPath}/UpdateRatingServlet?id=${rating.id}">Edit Rating</a>
							<form class="inline-form" action="${pageContext.request.contextPath}/DeleteRatingServlet" method="post" onsubmit="return confirm('Delete this rating?');">
								<input type="hidden" name="id" value="${rating.id}">
								<button class="btn danger" type="submit">Delete Rating</button>
							</form>
						</div>
					</section>
				</c:when>

				<c:when test="${not empty ratings}">
					<section class="section">
						<div class="panel-header">
							<div>
								<h2>All Ratings</h2>
								<p>Complete list of submitted feedback entries.</p>
							</div>
						</div>

						<div class="table-card">
							<table>
								<thead>
									<tr>
										<th>ID</th>
										<th>Patient</th>
										<th>Doctor</th>
										<th>Appointment</th>
										<th>Score</th>
										<th>Review</th>
										<th>Created</th>
										<th>Actions</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="item" items="${ratings}">
										<tr>
											<td>${item.id}</td>
											<td>${item.patientId}</td>
											<td>${item.doctorId}</td>
											<td>${item.appointmentId}</td>
											<td>${item.score}</td>
											<td>${item.review}</td>
											<td>${item.createdAt}</td>
											<td>
												<div class="row-actions">
													<a class="btn small" href="${pageContext.request.contextPath}/UpdateRatingServlet?id=${item.id}">Edit</a>
													<form class="inline-form" action="${pageContext.request.contextPath}/DeleteRatingServlet" method="post" onsubmit="return confirm('Delete this rating?');">
														<input type="hidden" name="id" value="${item.id}">
														<button class="btn danger small" type="submit">Delete</button>
													</form>
												</div>
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</section>
				</c:when>

				<c:otherwise>
					<section class="section">
						<div class="panel empty">No ratings available. Start by creating the first feedback entry.</div>
					</section>
				</c:otherwise>
			</c:choose>
		</main>

		<footer class="footer container">
			<div class="link-row">
				<a href="${pageContext.request.contextPath}/">Home</a>
				<a href="${pageContext.request.contextPath}/rating/add-rating.jsp">Add Rating</a>
				<a href="${pageContext.request.contextPath}/DoctorRatingServlet">Doctor Search</a>
			</div>
		</footer>
	</div>
</div>

</body>
</html>

