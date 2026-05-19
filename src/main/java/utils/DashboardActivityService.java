package utils;

import jakarta.servlet.http.HttpServletRequest;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class DashboardActivityService {
    private static final DateTimeFormatter LABEL_FORMAT = DateTimeFormatter.ofPattern("MMM d");

    private DashboardActivityService() {
    }

    public static void attachRecentActivity(Connection con, HttpServletRequest request) throws SQLException {
        List<String> labels = new ArrayList<>();
        List<Integer> counts = new ArrayList<>();
        List<Double> revenue = new ArrayList<>();
        int max = 0;
        int total = 0;
        double maxRevenue = 0;
        double totalRevenue = 0;

        for (int i = 6; i >= 0; i--) {
            LocalDate day = LocalDate.now().minusDays(i);
            int count = countForDay(con, day);
            double revenueForDay = revenueForDay(con, day);
            labels.add(day.format(LABEL_FORMAT));
            counts.add(count);
            revenue.add(revenueForDay);
            total += count;
            totalRevenue += revenueForDay;
            max = Math.max(max, count);
            maxRevenue = Math.max(maxRevenue, revenueForDay);
        }

        request.setAttribute("activityLabels", labels);
        request.setAttribute("activityCounts", counts);
        request.setAttribute("activityMax", Math.max(max, 1));
        request.setAttribute("activityTotal", total);
        request.setAttribute("revenueCounts", revenue);
        request.setAttribute("revenueMax", Math.max(maxRevenue, 1));
        request.setAttribute("revenueTotal", totalRevenue);
    }

    private static int countForDay(Connection con, LocalDate day) throws SQLException {
        String sql = """
                SELECT
                  (SELECT COUNT(*) FROM users WHERE DATE(created_at) = ? AND role IN ('doctor', 'patient', 'receptionist')) +
                  (SELECT COUNT(*) FROM appointments WHERE DATE(created_at) = ?) +
                  (SELECT COUNT(*) FROM payments WHERE DATE(created_at) = ?) +
                  (SELECT COUNT(*) FROM feedback WHERE DATE(created_at) = ?) AS activity_count
                """;

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            Date sqlDate = Date.valueOf(day);
            ps.setDate(1, sqlDate);
            ps.setDate(2, sqlDate);
            ps.setDate(3, sqlDate);
            ps.setDate(4, sqlDate);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt("activity_count") : 0;
            }
        }
    }

    private static double revenueForDay(Connection con, LocalDate day) throws SQLException {
        String sql = """
                SELECT COALESCE(SUM(amount), 0) AS revenue
                FROM payments
                WHERE DATE(created_at) = ?
                  AND payment_status = 'completed'
                """;

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(day));

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getDouble("revenue") : 0;
            }
        }
    }
}
