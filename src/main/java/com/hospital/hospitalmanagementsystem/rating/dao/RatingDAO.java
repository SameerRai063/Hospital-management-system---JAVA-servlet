package com.hospital.hospitalmanagementsystem.rating.dao;

import com.hospital.hospitalmanagementsystem.rating.model.Rating;
import com.hospital.hospitalmanagementsystem.rating.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class RatingDAO {

	public boolean addRating(Rating rating) {
		String sql = "INSERT INTO ratings (patient_id, doctor_id, appointment_id, score, review, created_at) VALUES (?, ?, ?, ?, ?, ?)";

		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, rating.getPatientId());
			pstmt.setInt(2, rating.getDoctorId());
			pstmt.setInt(3, rating.getAppointmentId());
			pstmt.setInt(4, rating.getScore());
			pstmt.setString(5, rating.getReview());
			pstmt.setTimestamp(6, new Timestamp(System.currentTimeMillis()));

			return pstmt.executeUpdate() > 0;
		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return false;
		}
	}

	public Rating getRatingById(int id) {
		String sql = "SELECT id, patient_id, doctor_id, appointment_id, score, review, created_at FROM ratings WHERE id = ?";

		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, id);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					Rating rating = mapRating(rs);
					return rating;
				}
			}
		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
		}

		return null;
	}

	public List<Rating> getAllRatings() {
		List<Rating> ratings = new ArrayList<>();
		String sql = "SELECT id, patient_id, doctor_id, appointment_id, score, review, created_at FROM ratings ORDER BY created_at DESC";

		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql);
			 ResultSet rs = pstmt.executeQuery()) {

			while (rs.next()) {
				ratings.add(mapRating(rs));
			}
		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
		}

		return ratings;
	}

	public List<Rating> getRatingsByDoctorId(int doctorId) {
		List<Rating> ratings = new ArrayList<>();
		String sql = "SELECT id, patient_id, doctor_id, appointment_id, score, review, created_at FROM ratings WHERE doctor_id = ? ORDER BY created_at DESC";

		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, doctorId);

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					ratings.add(mapRating(rs));
				}
			}
		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
		}

		return ratings;
	}

	public boolean updateRating(Rating rating) {
		String sql = "UPDATE ratings SET patient_id = ?, doctor_id = ?, appointment_id = ?, score = ?, review = ? WHERE id = ?";

		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, rating.getPatientId());
			pstmt.setInt(2, rating.getDoctorId());
			pstmt.setInt(3, rating.getAppointmentId());
			pstmt.setInt(4, rating.getScore());
			pstmt.setString(5, rating.getReview());
			pstmt.setInt(6, rating.getId());

			return pstmt.executeUpdate() > 0;
		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return false;
		}
	}

	public boolean deleteRating(int id) {
		String sql = "DELETE FROM ratings WHERE id = ?";

		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, id);
			return pstmt.executeUpdate() > 0;
		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return false;
		}
	}

	private Rating mapRating(ResultSet rs) throws SQLException {
		Rating rating = new Rating();
		rating.setId(rs.getInt("id"));
		rating.setPatientId(rs.getInt("patient_id"));
		rating.setDoctorId(rs.getInt("doctor_id"));
		rating.setAppointmentId(rs.getInt("appointment_id"));
		rating.setScore(rs.getInt("score"));
		rating.setReview(rs.getString("review"));
		rating.setCreatedAt(rs.getTimestamp("created_at"));
		return rating;
	}
}

