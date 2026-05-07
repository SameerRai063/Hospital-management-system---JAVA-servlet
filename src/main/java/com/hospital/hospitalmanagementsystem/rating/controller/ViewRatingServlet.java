package com.hospital.hospitalmanagementsystem.rating.controller;

import com.hospital.hospitalmanagementsystem.rating.model.Rating;
import com.hospital.hospitalmanagementsystem.rating.service.RatingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewRatingServlet", urlPatterns = {"/ViewRatingServlet", "/ratings"})
public class ViewRatingServlet extends HttpServlet {
	private RatingService ratingService;

	@Override
	public void init() throws ServletException {
		ratingService = new RatingService();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String idParam = request.getParameter("id");

		try {
			if (idParam != null && !idParam.isBlank()) {
				Rating rating = ratingService.getRatingById(Integer.parseInt(idParam));
				request.setAttribute("rating", rating);
			} else {
				List<Rating> ratings = ratingService.getAllRatings();
				request.setAttribute("ratings", ratings);
			}

			request.getRequestDispatcher("/rating/view-rating.jsp").forward(request, response);
		} catch (Exception e) {
			response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Invalid%20input");
		}
	}
}

