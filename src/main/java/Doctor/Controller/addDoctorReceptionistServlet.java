package Doctor.Controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Date;

import User.Model.User;
import Doctor.Model.Doctor;
import utils.UserService;

@WebServlet("/receptionists/add-doctor")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class addDoctorReceptionistServlet extends HttpServlet { // Changed to Uppercase

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
            user.setName(request.getParameter("name") != null ? request.getParameter("name").trim() : null);
            user.setEmail(request.getParameter("email") != null ? request.getParameter("email").trim() : null);
            user.setPassword(request.getParameter("password") != null ? request.getParameter("password").trim() : null);
            user.setPhone(request.getParameter("phone") != null ? request.getParameter("phone").trim() : null);
            user.setGender(request.getParameter("gender") != null ? request.getParameter("gender").trim() : null);
            user.setAddress(request.getParameter("address") != null ? request.getParameter("address").trim() : null);
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
                response.sendRedirect(request.getContextPath() + "/Receptionist-dashboard?success=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/Recepionsit-dashboard?error=failed");
            }

        } catch (Exception e) {
            String message = java.net.URLEncoder.encode(e.getMessage() != null ? e.getMessage() : "Unable to save doctor.", java.nio.charset.StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/Receptionist-dashboard?error=exception&message=" + message);
        }
    }
}