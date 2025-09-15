<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    // Check admin session
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("admin")) {
        response.sendRedirect("Login.jsp");
        return;
    }

    String message = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String image_url = request.getParameter("image_url");

        try {
            double price = Double.parseDouble(priceStr);

            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO products (name, description, price, image_url) VALUES (?, ?, ?, ?)"
            );
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setDouble(3, price);
            ps.setString(4, image_url);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                message = "✅ Product added successfully!";
            } else {
                message = "⚠️ Failed to add product.";
            }
        } catch (Exception e) {
            message = "❌ Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Product</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f9fafb;
            margin: 0;
            padding: 0;
        }
        header {
            background-color: #4f46e5;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        header h1 { margin: 0; }
        .back, .logout {
            background-color: #10b981;
            border: none;
            color: white;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            margin-left: 10px;
        }
        .logout { background-color: #ef4444; }
        .container {
            max-width: 600px;
            margin: 40px auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        h2 { color: #333; }
        label {
            display: block;
            margin-bottom: 6px;
            font-weight: bold;
        }
        input, textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 5px;
            border: 1px solid #ddd;
        }
        button {
            background-color: #4f46e5;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
        }
        button:hover { background-color: #4338ca; }
        .message {
            margin-top: 15px;
            font-weight: bold;
            color: green;
        }
    </style>
</head>
<body>

<header>
    <h1>Add New Product</h1>
    <div>
        <a href="manage_products.jsp" class="back">📦 Manage Products</a>
        <a href="logout.jsp" class="logout">Logout</a>
    </div>
</header>

<div class="container">
    <h2>Enter Product Details</h2>

    <% if (!message.isEmpty()) { %>
        <p class="message"><%= message %></p>
    <% } %>

    <form method="post" action="">
        <label>Product Name:</label>
        <input type="text" name="name" required>

        <label>Description:</label>
        <textarea name="description" required></textarea>

        <label>Price (₹):</label>
        <input type="number" step="0.01" name="price" required>

        <label>Image URL:</label>
        <input type="text" name="image_url" placeholder="http://example.com/image.jpg">

        <button type="submit">Add Product</button>
    </form>
</div>

</body>
</html>
