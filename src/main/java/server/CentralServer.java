package server;

import java.io.*;
import java.net.*;
import java.sql.*;

public class CentralServer {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/ur_soict?useSSL=false";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";
    private static final int SERVER_PORT = 5000;
    private static final int SOCKET_TIMEOUT = 30000;

    public static void main(String[] args) {
        System.out.println("Starting Central Server...");
        if (!testDatabaseConnection()) {
            System.out.println("Server startup aborted due to database connection failure");
            return;
        }

        try (ServerSocket serverSocket = new ServerSocket(SERVER_PORT)) {
            serverSocket.setSoTimeout(SOCKET_TIMEOUT);
            System.out.println("Server listening on port " + SERVER_PORT);
            
            while (true) {
                try {
                    Socket socket = serverSocket.accept();
                    socket.setSoTimeout(SOCKET_TIMEOUT);
                    new ClientHandler(socket).start();
                } catch (SocketTimeoutException e) {
                    System.out.println("Server accept timeout, continuing...");
                } catch (IOException ex) {
                    System.err.println("Error accepting connection: " + ex.getMessage());
                }
            }
        } catch (IOException ex) {
            System.err.println("Server exception: " + ex.getMessage());
            ex.printStackTrace();
        }
    }

    private static boolean testDatabaseConnection() {
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
            System.out.println("Database connected!");
            return tableExists(conn, "students") && tableExists(conn, "departments");
        } catch (SQLException e) {
            System.err.println("Database connection failed!");
            e.printStackTrace();
            return false;
        }
    }

    private static boolean tableExists(Connection conn, String tableName) throws SQLException {
        try (ResultSet rs = conn.getMetaData().getTables(null, null, tableName, null)) {
            return rs.next();
        }
    }

    static class ClientHandler extends Thread {
        private final Socket socket;
        
        public ClientHandler(Socket socket) {
            this.socket = socket;
        }
        
        public void run() {
            try (BufferedReader input = new BufferedReader(new InputStreamReader(socket.getInputStream()));
                 PrintWriter output = new PrintWriter(socket.getOutputStream(), true)) {
                
                String request = input.readLine();
                if (request == null || request.trim().isEmpty()) {
                    output.println("ERROR:Empty request");
                    return;
                }

                String response = processRequest(request);
                output.println(response);
                
            } catch (IOException ex) {
                System.err.println("Client error: " + ex.getMessage());
            } finally {
                try { socket.close(); } catch (IOException ex) { /* Ignore */ }
            }
        }

        private String processRequest(String request) {
            String[] parts = request.split(":");
            if (parts.length < 1) return "ERROR:Invalid request format";

            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
                switch (parts[0].toUpperCase()) {
                    case "EMAIL": return processEmailRequest(conn, parts);
                    case "PHONE": return processPhoneRequest(conn, parts);
                    case "LIST": return processListRequest(conn, parts);
                    case "PING": return "PONG";
                    default: return "ERROR:Unknown command";
                }
            } catch (SQLException e) {
                return "ERROR:Database error";
            }
        }

        private String processEmailRequest(Connection conn, String[] parts) throws SQLException {
            if (parts.length != 3) return "ERROR:Format: EMAIL:name:nameOrDept";
            
            try {
                int deptId = Integer.parseInt(parts[2]);
                String deptName = getDeptName(conn, deptId);
                if (deptName == null) return "ERROR:Department not found";
                
                try (PreparedStatement stmt = conn.prepareStatement(
                    "SELECT email FROM students WHERE last_name LIKE ? AND dept_id = ?")) {
                    stmt.setString(1, parts[1]);
                    stmt.setInt(2, deptId);
                    ResultSet rs = stmt.executeQuery();
                    return rs.next() ? "RESULT:" + rs.getString("email") 
                                     : "ERROR:No student '" + parts[1] + "' in " + deptName;
                }
            } catch (NumberFormatException e) {
                try (PreparedStatement stmt = conn.prepareStatement(
                    "SELECT email FROM students WHERE first_name LIKE ? AND last_name LIKE ?")) {
                    stmt.setString(1, parts[1]);
                    stmt.setString(2, parts[2]);
                    ResultSet rs = stmt.executeQuery();
                    return rs.next() ? "RESULT:" + rs.getString("email")
                                    : "ERROR:No student '" + parts[1] + " " + parts[2] + "'";
                }
            }
        }

        private String processPhoneRequest(Connection conn, String[] parts) throws SQLException {
            if (parts.length != 3) return "ERROR:Format: PHONE:firstName:lastName";
            
            try (PreparedStatement stmt = conn.prepareStatement(
                "SELECT phone FROM students WHERE first_name LIKE ? AND last_name LIKE ?")) {
                stmt.setString(1, parts[1]);
                stmt.setString(2, parts[2]);
                ResultSet rs = stmt.executeQuery();
                return rs.next() ? "RESULT:" + rs.getString("phone")
                                : "ERROR:No student '" + parts[1] + " " + parts[2] + "'";
            }
        }

        private String processListRequest(Connection conn, String[] parts) throws SQLException {
            if (parts.length != 2) return "ERROR:Format: LIST:deptId";
            
            try {
                int deptId = Integer.parseInt(parts[1]);
                String deptName = getDeptName(conn, deptId);
                if (deptName == null) return "ERROR:Department not found";
                
                try (PreparedStatement stmt = conn.prepareStatement(
                    "SELECT first_name, last_name FROM students WHERE dept_id = ? ORDER BY last_name")) {
                    stmt.setInt(1, deptId);
                    ResultSet rs = stmt.executeQuery();
                    
                    StringBuilder sb = new StringBuilder("RESULT:");
                    while (rs.next()) {
                        sb.append(rs.getString("first_name")).append(" ")
                          .append(rs.getString("last_name")).append(";");
                    }
                    return sb.length() > 7 ? sb.toString() 
                                          : "ERROR:No students in " + deptName;
                }
            } catch (NumberFormatException e) {
                return "ERROR:Department ID must be a number";
            }
        }

        private String getDeptName(Connection conn, int deptId) throws SQLException {
            try (PreparedStatement stmt = conn.prepareStatement(
                "SELECT dept_name FROM departments WHERE dept_id = ?")) {
                stmt.setInt(1, deptId);
                ResultSet rs = stmt.executeQuery();
                return rs.next() ? rs.getString("dept_name") : null;
            }
        }
    }
}