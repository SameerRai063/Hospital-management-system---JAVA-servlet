package com.hospital.hospitalmanagementsystem.rating.controller;

import com.hospital.hospitalmanagementsystem.rating.model.Rating;
import com.hospital.hospitalmanagementsystem.rating.service.RatingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "AddRatingServlet", urlPatterns = {"/AddRatingServlet", "/ratings/new"})
public class AddRatingServlet extends HttpServlet {
	private RatingService ratingService;

	@Override
	public void init() throws ServletException {
		ratingService = new RatingService();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("/rating/add-rating.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			int patientId = Integer.parseInt(request.getParameter("patientId"));
			int doctorId = Integer.parseInt(request.getParameter("doctorId"));
			int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
			int score = Integer.parseInt(request.getParameter("score"));
			String review = request.getParameter("review");

			Rating rating = new Rating();
			rating.setPatientId(patientId);
			rating.setDoctorId(doctorId);
			rating.setAppointmentId(appointmentId);
			rating.setScore(score);
			rating.setReview(review);

			boolean isSuccess = ratingService.submitRating(rating);
			String message = isSuccess ? "Rating added successfully" : "Failed to add rating";

			response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=" + java.net.URLEncoder.encode(message, java.nio.charset.StandardCharsets.UTF_8));
		} catch (Exception e) {
			response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Invalid%20input");
		}
	}
}

