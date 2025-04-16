package server;

import java.io.*;
import java.net.*;

public class InfoClient {
    private static final String SERVER_IP = "localhost";
    private static final int SERVER_PORT = 5000;
    private static final int TIMEOUT_MS = 3000;

    public static String sendRequest(String request) {
        Socket socket = null;
        try {
            socket = new Socket();
            socket.connect(new InetSocketAddress(SERVER_IP, SERVER_PORT), TIMEOUT_MS);
            
            PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
            BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            
            out.println(request);
            String response = in.readLine();
            return response != null ? response : "ERROR:No response from server";
        } catch (SocketTimeoutException e) {
            return "ERROR:Connection timed out - Is server running?";
        } catch (ConnectException e) {
            return "ERROR:Connection refused - Server may be down";
        } catch (IOException e) {
            return "ERROR:Communication error - " + e.getMessage();
        } finally {
            if (socket != null) {
                try { socket.close(); } catch (IOException e) {}
            }
        }
    }

    public static boolean isServerOnline() {
        try (Socket socket = new Socket()) {
            socket.connect(new InetSocketAddress(SERVER_IP, SERVER_PORT), TIMEOUT_MS);
            return true;
        } catch (IOException e) {
            return false;
        }
    }
}