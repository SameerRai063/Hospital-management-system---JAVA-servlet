package Doctor.Controller;

import Doctor.Model.dao.DoctorDAO;
import utils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;

@WebServlet("/receptionists/deleteDoctor")
public class deleteDoctorReceptionistServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        // 1. Validate the ID parameter
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/doctors?error=missing_id");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            int userId = Integer.parseInt(idParam.trim());

            // 2. Initialize DAO
            DoctorDAO doctorDAO = new DoctorDAO(con);

            // 3. Perform the transaction-safe deletion
            boolean isDeleted = doctorDAO.deleteDoctor(userId);

            if (isDeleted) {
                // 4. Redirect back with success message
                response.sendRedirect(request.getContextPath() + "/doctors?success=deleted");
            } else {
                // Case where the ID wasn't found in the database
                response.sendRedirect(request.getContextPath() + "/doctors?error=not_found");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/doctors?error=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            // Handle DB errors or foreign key violations
            response.sendRedirect(request.getContextPath() + "/doctors?error=delete_failed");
        }
    }
}