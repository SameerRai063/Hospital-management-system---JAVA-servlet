package utils;

import Doctor.Model.Doctor;
import Receptionist.Model.Receptionist;
import User.Model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLIntegrityConstraintViolationException;
import java.sql.Statement;

public class UserService {

    public int createDoctor(User user, Doctor doctor) {
        normalizeUser(user, "doctor", defaultImage(user.getProfileImage(), "default_doctor.png"));
        doctor.setUser(user);
        return saveUserAndDoctor(user, doctor);
    }

    public int createReceptionist(User user, Receptionist receptionist) {
        normalizeUser(user, "receptionist", defaultImage(user.getProfileImage(), "default_receptionist.png"));
        receptionist.setUser(user);
        return saveUserAndReceptionist(user, receptionist);
    }

    private void normalizeUser(User user, String role, String defaultProfileImage) {
        if (user == null) {
            throw new IllegalArgumentException("User details are required.");
        }
        if (user.getName() == null || user.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Name is required.");
        }
        if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
            throw new IllegalArgumentException("Email is required.");
        }
        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            throw new IllegalArgumentException("Password is required.");
        }

        user.setName(user.getName().trim());
        user.setEmail(user.getEmail().trim());
        user.setPassword(BCrypt.hashpw(user.getPassword().trim(), BCrypt.gensalt()));
        user.setRole(role);
        user.setProfileImage(defaultProfileImage);
    }

    private String defaultImage(String current, String fallback) {
        return (current != null && !current.trim().isEmpty()) ? current.trim() : fallback;
    }

    private int saveUserAndDoctor(User user, Doctor doctor) {
        return saveUserAndRole(user, (con, userId) -> {
            String sql = "INSERT INTO doctor (user_id, status, qualifications, department, experience_years) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setString(2, defaultText(doctor.getStatus(), "Active"));
                ps.setString(3, doctor.getQualifications());
                ps.setString(4, doctor.getDepartment());
                ps.setInt(5, doctor.getExperienceYears());
                ps.executeUpdate();
            }
        });
    }

    private int saveUserAndReceptionist(User user, Receptionist receptionist) {
        return saveUserAndRole(user, (con, userId) -> {
            String sql = "INSERT INTO receptionist (user_id, status) VALUES (?, ?)";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setString(2, defaultText(receptionist.getStatus(), "Active"));
                ps.executeUpdate();
            }
        });
    }

    private int saveUserAndRole(User user, RoleInsert roleInsert) {
        String userSql = "INSERT INTO users (name, gender, dob, address, phone, email, password, role, profile_image) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection()) {
            boolean originalAutoCommit = con.getAutoCommit();
            con.setAutoCommit(false);

            try {
                int userId;
                ensureEmailIsAvailable(con, user.getEmail());
                try (PreparedStatement ps = con.prepareStatement(userSql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, user.getName());
                    ps.setString(2, user.getGender());
                    ps.setDate(3, user.getDob());
                    ps.setString(4, user.getAddress());
                    ps.setString(5, user.getPhone());
                    ps.setString(6, user.getEmail());
                    ps.setString(7, user.getPassword());
                    ps.setString(8, user.getRole());
                    ps.setString(9, user.getProfileImage());
                    ps.executeUpdate();

                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (!rs.next()) {
                            throw new IllegalStateException("Unable to create user record.");
                        }
                        userId = rs.getInt(1);
                    }
                }

                user.setId(userId);
                roleInsert.insert(con, userId);
                con.commit();
                return userId;
            } catch (Exception e) {
                con.rollback();
                if (e instanceof SQLIntegrityConstraintViolationException) {
                    throw new IllegalArgumentException("An account with this email already exists.", e);
                }
                if (e instanceof IllegalArgumentException) {
                    throw (IllegalArgumentException) e;
                }
                throw new RuntimeException(rootMessage(e), e);
            } finally {
                con.setAutoCommit(originalAutoCommit);
            }
        } catch (RuntimeException e) {
            throw e;
        } catch (Exception e) {
            throw new RuntimeException("Database connection failed.", e);
        }
    }

    private String defaultText(String current, String fallback) {
        return (current != null && !current.trim().isEmpty()) ? current.trim() : fallback;
    }

    private void ensureEmailIsAvailable(Connection con, String email) throws Exception {
        String sql = "SELECT 1 FROM users WHERE email = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    throw new IllegalArgumentException("An account with this email already exists.");
                }
            }
        }
    }

    private String rootMessage(Throwable throwable) {
        Throwable current = throwable;
        while (current.getCause() != null) {
            current = current.getCause();
        }
        return current.getMessage() != null ? current.getMessage() : "Unable to create " + "user" + ".";
    }

    @FunctionalInterface
    private interface RoleInsert {
        void insert(Connection con, int userId) throws Exception;
    }
}
