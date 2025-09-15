<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("admin")) {
        response.sendRedirect("Login.jsp");
        return;
    }

    int orderId = Integer.parseInt(request.getParameter("order_id"));

    ResultSet orderInfo = null;
    ResultSet items = null;

    try {
        // Order + User Info
        PreparedStatement ps1 = conn.prepareStatement(
            "SELECT o.id, o.total_amount, o.status, o.created_at, " +
            "u.fullname, u.email, u.phone, u.address " +
            "FROM orders o JOIN user u ON o.user_id = u.id WHERE o.id=?"
        );
        ps1.setInt(1, orderId);
        orderInfo = ps1.executeQuery();

        // Order Items
        PreparedStatement ps2 = conn.prepareStatement(
            "SELECT p.name, p.price, oi.quantity, (p.price * oi.quantity) AS subtotal " +
            "FROM order_items oi JOIN products p ON oi.id = p.id " +
            "WHERE oi.id=?"
        );
        ps2.setInt(1, orderId);
        items = ps2.executeQuery();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Order Details</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { font-family: Arial, sans-serif; background:#f4f6f9; margin:0; padding:20px; }
        h1 { text-align:center; margin-bottom:20px; color:#333; }

        .info-box { background:white; padding:20px; border-radius:8px; margin-bottom:20px;
                    box-shadow:0 2px 6px rgba(0,0,0,0.1); }
        .info-box h2 { margin-bottom:10px; color:#042352; }

        table { width:100%; border-collapse:collapse; background:white;
                box-shadow:0 2px 6px rgba(0,0,0,0.1); margin-top:10px; }
        th, td { padding:12px; border:1px solid #ddd; text-align:center; }
        th { background:#042352; color:white; }
        tr:hover { background:#f9f9f9; }

        .btn-back { display:inline-block; padding:8px 14px; margin-top:15px;
                    background:#027ef2; color:white; text-decoration:none; border-radius:5px; }
        .btn-back:hover { background:#025ec2; }
    </style>
</head>
<body>

<a href="manage_orders.jsp" class="btn-back"><i class="fas fa-arrow-left"></i> Back</a>
<h1>Order Details</h1>

<%
    if(orderInfo != null && orderInfo.next()){
%>
<div class="info-box">
    <h2>Order Info</h2>
    <p><strong>Order ID:</strong> <%= orderInfo.getInt("id") %></p>
    <p><strong>Status:</strong> <%= orderInfo.getString("status") %></p>
    <p><strong>Total Amount:</strong> ₹<%= orderInfo.getDouble("total_amount") %></p>
    <p><strong>Order Date:</strong> <%= orderInfo.getString("created_at") %></p>
</div>

<div class="info-box">
    <h2>Customer Info</h2>
    <p><strong>Name:</strong> <%= orderInfo.getString("full_name") %></p>
    <p><strong>Email:</strong> <%= orderInfo.getString("email") %></p>
    <p><strong>Phone:</strong> <%= orderInfo.getString("phone") %></p>
    <p><strong>Address:</strong> <%= orderInfo.getString("address") %></p>
</div>
<%
    }
%>

<div class="info-box">
    <h2>Ordered Items</h2>
    <table>
        <tr>
            <th>Product</th>
            <th>Price</th>
            <th>Qty</th>
            <th>Subtotal</th>
        </tr>
        <%
            while(items != null && items.next()){
        %>
        <tr>
            <td><%= items.getString("name") %></td>
            <td>₹<%= items.getDouble("price") %></td>
            <td><%= items.getInt("quantity") %></td>
            <td>₹<%= items.getDouble("subtotal") %></td>
        </tr>
        <%
            }
        %>
    </table>
</div>

</body>
</html>
