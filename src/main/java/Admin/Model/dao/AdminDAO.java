package Admin.Model.dao;

import Admin.Model.Admin;
import User.Model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminDAO implements AdminInterface {

    private final Connection con;

    public AdminDAO(Connection con) {
        this.con = con;
    }

    @Override
    public List<Admin> getAllAdmins() throws Exception {
        List<Admin> admins = new ArrayList<>();
        String sql = "SELECT u.id, u.name AS name, u.gender, u.dob, u.address, u.phone, u.email, " +
                "u.profile_image, u.role, u.created_at, u.updated_at, a.last_login " +
                "FROM users u INNER JOIN admin a ON u.id = a.user_id WHERE u.role = 'admin'";

        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
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

                Admin admin = new Admin();
                admin.setUserId(rs.getInt("id"));
                admin.setLastLogin(rs.getTimestamp("last_login"));
                admin.setUser(user);

                admins.add(admin);
            }
        }

        return admins;
    }

    @Override
    public Admin getAdminById(int userId) throws Exception {
        String sql = "SELECT u.id, u.name AS name, u.gender, u.dob, u.address, u.phone, u.email, " +
                "u.profile_image, u.role, u.created_at, u.updated_at, a.last_login " +
                "FROM users u INNER JOIN admin a ON u.id = a.user_id WHERE u.id = ?";

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

                    Admin admin = new Admin();
                    admin.setUserId(rs.getInt("id"));
                    admin.setLastLogin(rs.getTimestamp("last_login"));
                    admin.setUser(user);

                    return admin;
                }
            }
        }
        return null;
    }

    @Override
    public boolean addAdmin(Admin admin) throws Exception {
        if (admin == null || admin.getUser() == null) {
            throw new IllegalArgumentException("Admin and User details are required.");
        }

        User user = admin.getUser();

        boolean originalAutoCommit = con.getAutoCommit();
        try {
            con.setAutoCommit(false);

            String insertUser = "INSERT INTO users (name, gender, dob, address, phone, email, password, role, profile_image) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = con.prepareStatement(insertUser, Statement.RETURN_GENERATED_KEYS)) {
                String safeName = (user.getName() != null) ? user.getName().trim() : "";
                ps.setString(1, safeName);
                ps.setString(2, user.getGender());
                ps.setDate(3, user.getDob());
                ps.setString(4, user.getAddress());
                ps.setString(5, user.getPhone());
                ps.setString(6, user.getEmail());
                ps.setString(7, BCrypt.hashpw(user.getPassword(), BCrypt.gensalt()));
                ps.setString(8, "admin");
                ps.setString(9, user.getProfileImage());
                ps.executeUpdate();

                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        int userId = keys.getInt(1);
                        String insertAdmin = "INSERT INTO admin (user_id, last_login) VALUES (?, NULL)";
                        try (PreparedStatement ps2 = con.prepareStatement(insertAdmin)) {
                            ps2.setInt(1, userId);
                            ps2.executeUpdate();
                        }
                    } else {
                        con.rollback();
                        return false;
                    }
                }
            }

            con.commit();
            return true;
        } catch (Exception e) {
            con.rollback();
            throw e;
        } finally {
            con.setAutoCommit(originalAutoCommit);
        }
    }

    @Override
    public boolean deleteAdmin(int userId) throws Exception {
        String deleteAdminSQL = "DELETE FROM admin WHERE user_id = ?";
        String deleteUserSQL = "DELETE FROM users WHERE id = ?";

        boolean originalAutoCommit = con.getAutoCommit();
        try {
            con.setAutoCommit(false);

            try (PreparedStatement psAdmin = con.prepareStatement(deleteAdminSQL)) {
                psAdmin.setInt(1, userId);
                int rows = psAdmin.executeUpdate();
                if (rows == 0) {
                    con.rollback();
                    return false;
                }
            }

            try (PreparedStatement psUser = con.prepareStatement(deleteUserSQL)) {
                psUser.setInt(1, userId);
                int rows = psUser.executeUpdate();
                if (rows == 0) {
                    con.rollback();
                    return false;
                }
            }

            con.commit();
            return true;
        } catch (Exception e) {
            con.rollback();
            throw e;
        } finally {
            con.setAutoCommit(originalAutoCommit);
        }
    }

    @Override
    public int getTotalAdmins() throws Exception {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'admin'";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
}

