<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %> 
<%
    String loginMessage = "";

    if (request.getParameter("login") != null) {
        String email = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM user WHERE email=? AND password=?");
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String userRole = rs.getString("role");
                String userEmail = rs.getString("email");

                
                session.setAttribute("email", userEmail);
                session.setAttribute("role", userRole);

                if ("admin".equalsIgnoreCase(userRole)) {
                    response.sendRedirect("admin.jsp");
                } else {
                    response.sendRedirect("home.jsp");
                }
                return; 
            } else {
                loginMessage = "Invalid email or password.";
            }
        } catch (Exception e) {
            loginMessage = "Error: " + e.getMessage();
        }
    }

    String msg = (String) request.getAttribute("msg");
%>


<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Login Page</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

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

            .success {
                color: green;
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
            <h2>Login</h2>
            <form method="post">
                <input type="hidden" name="login" value="true">

                <div class="form-group">
                    <label for="username">Email</label>
                    <input type="email" id="username" name="username" required>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required>
                </div>

                <div class="form-group">
                    <label for="role">Role</label>
                    <select name="role" required>
                        <option value="user">User</option>
                        <option value="admin">Admin</option>
                    </select>
                </div>

                <button type="submit" class="login-btn">Login</button>

                <div class="footer">
                    <p>Don't have an account? <a href="register.jsp">Register</a></p>

                    <% if (!loginMessage.isEmpty()) {%>
                    <p class="error"><%= loginMessage%></p>
                    <% } %>

                    <% if (msg != null) {%>
                    <p class="success"><%= msg%></p>
                    <% }%>
                </div>
            </form>
        </div>
    </body>
</html>
