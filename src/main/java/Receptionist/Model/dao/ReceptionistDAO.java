package Receptionist.Model.dao;

import Receptionist.Model.Receptionist;
import User.Model.User;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReceptionistDAO implements ReceptionistInterface {

    private Connection con;

    public ReceptionistDAO(Connection con) {
        this.con = con;
    }

    @Override
    public Receptionist getReceptionistById(int userId) throws Exception {
        String sql = "SELECT u.id, u.name AS name, u.gender, u.dob, u.address, u.phone, u.email, " +
                "u.profile_image, u.role, u.created_at, u.updated_at, " +
                "r.status " +
                "FROM users u INNER JOIN receptionist r ON u.id = r.user_id " +
                "WHERE u.id = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setName(rs.getString("name"));
                    user.setGender(rs.getString("gender"));
                    user.setDob(rs.getDate("dob"));
                    user.setAddress(rs.getString("address"));
                    user.setPhone(rs.getString("phone"));
                    user.setEmail(rs.getString("email"));
                    user.setProfileImage(rs.getString("profile_image"));
                    user.setRole(rs.getString("role"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    user.setUpdatedAt(rs.getTimestamp("updated_at"));

                    Receptionist receptionist = new Receptionist();
                    receptionist.setUserId(rs.getInt("id"));
                    receptionist.setStatus(rs.getString("status"));
                    receptionist.setUser(user);

                    return receptionist;
                }
            }
        }
        return null;
    }
@Override
public boolean addReceptionist(Receptionist receptionist) throws Exception {
    if (receptionist == null || receptionist.getUser() == null) {
        throw new IllegalArgumentException("Receptionist and User details are required.");
    }

    User user = receptionist.getUser();

    // Validate required fields
    if (user.getName() == null || user.getName().trim().isEmpty()) {
        throw new IllegalArgumentException("Name is required.");
    }
    if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
        throw new IllegalArgumentException("Email is required.");
    }
    if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
        throw new IllegalArgumentException("Password is required.");
    }

    boolean originalAutoCommit = con.getAutoCommit();
    try {
        con.setAutoCommit(false); // start transaction

        String safeName = user.getName().trim();
        String safeEmail = user.getEmail().trim();
        String hashedPassword = BCrypt.hashpw(user.getPassword().trim(), BCrypt.gensalt());
        String profileImage = user.getProfileImage() != null && !user.getProfileImage().isEmpty() ? user.getProfileImage() : "default.png";

        // Step 1: Insert user
        String userSQL = "INSERT INTO users (name, gender, dob, address, phone, email, password, role, profile_image) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement psUser = con.prepareStatement(userSQL, Statement.RETURN_GENERATED_KEYS)) {
            psUser.setString(1, safeName);
            psUser.setString(2, user.getGender());
            psUser.setDate(3, user.getDob());
            psUser.setString(4, user.getAddress());
            psUser.setString(5, user.getPhone());
            psUser.setString(6, safeEmail);
            psUser.setString(7, hashedPassword);
            psUser.setString(8, "receptionist");
            psUser.setString(9, profileImage);
            psUser.executeUpdate();

            // Get generated user ID
            try (ResultSet rs = psUser.getGeneratedKeys()) {
                if (!rs.next()) {
                    con.rollback();
                    return false;
                }
                int userId = rs.getInt(1);

                // Step 2: Insert receptionist details
                String receptionistSQL = "INSERT INTO receptionist (user_id, status) " +
                        "VALUES (?, ?)";
                try (PreparedStatement psReceptionist = con.prepareStatement(receptionistSQL)) {
                    psReceptionist.setInt(1, userId);
                    psReceptionist.setString(2, receptionist.getStatus() != null && !receptionist.getStatus().isEmpty() ? receptionist.getStatus() : "Active");
                    psReceptionist.executeUpdate();
                }
            }
        }

        con.commit();
        return true;

    } catch (Exception e) {
        if (con != null) {
            con.rollback();
        }
        throw e;
    } finally {
        if (con != null) {
            con.setAutoCommit(originalAutoCommit);
        }
    }
}
    @Override
    public List<Receptionist> getAllReceptionists() throws Exception {
        List<Receptionist> receptionists = new ArrayList<>();

        // SQL JOIN to fetch User details AND Receptionist details
        String sql = "SELECT u.id, u.name AS name, u.gender, u.dob, u.address, u.phone, u.email, " +
                "u.profile_image, u.role, u.created_at, u.updated_at, " +
                "r.status " +
                "FROM users u " +
                "INNER JOIN receptionist r ON u.id = r.user_id";

        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            // 1. Build the User object
            User user = new User();
            user.setId(rs.getInt("id"));
            user.setName(rs.getString("name"));
            user.setGender(rs.getString("gender"));
            user.setDob(rs.getDate("dob"));
            user.setAddress(rs.getString("address"));
            user.setPhone(rs.getString("phone"));
            user.setEmail(rs.getString("email"));
            user.setProfileImage(rs.getString("profile_image"));
            user.setRole(rs.getString("role"));
            user.setCreatedAt(rs.getTimestamp("created_at"));
            user.setUpdatedAt(rs.getTimestamp("updated_at"));

            // 2. Build the Receptionist object
            Receptionist receptionist = new Receptionist();
            receptionist.setUserId(rs.getInt("id"));
            receptionist.setStatus(rs.getString("status"));

            // 3. Attach User to Receptionist (Composition)
            receptionist.setUser(user);

            // 4. Add to list
            receptionists.add(receptionist);
        }

        return receptionists;
    }
    @Override
    public boolean deleteReceptionist(int userId) throws Exception {
        // Delete from receptionist first (child), then users (parent) to respect FK constraint
        String deleteReceptionistSQL = "DELETE FROM receptionist WHERE user_id = ?";
        String deleteUserSQL         = "DELETE FROM users WHERE id = ?";

        boolean originalAutoCommit = con.getAutoCommit();

        try {
            con.setAutoCommit(false); // start transaction

            // Step 1: delete from receptionist table
            try (PreparedStatement psReceptionist = con.prepareStatement(deleteReceptionistSQL)) {
                psReceptionist.setInt(1, userId);
                int rows = psReceptionist.executeUpdate();
                if (rows == 0) {
                    con.rollback();
                    return false; // no receptionist found with that ID
                }
            }

            // Step 2: delete from users table
            try (PreparedStatement psUser = con.prepareStatement(deleteUserSQL)) {
                psUser.setInt(1, userId);
                int rows = psUser.executeUpdate();
                if (rows == 0) {
                    con.rollback();
                    return false; // user row not found
                }
            }

            con.commit(); // both deletes succeeded
            return true;

        } catch (Exception e) {
            if (con != null) {
                con.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (con != null) {
                con.setAutoCommit(originalAutoCommit);
            }
        }
    }
    @Override
    public boolean updateReceptionistProfile(Receptionist receptionist, String currentPassword, String newPassword) throws Exception {
        if (receptionist.getUser() == null) {
            System.err.println("User object is missing from Receptionist.");
            return false;
        }

        String checkAuthQuery = "SELECT password FROM users WHERE id = ?";
        String updateUserQuery = "UPDATE users SET name = ?, email = ?, phone = ?, address = ?, password = ?, profile_image = ? WHERE id = ?";
        String updateReceptionistQuery = "UPDATE receptionist SET status = ? WHERE user_id = ?";

        boolean originalAutoCommit = con.getAutoCommit();

        try {
            // 1. Verify Current Password
            try (PreparedStatement checkStmt = con.prepareStatement(checkAuthQuery)) {
                checkStmt.setInt(1, receptionist.getUserId());
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) {
                        String dbPassword = rs.getString("password");
                        if (!dbPassword.equals(currentPassword)) {
                            System.err.println("Update Failed: Current password does not match.");
                            return false;
                        }
                    } else {
                        return false;
                    }
                }
            }

            // 2. Begin Transaction
            con.setAutoCommit(false);

            String passwordToSave = (newPassword != null && !newPassword.trim().isEmpty())
                    ? newPassword
                    : currentPassword;

            // 3. Update 'users' table
            try (PreparedStatement userStmt = con.prepareStatement(updateUserQuery)) {
                userStmt.setString(1, receptionist.getUser().getName());
                userStmt.setString(2, receptionist.getUser().getEmail());
                userStmt.setString(3, receptionist.getUser().getPhone());
                userStmt.setString(4, receptionist.getUser().getAddress());
                userStmt.setString(5, passwordToSave);
                userStmt.setString(6, receptionist.getUser().getProfileImage()); // Injecting the image filename
                userStmt.setInt(7, receptionist.getUserId());

                int userRowsAffected = userStmt.executeUpdate();
                if (userRowsAffected == 0) {
                    con.rollback();
                    return false;
                }
            }

            // 4. Update 'receptionist' table
            try (PreparedStatement repStmt = con.prepareStatement(updateReceptionistQuery)) {
                repStmt.setString(1, receptionist.getStatus());
                repStmt.setInt(2, receptionist.getUserId());

                int repRowsAffected = repStmt.executeUpdate();
                if (repRowsAffected == 0) {
                    con.rollback();
                    return false;
                }
            }

            // 5. Commit Transaction
            con.commit();
            return true;

        } catch (Exception e) {
            con.rollback();
            e.printStackTrace();
            throw e;
        } finally {
            con.setAutoCommit(originalAutoCommit);
        }
    }
    @Override
    public int getTotalReceptionists() throws Exception {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'receptionist'";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    @Override
    public int countActiveReceptionists() {

        int count = 0;

        String sql = "SELECT COUNT(*) FROM receptionist WHERE status = ?";

        try {

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, "active");

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }
    @Override
    public int countOnLeaveReceptionists() {

        int count = 0;

        String sql = "SELECT COUNT(*) FROM receptionist WHERE status = ?";

        try {

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, "on leave");

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }
}
