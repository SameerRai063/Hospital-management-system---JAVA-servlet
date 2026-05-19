import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.mindrot.jbcrypt.BCrypt;
import utils.DBConnection;

public class DatabaseSeeder {

    public static void main(String[] args) {

        try {
            String seedName = requireEnv("CURECLOUD_SEED_DOCTOR_NAME");
            String seedGender = requireEnv("CURECLOUD_SEED_DOCTOR_GENDER");
            String seedDob = requireEnv("CURECLOUD_SEED_DOCTOR_DOB");
            String seedAddress = requireEnv("CURECLOUD_SEED_DOCTOR_ADDRESS");
            String seedPhone = requireEnv("CURECLOUD_SEED_DOCTOR_PHONE");
            String seedEmail = requireEnv("CURECLOUD_SEED_DOCTOR_EMAIL");
            String seedPassword = requireEnv("CURECLOUD_SEED_DOCTOR_PASSWORD");
            String seedStatus = requireEnv("CURECLOUD_SEED_DOCTOR_STATUS");
            String seedQualifications = requireEnv("CURECLOUD_SEED_DOCTOR_QUALIFICATIONS");
            String seedDepartment = requireEnv("CURECLOUD_SEED_DOCTOR_DEPARTMENT");
            int seedExperienceYears = Integer.parseInt(requireEnv("CURECLOUD_SEED_DOCTOR_EXPERIENCE_YEARS"));

            Connection con = DBConnection.getConnection();
            con.setAutoCommit(false);


            String userSql = "INSERT INTO users " +
                    "(name, gender, dob, address, phone, email, password, profile_image, role) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement userPs = con.prepareStatement(userSql, PreparedStatement.RETURN_GENERATED_KEYS);

            userPs.setString(1, seedName);
            userPs.setString(2, seedGender);
            userPs.setDate(3, java.sql.Date.valueOf(seedDob));
            userPs.setString(4, seedAddress);
            userPs.setString(5, seedPhone);
            userPs.setString(6, seedEmail);

            String hashedPassword = BCrypt.hashpw(seedPassword, BCrypt.gensalt());
            userPs.setString(7, hashedPassword);

            userPs.setString(8, null);
            userPs.setString(9, "doctor");

            userPs.executeUpdate();

            // Get generated user ID
            ResultSet rs = userPs.getGeneratedKeys();
            int userId = 0;

            if (rs.next()) {
                userId = rs.getInt(1);
            }


            String doctorSql = "INSERT INTO doctor " +
                    "(user_id, status, qualifications, department, experience_years) " +
                    "VALUES (?, ?, ?, ?, ?)";

            PreparedStatement docPs = con.prepareStatement(doctorSql);

            docPs.setInt(1, userId);
            docPs.setString(2, seedStatus);
            docPs.setString(3, seedQualifications);
            docPs.setString(4, seedDepartment);
            docPs.setInt(5, seedExperienceYears);

            docPs.executeUpdate();

            con.commit();

            System.out.println("Doctor user created successfully with ID: " + userId);

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static String requireEnv(String key) {
        String value = System.getenv(key);
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalStateException(key + " is required to run DatabaseSeeder.");
        }
        return value.trim();
    }
}
