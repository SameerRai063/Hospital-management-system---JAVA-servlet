package Patient.Controller;

import Patient.Model.dao.PatientDAO;
import utils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;

@WebServlet("/receptionists/deletePatient")
public class DeletePatientReceptionistServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        // Validate id param
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/patients?error=missing_id");
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/patients?error=invalid_id");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            PatientDAO patientDAO = new PatientDAO(con);
            boolean deleted = patientDAO.deletePatient(userId);

            if (deleted) {
                response.sendRedirect(request.getContextPath() + "/patients?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/patients?error=not_found");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/patients?error=delete_failed");
        }
    }
}