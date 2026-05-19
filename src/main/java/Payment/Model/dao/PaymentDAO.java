package Payment.Model.dao;

import Payment.Model.Payment;
import Patient.Model.Patient;
import User.Model.User;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO implements PaymentInterface {
    private Connection con;
    public  PaymentDAO(Connection con) {
        this.con = con;
    }


    public double getTotalRevenue() throws Exception {
        // COALESCE handles the case where the payment table is empty (SUM returns NULL)
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM payments WHERE payment_status = 'completed'";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getDouble(1) : 0.0;
        }
    }
    public List<Payment> getAllPayments() {
        return getPayments(null);
    }

    public List<Payment> getPayments(String searchTerm) {

        List<Payment> paymentList = new ArrayList<>();

        String sql = "SELECT p.id, p.patient_id, p.appointment_id, p.amount, p.payment_method, " +
                "p.payment_status, p.created_at, p.updated_at, u.id AS user_id, u.name " +
                "FROM payments p " +
                "JOIN patient pt ON p.patient_id = pt.user_id " +
                "JOIN users u ON pt.user_id = u.id ";

        boolean hasSearch = searchTerm != null && !searchTerm.trim().isEmpty();
        if (hasSearch) {
            sql += "WHERE u.name LIKE ? OR CAST(p.patient_id AS CHAR) LIKE ? OR CAST(p.appointment_id AS CHAR) LIKE ? " +
                    "OR CAST(p.id AS CHAR) LIKE ? OR CAST(p.amount AS CHAR) LIKE ? OR p.payment_status LIKE ? " +
                    "OR DATE_FORMAT(p.created_at, '%Y-%m-%d') LIKE ? ";
        }

        sql += "ORDER BY p.created_at DESC";

        try {

            PreparedStatement ps = con.prepareStatement(sql);
            if (hasSearch) {
                String like = "%" + searchTerm.trim() + "%";
                for (int i = 1; i <= 7; i++) {
                    ps.setString(i, like);
                }
            }
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                // Create User object
                User user = new User();
                user.setId(rs.getInt("user_id"));
                user.setName(rs.getString("name"));

                // Create Patient object
                Patient patient = new Patient();
                patient.setUserId(rs.getInt("patient_id"));
                patient.setUser(user);

                // Create Payment object
                Payment payment = new Payment();
                payment.setId(rs.getInt("id"));
                payment.setPatientId(rs.getInt("patient_id"));
                payment.setAppointmentId(rs.getInt("appointment_id"));
                payment.setAmount(rs.getBigDecimal("amount"));
                payment.setPaymentMethod(rs.getString("payment_method"));
                payment.setPaymentStatus(rs.getString("payment_status"));
                payment.setCreatedAt(rs.getTimestamp("created_at"));
                payment.setUpdatedAt(rs.getTimestamp("updated_at"));

                // Attach patient object
                payment.setPatient(patient);

                paymentList.add(payment);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return paymentList;
    }

    public int countPaymentsByStatus(String status) throws Exception {
        String sql = "SELECT COUNT(*) FROM payments WHERE payment_status = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public double getPendingAmount() throws Exception {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM payments WHERE payment_status = 'pending'";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getDouble(1) : 0.0;
        }
    }

    @Override
    public boolean addPayment(Payment payment) throws Exception {

        String sql = "INSERT INTO payments (patient_id, appointment_id, amount, payment_method, payment_status) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, payment.getPatientId());
            ps.setInt(2, payment.getAppointmentId());
            ps.setBigDecimal(3, payment.getAmount());
            ps.setString(4, "Cash");
            ps.setString(5, "pending");

            return ps.executeUpdate() > 0;
        }
    }
}
