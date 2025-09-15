<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    // Only admin can use this
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("admin")) {
        response.sendRedirect("Login.jsp");
        return;
    }

    int id = 0;
    String name = "";
    String description = "";
    double price = 0.0;
    String image_url = "";

    String sid = request.getParameter("id");
    if (sid != null) {
        id = Integer.parseInt(sid);
        try {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM products WHERE id=?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                name = rs.getString("name");
                description = rs.getString("description");
                price = rs.getDouble("price");
                image_url = rs.getString("image_url");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    } else {
        // invalid access, redirect
        response.sendRedirect("admin_products.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Product</title>
    <style>
        body { font-family: Arial; background: #f3f4f6; margin:0; padding:0; }
        .container {
            max-width:600px; margin: 30px auto; background:white;
            padding:20px; border-radius:8px; box-shadow:0px 3px 10px rgba(0,0,0,0.1);
        }
        h2 { color: #333; margin-bottom:20px; }
        form label { display:block; margin-top:10px; font-weight:bold; }
        form input, form textarea {
            width:100%; padding:8px; margin-top:5px;
            border:1px solid #ccc; border-radius:5px;
        }
        form button {
            margin-top:15px; padding:10px;
            background:#4f46e5; color:white;
            border:none; border-radius:5px; cursor:pointer;
        }
        form button:hover { background: #4338ca; }
        .back-btn {
            margin-top:10px; display:inline-block; text-decoration:none;
            padding:8px 12px; background:#10b981; color:white; border-radius:5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Edit Product</h2>
        <form action="updateProduct.jsp" method="post">
            <input type="hidden" name="id" value="<%= id %>">

            <label>Name:</label>
            <input type="text" name="name" value="<%= name %>" required>

            <label>Description:</label>
            <textarea name="description" rows="4"><%= description %></textarea>

            <label>Price:</label>
            <input type="number" step="0.01" name="price" value="<%= price %>" required>

            <label>Image URL:</label>
            <input type="text" name="image_url" value="<%= image_url %>">

            <button type="submit">Update Product</button>
        </form>

        <a href="admin_products.jsp" class="back-btn">Cancel</a>
    </div>
</body>
</html>
