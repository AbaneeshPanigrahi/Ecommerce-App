<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>
<%    String regMessage = "";
    if (request.getParameter("register") != null) {
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String gender = request.getParameter("gender");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");

        if ("admin".equals(role)) {
            regMessage = "Invalid Admin Security Key!";
        } else {
            try {
                PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO user(fullname, email, password, gender, phone, role) VALUES (?, ?, ?, ?, ?, ?)"
                );
                ps.setString(1, fullname);
                ps.setString(2, email);
                ps.setString(3, password);
                ps.setString(4, gender);
                ps.setString(5, phone);
                ps.setString(6, role);

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    request.setAttribute("msg", "Registration Successful! Please login.");
%><jsp:forward page="Login.jsp"/><%
                }
            } catch (SQLIntegrityConstraintViolationException e) {
                regMessage = "Email already exists!";
            } catch (Exception e) {
                regMessage = "Error: " + e.getMessage();
            }
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Registration Page</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f0f4f8;
                color: #2c3e50;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                padding: 20px;
            }

            .container {
                background-color: #ffffff;
                padding: 40px 30px;
                border-radius: 8px;
                box-shadow: 0 0 15px rgba(0, 0, 0, 0.08);
                width: 100%;
                max-width: 450px;
            }

            h1, h2 {
                text-align: center;
                margin-bottom: 25px;
                color: #1a3c5d;
            }

            .form-group {
                margin-bottom: 18px;
            }

            .form-group label {
                display: block;
                margin-bottom: 6px;
                color: #555;
            }

            input[type="text"],
            input[type="email"],
            input[type="password"],
            select {
                width: 100%;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 4px;
                outline: none;
                transition: border-color 0.3s ease;
            }

            input[type="text"]:focus,
            input[type="email"]:focus,
            input[type="password"]:focus,
            select:focus {
                border-color: #007bff;
            }

            fieldset {
                border: none;
                margin-bottom: 15px;
            }

            fieldset label {
                margin-right: 10px;
            }

            input[type="submit"],
            .login-btn {
                width: 100%;
                background-color: #007bff;
                color: white;
                border: none;
                padding: 12px;
                font-size: 16px;
                border-radius: 4px;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }

            input[type="submit"]:hover,
            .login-btn:hover {
                background-color: #0056b3;
            }

            .footer {
                margin-top: 20px;
                text-align: center;
                font-size: 14px;
            }

            .footer a {
                color: #007bff;
                text-decoration: none;
            }

            .footer a:hover {
                text-decoration: underline;
            }

            .error {
                color: red;
                margin-top: 10px;
                text-align: center;
            }

            header, footer {
                text-align: center;
                margin-bottom: 20px;
                color: #555;
            }
        </style>

    </head>
    <body>
        <div class="container">
            <h2>Register</h2>
            <form method="post">
                <input type="hidden" name="register" value="true">

                <div class="form-group">
                    <label for="fullname">Full Name:</label>
                    <input type="text" id="fullname" name="fullname" required>
                </div>

                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" required>
                </div>

                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="password" id="password" name="password" required>
                </div>

                <fieldset>
                    <legend>Gender:</legend>
                    <input type="radio" id="male" name="gender" value="Male" required>
                    <label for="male">Male</label>
                    <input type="radio" id="female" name="gender" value="Female">
                    <label for="female">Female</label>
                    <input type="radio" id="other" name="gender" value="Other">
                    <label for="other">Other</label>
                </fieldset>

                <div class="form-group">
                    <label for="phone">Phone:</label>
                    <input type="text" id="phone" name="phone" pattern="[0-9]{10}" title="Enter a 10-digit phone number" required>
                </div>

                <div class="form-group">
                    <label for="role">Role:</label>
                    <select name="role" required>
                        <option value="user">User</option>
                        <option value="admin">Admin</option>
                    </select>
                </div>

                <input type="submit" value="Submit">
                <p class="error"><%= regMessage%></p>
                <div class="footer">
                    <p>Already registered? <a href="Login.jsp">Login here</a></p>
                </div>
            </form>
        </div>
    </body>

</html>
