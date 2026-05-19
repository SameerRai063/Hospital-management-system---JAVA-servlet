package Patient.Controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import utils.DBConnection;
import Patient.Model.Patient;
import Patient.Model.dao.PatientDAO;

@WebServlet("/patients")
public class ViewPatientsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 1. Get connection
            Connection con = DBConnection.getConnection();

            // 2. Pass connection to DAO
            PatientDAO patientDAO = new PatientDAO(con);

            String search = request.getParameter("search");
            List<Patient> patients = patientDAO.searchPatients(search);

            // 4. Send to JSP
            request.setAttribute("patientList", patients);
            request.setAttribute("search", search);
            request.setAttribute("currentDate", java.time.LocalDate.now());
            request.getRequestDispatcher("/admin/patients.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
