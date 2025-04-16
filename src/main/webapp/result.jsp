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
        .result-title {
            font-weight: bold;
            margin-bottom: 10px;
        }
        .result-line {
            margin: 5px 0;
            padding: 3px 0;
            border-bottom: 1px solid #eee;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Request Result</h1>
        
        <div class="result-box ${result.startsWith('RESULT') ? 'success' : 'error'}">
            <% 
            String result = (String) request.getAttribute("result");
            if (result.startsWith("RESULT:")) {
                String[] items = result.substring(7).split(";");
                for (String item : items) {
                    if (!item.isEmpty()) {
            %>
                        <div class="result-line"><%= item %></div>
            <%
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