<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="server.InfoClient" %>
<% boolean serverOnline = InfoClient.isServerOnline(); %>
<!DOCTYPE html>
<html>
<head>
    <title>School of ICT Information System</title>
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
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
        }
        input[type="text"], select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }
        .btn {
            background-color: #3498db;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
            transition: background-color 0.3s;
        }
        .btn:hover {
            background-color: #2980b9;
        }
        .tab {
            display: none;
            animation: fadeIn 0.3s ease;
        }
        .tab.active {
            display: block;
        }
        .tab-nav {
            display: flex;
            margin-bottom: 20px;
            border-bottom: 1px solid #ddd;
        }
        .tab-link {
            padding: 10px 20px;
            cursor: pointer;
            background: #f1f1f1;
            margin-right: 5px;
            border-radius: 4px 4px 0 0;
            transition: all 0.3s ease;
        }
        .tab-link.active {
            background: #3498db;
            color: white;
        }
        .search-method {
            border: 1px solid #eee;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 15px;
        }
        .search-method h4 {
            margin-top: 0;
            color: #555;
        }
        .or-divider {
            text-align: center;
            margin: 15px 0;
            position: relative;
            color: #777;
            font-weight: bold;
        }
        .or-divider::before,
        .or-divider::after {
            content: "";
            position: absolute;
            height: 1px;
            background: #ddd;
            width: 45%;
            top: 50%;
        }
        .or-divider::before {
            left: 0;
        }
        .or-divider::after {
            right: 0;
        }
        .server-status {
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 4px;
            font-weight: bold;
            text-align: center;
        }
        .status-online {
            background-color: #d4edda;
            color: #155724;
        }
        .status-offline {
            background-color: #f8d7da;
            color: #721c24;
        }
        .error-message {
            color: #dc3545;
            font-size: 14px;
            margin-top: 5px;
            display: none;
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>School of ICT Information System</h1>
        
        <div class="server-status status-<%= serverOnline ? "online" : "offline" %>">
            Central Server: <%= serverOnline ? "ONLINE" : "OFFLINE" %>
        </div>
        
        <div class="tab-nav">
            <div class="tab-link active" data-tab="emailTab">Get Email</div>
            <div class="tab-link" data-tab="phoneTab">Get Phone</div>
            <div class="tab-link" data-tab="listTab">List Students</div>
        </div>
        
        <form id="infoForm" action="StudentInfoServlet" method="post" onsubmit="return validateForm()">
            <input type="hidden" name="action" id="actionField" value="email">
            
            <div id="emailTab" class="tab active">
                <div class="search-method">
                    <h4>Search by First and Last Name</h4>
                    <div class="form-group">
                        <label>First Name</label>
                        <input type="text" name="emailFirstName" id="emailFirstName" placeholder="Enter first name">
                        <div class="error-message" id="emailFirstNameError"></div>
                    </div>
                    <div class="form-group">
                        <label>Last Name</label>
                        <input type="text" name="emailLastName" id="emailLastName" placeholder="Enter last name">
                        <div class="error-message" id="emailLastNameError"></div>
                    </div>
                </div>
                
                <div class="or-divider">OR</div>
                
                <div class="search-method">
                    <h4>Search by Last Name and Department</h4>
                    <div class="form-group">
                        <label>Last Name</label>
                        <input type="text" name="emailLastNameOnly" id="emailLastNameOnly" placeholder="Enter last name">
                        <div class="error-message" id="emailLastNameOnlyError"></div>
                    </div>
                    <div class="form-group">
                        <label>Department</label>
                        <select name="emailDeptId" id="emailDeptId">
                            <option value="">Select Department</option>
                            <option value="1">Computer Science</option>
                            <option value="2">Information Technology</option>
                            <option value="3">Information Systems</option>
                        </select>
                        <div class="error-message" id="emailDeptIdError"></div>
                    </div>
                </div>
            </div>
            
            <div id="phoneTab" class="tab">
                <div class="form-group">
                    <label>First Name</label>
                    <input type="text" name="phoneFirstName" id="phoneFirstName" placeholder="Enter first name">
                    <div class="error-message" id="phoneFirstNameError"></div>
                </div>
                <div class="form-group">
                    <label>Last Name</label>
                    <input type="text" name="phoneLastName" id="phoneLastName" placeholder="Enter last name">
                    <div class="error-message" id="phoneLastNameError"></div>
                </div>
            </div>
            
            <div id="listTab" class="tab">
                <div class="form-group">
                    <label>Department</label>
                    <select name="listDeptId" id="listDeptId">
                        <option value="">Select Department</option>
                        <option value="1">Computer Science</option>
                        <option value="2">Information Technology</option>
                        <option value="3">Information Systems</option>
                    </select>
                    <div class="error-message" id="listDeptIdError"></div>
                </div>
            </div>
            
            <button type="submit" class="btn">Submit Request</button>
        </form>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <script>
    $(document).ready(function() {
        // Initialize tabs
        $('.tab-link').click(function() {
            // Get tab ID from data attribute
            const tabId = $(this).data('tab');
            
            // Remove active class from all tabs and links
            $('.tab, .tab-link').removeClass('active');
            
            // Add active class to clicked tab link
            $(this).addClass('active');
            
            // Show corresponding tab content
            $('#' + tabId).addClass('active');
            
            // Update hidden action field
            $('#actionField').val(tabId.replace('Tab', ''));
            
            // Clear all error messages when switching tabs
            $('.error-message').hide().text('');
        });

        // Clear the other search method when one is used
        $('#emailFirstName, #emailLastName').on('input', function() {
            if($(this).val().trim() !== '') {
                $('#emailLastNameOnly').val('');
                $('#emailDeptId').val('');
            }
        });

        $('#emailLastNameOnly, #emailDeptId').on('input change', function() {
            if($(this).val().trim() !== '') {
                $('#emailFirstName').val('');
                $('#emailLastName').val('');
            }
        });
    });

    function validateForm() {
        const action = $('#actionField').val();
        let isValid = true;
        
        // Clear previous errors
        $('.error-message').hide().text('');
        
        if (action === 'email') {
            const firstWayFilled = $('#emailFirstName').val().trim() !== '' && 
                                  $('#emailLastName').val().trim() !== '';
            const secondWayFilled = $('#emailLastNameOnly').val().trim() !== '' && 
                                  $('#emailDeptId').val() !== '';
            
            if (firstWayFilled && secondWayFilled) {
                $('#emailFirstNameError').text('Please use only one search method').show();
                $('#emailLastNameOnlyError').text('Please use only one search method').show();
                isValid = false;
            }
            else if (!firstWayFilled && !secondWayFilled) {
                $('#emailFirstNameError').text('Please use either first+last name OR last name+department').show();
                $('#emailLastNameOnlyError').text('Please use either first+last name OR last name+department').show();
                isValid = false;
            }
            else if (firstWayFilled) {
                // Validate first way
                if ($('#emailFirstName').val().trim() === '') {
                    $('#emailFirstNameError').text('First name is required').show();
                    isValid = false;
                }
                if ($('#emailLastName').val().trim() === '') {
                    $('#emailLastNameError').text('Last name is required').show();
                    isValid = false;
                }
            }
            else {
                // Validate second way
                if ($('#emailLastNameOnly').val().trim() === '') {
                    $('#emailLastNameOnlyError').text('Last name is required').show();
                    isValid = false;
                }
                if ($('#emailDeptId').val() === '') {
                    $('#emailDeptIdError').text('Department is required').show();
                    isValid = false;
                }
            }
        } 
        else if (action === 'phone') {
            if ($('#phoneFirstName').val().trim() === '') {
                $('#phoneFirstNameError').text('First name is required').show();
                isValid = false;
            }
            if ($('#phoneLastName').val().trim() === '') {
                $('#phoneLastNameError').text('Last name is required').show();
                isValid = false;
            }
        } 
        else if (action === 'list') {
            if ($('#listDeptId').val() === '') {
                $('#listDeptIdError').text('Department is required').show();
                isValid = false;
            }
        }
        
        if (!isValid) {
            // Scroll to first error
            $('html, body').animate({
                scrollTop: $('.error-message:visible').first().offset().top - 20
            }, 500);
        }
        
        return isValid;
    }
    </script>
</body>
</html>