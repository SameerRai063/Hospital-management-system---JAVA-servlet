package com.hospital.hospitalmanagementsystem.rating.controller;

import com.hospital.hospitalmanagementsystem.rating.model.Rating;
import com.hospital.hospitalmanagementsystem.rating.service.RatingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet(name = "DoctorRatingServlet", urlPatterns = {"/DoctorRatingServlet", "/ratings/doctor"})
public class DoctorRatingServlet extends HttpServlet {
	private RatingService ratingService;

	@Override
	public void init() throws ServletException {
		ratingService = new RatingService();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			String doctorIdParam = request.getParameter("doctorId");

			if (doctorIdParam != null && !doctorIdParam.isBlank()) {
				int doctorId = Integer.parseInt(doctorIdParam);
				List<Rating> ratingsList = ratingService.getDoctorRatings(doctorId);
				request.setAttribute("doctorRatings", ratingsList);
				request.setAttribute("doctorId", doctorId);
			} else {
				request.setAttribute("doctorRatings", Collections.emptyList());
			}

			request.getRequestDispatcher("/rating/doctor-ratings.jsp").forward(request, response);
		} catch (Exception e) {
			response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Invalid%20doctor%20ID");
		}
	}
}

