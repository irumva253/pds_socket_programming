package server;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet("/StudentInfoServlet")
public class StudentInfoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int SERVER_TIMEOUT_MS = 5000;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        long startTime = System.currentTimeMillis();
        String action = request.getParameter("action");
        String result = "";
        
        try {
            if (!InfoClient.isServerOnline()) {
                result = "ERROR:Central server is offline";
            } else {
                switch (action) {
                    case "email":
                        result = processEmailRequest(request);
                        break;
                    case "phone":
                        result = processPhoneRequest(request);
                        break;
                    case "list":
                        result = processListRequest(request);
                        break;
                    default:
                        result = "ERROR:Invalid action - must be email, phone, or list";
                }
            }
        } catch (Exception e) {
            result = "ERROR:Processing failed - " + e.getMessage();
            System.err.println("Error processing request: " + e.getMessage());
            e.printStackTrace();
        }
        
        long duration = System.currentTimeMillis() - startTime;
        System.out.println("Processed " + action + " request in " + duration + "ms");
        
        request.setAttribute("result", result);
        request.getRequestDispatcher("result.jsp").forward(request, response);
    }
    
    private String processEmailRequest(HttpServletRequest request) {
        String firstName = request.getParameter("emailFirstName");
        String lastName = request.getParameter("emailLastName");
        String lastNameOnly = request.getParameter("emailLastNameOnly");
        String deptId = request.getParameter("emailDeptId");
        
        if ((firstName != null && !firstName.isEmpty()) && 
            (lastName != null && !lastName.isEmpty())) {
            System.out.println("Searching by first+last: " + firstName + " " + lastName);
            return InfoClient.sendRequest("EMAIL:" + firstName.trim() + ":" + lastName.trim());
        } 
        else if ((lastNameOnly != null && !lastNameOnly.isEmpty()) && 
                 (deptId != null && !deptId.isEmpty())) {
            System.out.println("Searching by last+dept: " + lastNameOnly + " in " + deptId);
            return InfoClient.sendRequest("EMAIL:" + lastNameOnly.trim() + ":" + deptId.trim());
        }
        
        return "ERROR:Must provide either (first name AND last name) OR (last name AND department)";
    }
    
    private String processPhoneRequest(HttpServletRequest request) {
        String firstName = request.getParameter("phoneFirstName");
        String lastName = request.getParameter("phoneLastName");
        
        if (firstName == null || firstName.trim().isEmpty() || 
            lastName == null || lastName.trim().isEmpty()) {
            return "ERROR:Both first and last names are required";
        }
        
        System.out.println("Searching phone for: " + firstName + " " + lastName);
        return InfoClient.sendRequest("PHONE:" + firstName.trim() + ":" + lastName.trim());
    }
    
    private String processListRequest(HttpServletRequest request) {
        String deptId = request.getParameter("listDeptId");
        
        if (deptId == null || deptId.trim().isEmpty()) {
            return "ERROR:Department is required";
        }
        
        System.out.println("Listing students in department: " + deptId);
        return InfoClient.sendRequest("LIST:" + deptId.trim());
    }
}