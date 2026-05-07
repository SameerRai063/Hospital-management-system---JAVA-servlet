package com.hospital.hospitalmanagementsystem.rating.service;

import com.hospital.hospitalmanagementsystem.rating.dao.RatingDAO;
import com.hospital.hospitalmanagementsystem.rating.model.Rating;

import java.util.List;

public class RatingService {
	private final RatingDAO ratingDAO;

	public RatingService() {
		this.ratingDAO = new RatingDAO();
	}

	public boolean submitRating(Rating rating) {
		if (!isValid(rating)) {
			return false;
		}
		return ratingDAO.addRating(rating);
	}

	public boolean updateRating(Rating rating) {
		if (rating == null || rating.getId() <= 0 || !isValid(rating)) {
			return false;
		}
		return ratingDAO.updateRating(rating);
	}

	public boolean deleteRating(int id) {
		return id > 0 && ratingDAO.deleteRating(id);
	}

	public Rating getRatingById(int id) {
		if (id <= 0) {
			return null;
		}
		return ratingDAO.getRatingById(id);
	}

	public List<Rating> getAllRatings() {
		return ratingDAO.getAllRatings();
	}

	public List<Rating> getDoctorRatings(int doctorId) {
		return ratingDAO.getRatingsByDoctorId(doctorId);
	}

	private boolean isValid(Rating rating) {
		return rating != null
				&& rating.getPatientId() > 0
				&& rating.getDoctorId() > 0
				&& rating.getAppointmentId() > 0
				&& rating.getScore() >= 1
				&& rating.getScore() <= 5;
	}
}

