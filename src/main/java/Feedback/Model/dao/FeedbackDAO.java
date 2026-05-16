package Feedback.Model.dao;

import Feedback.Model.Feedback;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    private final Connection con;

    public FeedbackDAO(Connection con) {
        this.con = con;
    }

    // ── Count total feedbacks ──────────────────────────────────────────────
    public boolean addFeedback(Feedback feedback) {
        String sql = "INSERT INTO feedback (patient_id, comment, rating, created_at) VALUES (?, ?, ?, NOW())";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, feedback.getPatientId());
            ps.setString(2, feedback.getComment());
            ps.setInt(3, feedback.getRating());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public int countTotalFeedback() {
        String sql = "SELECT COUNT(*) FROM feedback";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    // ── Average rating ────────────────────────────────────────────────────

    public double getAverageRating() {
        String sql = "SELECT AVG(rating) FROM feedback";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                double avg = rs.getDouble(1);
                // AVG returns 0.0 and wasNull() == true when table is empty
                return rs.wasNull() ? 0.0 : avg;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    // ── List all feedbacks with patient + doctor names ─────────────────────

    /**
     * Joins feedback → users (patient) → appointments → doctors → users (doctor).
     *
     * Schema assumptions:
     *   feedback(id, patient_id, doctor_id, comment, rating, created_at)
     *   users(id, name, ...)
     *
     * Two supported schema variants are handled:
     *
     * Variant A – feedback has a direct doctor_id FK that references the
     *             doctors table (doctors.id).  The doctors table itself has a
     *             user_id FK into users so we can get the doctor's name.
     *
     *   feedback.doctor_id → doctors.id → users.name  (aliased doctor_name)
     *
     * If your schema differs, adjust the JOIN below accordingly.
     */
    public List<Feedback> getAllFeedback() {
        List<Feedback> feedbackList = new ArrayList<>();

        String sql = """
                SELECT f.id,
                       f.patient_id,
                       u.name  AS patient_name,
                       f.comment,
                       f.rating,
                       f.created_at
                FROM   feedback f
                JOIN   users u ON u.id = f.patient_id
                ORDER  BY f.created_at DESC
                """;

        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Feedback feedback = new Feedback();
                feedback.setId(rs.getInt("id"));
                feedback.setPatientId(rs.getInt("patient_id"));
                feedback.setPatientName(rs.getString("patient_name"));
                feedback.setComment(rs.getString("comment"));
                feedback.setRating(rs.getInt("rating"));
                feedback.setCreatedAt(rs.getTimestamp("created_at"));

                feedbackList.add(feedback);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return feedbackList;
    }

    // ── Delete a feedback by id ────────────────────────────────────────────

    public boolean deleteFeedback(int id) {
        String sql = "DELETE FROM feedback WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}