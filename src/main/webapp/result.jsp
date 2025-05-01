<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Request Result</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 20px;
            color: #333;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        h1 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 30px;
        }
        .result-box {
            padding: 20px;
            border-radius: 4px;
            margin-bottom: 20px;
            font-size: 16px;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .btn {
            display: inline-block;
            background-color: #3498db;
            color: white;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 4px;
            text-align: center;
            transition: background-color 0.3s;
        }
        .btn:hover {
            background-color: #2980b9;
        }
        .department-header {
            font-weight: bold;
            font-size: 18px;
            margin-bottom: 10px;
            color: #2c3e50;
        }
        .student-item {
            margin: 8px 0;
            padding-left: 20px;
            text-indent: -20px;
        }
        .student-item:before {
            content: counter(student-counter) ". ";
            counter-increment: student-counter;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Request Result</h1>
        
        <div class="result-box ${result.startsWith('RESULT') ? 'success' : 'error'}">
            <% 
            String result = (String) request.getAttribute("result");
            String action = (String) request.getAttribute("action");
            
            if (result.startsWith("RESULT:")) {
                if ("list".equals(action)) {
                    String deptId = (String) request.getAttribute("deptId");
                    String deptName = "";
                    if ("1".equals(deptId)) deptName = "Computer Science";
                    else if ("2".equals(deptId)) deptName = "Information Technology";
                    else if ("3".equals(deptId)) deptName = "Information Systems";
            %>
                    <div class="department-header">Students in <%= deptName %> Department</div>
                    <div style="counter-reset: student-counter;">
                        <% 
                        String[] students = result.substring(7).split(";");
                        for (String student : students) {
                            if (!student.trim().isEmpty()) {
                        %>
                                <div class="student-item"><%= student %></div>
                        <%
                            }
                        }
                        %>
                    </div>
            <%
                } else {
                    // Original display for email/phone lookups
                    String[] items = result.substring(7).split(";");
                    for (String item : items) {
                        if (!item.isEmpty()) {
            %>
                            <div class="result-line"><%= item %></div>
            <%
                        }
                    }
                }
            } else {
            %>
                <div class="result-line"><%= result.substring(6) %></div>
            <%
            }
            %>
        </div>
        
        <a href="index.jsp" class="btn">Make Another Request</a>
    </div>
</body>
</html>