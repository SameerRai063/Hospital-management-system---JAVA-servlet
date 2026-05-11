package Feedback.dao;

import Feedback.Model.Feedback;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    public boolean addFeedback(Feedback f) {
        String sql = "INSERT INTO feedbacks (appointment_id, patient_id, doctor_id, comment, rating, created_at) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, f.getAppointmentId());
            ps.setInt(2, f.getPatientId());
            ps.setInt(3, f.getDoctorId());
            ps.setString(4, f.getComment());
            ps.setInt(5, f.getRating());
            ps.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Feedback> getAllFeedback() {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT id, appointment_id, patient_id, doctor_id, comment, rating, created_at FROM feedbacks ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Feedback f = new Feedback();
                f.setId(rs.getInt("id"));
                f.setAppointmentId(rs.getInt("appointment_id"));
                f.setPatientId(rs.getInt("patient_id"));
                f.setDoctorId(rs.getInt("doctor_id"));
                f.setComment(rs.getString("comment"));
                f.setRating(rs.getInt("rating"));
                f.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(f);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Feedback> getFeedbackByDoctorId(int doctorId) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT id, appointment_id, patient_id, doctor_id, comment, rating, created_at FROM feedbacks WHERE doctor_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Feedback f = new Feedback();
                    f.setId(rs.getInt("id"));
                    f.setAppointmentId(rs.getInt("appointment_id"));
                    f.setPatientId(rs.getInt("patient_id"));
                    f.setDoctorId(rs.getInt("doctor_id"));
                    f.setComment(rs.getString("comment"));
                    f.setRating(rs.getInt("rating"));
                    f.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(f);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return list;
    }
}

