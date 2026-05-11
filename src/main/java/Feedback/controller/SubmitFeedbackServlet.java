package Feedback.controller;

import Feedback.Model.Feedback;
import Feedback.dao.FeedbackDAO;
import com.hospital.hospitalmanagementsystem.rating.util.AuthUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "SubmitFeedbackServlet", urlPatterns = {"/submitFeedback"})
public class SubmitFeedbackServlet extends HttpServlet {

    private FeedbackDAO dao = new FeedbackDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            if (!AuthUtil.isLoggedIn(request)) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please%20login");
                return;
            }

            int appointmentId = Integer.parseInt(request.getParameter("appointment_id"));
            int doctorId = Integer.parseInt(request.getParameter("doctor_id"));
            int patientId = AuthUtil.getUserId(request) != null ? AuthUtil.getUserId(request) : Integer.parseInt(request.getParameter("patient_id"));
            String comment = request.getParameter("comment");
            int rating = Integer.parseInt(request.getParameter("rating"));

            Feedback f = new Feedback(appointmentId, patientId, doctorId, comment, rating);
            boolean ok = dao.addFeedback(f);
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Feedback%20submitted");
            } else {
                response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Failed%20to%20submit%20feedback");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Server%20error");
        }
    }
}

