package com.hospital.hospitalmanagementsystem.rating.util;

import User.Model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class AuthUtil {

    /**
     * Check if user is logged in
     */
    public static boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }

        if (session.getAttribute("userId") != null) {
            return true;
        }

        return session.getAttribute("loggedInUser") instanceof User;
    }

    /**
     * Get user ID from session
     */
    public static Integer getUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object userId = session.getAttribute("userId");
            if (userId instanceof Integer) {
                return (Integer) userId;
            }
            if (userId instanceof Number) {
                return ((Number) userId).intValue();
            }

            Object loggedInUser = session.getAttribute("loggedInUser");
            if (loggedInUser instanceof User) {
                return ((User) loggedInUser).getId();
            }
        }
        return null;
    }

    /**
     * Get user role from session
     */
    public static String getUserRole(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object role = session.getAttribute("role");
            if (role instanceof String && !((String) role).isBlank()) {
                return (String) role;
            }

            Object loggedInUser = session.getAttribute("loggedInUser");
            if (loggedInUser instanceof User) {
                return ((User) loggedInUser).getRole();
            }
        }
        return null;
    }

    /**
     * Check if user is ADMIN
     */
    public static boolean isAdmin(HttpServletRequest request) {
        return "ADMIN".equals(getUserRole(request));
    }

    /**
     * Check if user is DOCTOR
     */
    public static boolean isDoctor(HttpServletRequest request) {
        return "DOCTOR".equals(getUserRole(request));
    }

    /**
     * Check if user is PATIENT
     */
    public static boolean isPatient(HttpServletRequest request) {
        return "PATIENT".equals(getUserRole(request));
    }

    /**
     * Check if user is RECEPTIONIST
     */
    public static boolean isReceptionist(HttpServletRequest request) {
        return "RECEPTIONIST".equals(getUserRole(request));
    }

    /**
     * Resolve the dashboard page for the current role.
     */
    public static String getDashboardPath(HttpServletRequest request) {
        String role = getUserRole(request);
        if (role == null) {
            return "/index.jsp";
        }

        switch (role.toUpperCase()) {
            case "ADMIN":
                return "/admin_dashboard.jsp";
            case "DOCTOR":
                return "/doctor_dashboard.jsp";
            case "RECEPTIONIST":
                return "/receptionist_dashboard.jsp";
            case "PATIENT":
                return "/patient_dashboard.jsp";
            default:
                return "/index.jsp";
        }
    }

    /**
     * Get username from session
     */
    public static String getUsername(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object username = session.getAttribute("username");
            if (username instanceof String && !((String) username).isBlank()) {
                return (String) username;
            }

            Object loggedInUser = session.getAttribute("loggedInUser");
            if (loggedInUser instanceof User) {
                User user = (User) loggedInUser;
                return user.getEmail() != null ? user.getEmail() : user.getName();
            }
        }
        return null;
    }
}

