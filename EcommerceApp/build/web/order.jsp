<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    String email = (String) session.getAttribute("email");
    if (email == null) {
        response.sendRedirect("Login.jsp");
        return;
    }

    try {
        // Fetch all orders of the logged-in user
        PreparedStatement psOrders = conn.prepareStatement(
            "SELECT * FROM orders WHERE user_email=? ORDER BY created_at DESC"
        );
        psOrders.setString(1, email);
        ResultSet rsOrders = psOrders.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Orders</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f8f9fa; padding: 20px; }
        h2 { text-align:center; margin-bottom: 20px; }
        .order { background: white; padding: 20px; margin-bottom: 25px; border-radius: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.1); }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { padding: 10px; border: 1px solid #ddd; text-align: center; }
        th { background: #042352; color: white; }
        .status { font-weight: bold; }
        .total { text-align: right; font-size: 16px; margin-top: 10px; }
    </style>
</head>
<body>
    <h2>? My Orders</h2>

<%
        boolean hasOrders = false;
        while (rsOrders.next()) {
            hasOrders = true;
            int orderId = rsOrders.getInt("id");
            double totalAmount = rsOrders.getDouble("total_amount");
            String status = rsOrders.getString("status");
            Timestamp createdAt = rsOrders.getTimestamp("created_at");
%>
    <div class="order">
        <p><strong>Order ID:</strong> <%= orderId %> | <strong>Status:</strong> <span class="status"><%= status %></span> | <strong>Date:</strong> <%= createdAt %></p>

        <table>
            <tr>
                <th>Product</th>
                <th>Image</th>
                <th>Price (?)</th>
                <th>Quantity</th>
                <th>Subtotal (?)</th>
            </tr>
<%
            // Fetch products inside this order
            PreparedStatement psItems = conn.prepareStatement(
                "SELECT p.name, p.image_url, oi.price, oi.quantity " +
                "FROM order_items oi JOIN products p ON oi.product_id = p.product_id " +
                "WHERE oi.order_id=?"
            );
            psItems.setInt(1, orderId);
            ResultSet rsItems = psItems.executeQuery();

            while (rsItems.next()) {
                String name = rsItems.getString("name");
                String image = rsItems.getString("image_url");
                double price = rsItems.getDouble("price");
                int qty = rsItems.getInt("quantity");
                double subtotal = price * qty;
%>
            <tr>
                <td><%= name %></td>
                <td>
                    <% if (image != null && !image.isEmpty()) { %>
                        <img src="<%= image %>" alt="Product" width="50" height="50">
                    <% } else { %>
                        N/A
                    <% } %>
                </td>
                <td>?<%= price %></td>
                <td><%= qty %></td>
                <td>?<%= subtotal %></td>
            </tr>
<%
            }
            rsItems.close();
            psItems.close();
%>
        </table>
        <div class="total"><strong>Total Amount: ?<%= totalAmount %></strong></div>
    </div>
<%
        }

        if (!hasOrders) {
            out.println("<h3>You have not placed any orders yet. <a href='home.jsp'>Shop now</a></h3>");
        }

        rsOrders.close();
        psOrders.close();
%>

</body>
</html>
