package Feedback.controller;

import Feedback.dao.FeedbackDAO;
import Feedback.Model.Feedback;
import com.hospital.hospitalmanagementsystem.rating.util.AuthUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewFeedbackServlet", urlPatterns = {"/ViewFeedbackServlet", "/feedbacks"})
public class ViewFeedbackServlet extends HttpServlet {

    private FeedbackDAO dao = new FeedbackDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            if (!AuthUtil.isLoggedIn(request)) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please%20login");
                return;
            }

            List<Feedback> feedbacks;
            if (AuthUtil.isAdmin(request)) {
                feedbacks = dao.getAllFeedback();
            } else if (AuthUtil.isDoctor(request)) {
                Integer id = AuthUtil.getUserId(request);
                if (id == null) { response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Please%20login%20again"); return; }
                feedbacks = dao.getFeedbackByDoctorId(id);
            } else {
                // patients: show their own feedback (not implemented separately) - show all as fallback
                feedbacks = dao.getAllFeedback();
            }

            request.setAttribute("feedbacks", feedbacks);
            request.getRequestDispatcher("/feedback/view-feedbacks.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Server%20error");
        }
    }
}

