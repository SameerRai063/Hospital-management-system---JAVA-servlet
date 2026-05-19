package Doctor.Controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Date;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import User.Model.User;
import Doctor.Model.Doctor;
import utils.UserService;

@WebServlet("/add-doctor")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class addDoctorServlet extends HttpServlet { // Changed to Uppercase

    private static final String UPLOAD_DIR = "uploads" + File.separator + "doctors";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // 1. Handle Image
            String fileName = "default_doctor.png";
            Part filePart = request.getPart("profileImage");
            if (filePart != null && filePart.getSize() > 0) {
                fileName = System.currentTimeMillis() + "_" + Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists() && !uploadDir.mkdirs()) {
                    throw new IOException("Unable to create doctor upload directory.");
                }
                filePart.write(uploadPath + File.separator + fileName);
            }

            // 2. Build User
            User user = new User();
            String name = request.getParameter("name") != null ? request.getParameter("name").trim() : null;
            String email = request.getParameter("email") != null ? request.getParameter("email").trim() : null;
            String password = request.getParameter("password") != null ? request.getParameter("password").trim() : null;
            String phone = request.getParameter("phone") != null ? request.getParameter("phone").trim() : null;
            String gender = request.getParameter("gender") != null ? request.getParameter("gender").trim() : null;
            String address = request.getParameter("address") != null ? request.getParameter("address").trim() : null;

            user.setName(name);
            user.setEmail(email);
            user.setPassword(password);
            user.setPhone(phone);
            user.setGender(gender);
            user.setAddress(address);
            user.setProfileImage(fileName);
            user.setRole("doctor");

            String dobStr = request.getParameter("dob");
            if (dobStr != null && !dobStr.isEmpty()) {
                user.setDob(Date.valueOf(dobStr));
            }

            // 3. Build Doctor
            Doctor doctor = new Doctor();
            doctor.setUser(user);
            doctor.setQualifications(request.getParameter("qualifications"));
            doctor.setDepartment(request.getParameter("department"));
            doctor.setStatus(request.getParameter("status")); // Will capture "Active" or "On Leave"

            String expStr = request.getParameter("experienceYears");
            doctor.setExperienceYears(expStr != null ? Integer.parseInt(expStr) : 0);

            // 4. DB operations via Hibernate
            UserService userService = new UserService();
            int userId = userService.createDoctor(user, doctor);

            if (userId > 0) {
                response.sendRedirect(request.getContextPath() + "/Admin-dashboard?success=doctor_added");
            } else {
                response.sendRedirect(request.getContextPath() + "/Admin-dashboard?error=doctor_failed");
            }

        } catch (IllegalArgumentException e) {
            String message = URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/Admin-dashboard?error=validation&message=" + message);
        } catch (Exception e) {
            String message = URLEncoder.encode(e.getMessage() != null ? e.getMessage() : "Unable to save doctor.", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/Admin-dashboard?error=exception&message=" + message);
        }
    }
}
