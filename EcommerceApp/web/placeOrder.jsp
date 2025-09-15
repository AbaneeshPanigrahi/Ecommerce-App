<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    int userId = Integer.parseInt(request.getParameter("userId"));
    double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));

    try {
        // Insert order into orders table
        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO orders(user_id, total_amount, status, created_at) VALUES (?, ?, 'Pending', NOW())",
            Statement.RETURN_GENERATED_KEYS);
        ps.setInt(1, userId);
        ps.setDouble(2, totalAmount);
        ps.executeUpdate();

        // Get generated order_id
        ResultSet rs = ps.getGeneratedKeys();
        int orderId = 0;
        if (rs.next()) {
            orderId = rs.getInt(1);
        }

        // Fetch all cart items
        PreparedStatement psCart = conn.prepareStatement(
            "SELECT product_id, quantity, (SELECT price FROM products WHERE id=cart.product_id) AS price FROM cart WHERE user_id=?");
        psCart.setInt(1, userId);
        ResultSet rsCart = psCart.executeQuery();

        // Insert into order_items
        PreparedStatement psItems = conn.prepareStatement(
            "INSERT INTO order_items(order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)");

        while (rsCart.next()) {
            int productId = rsCart.getInt("product_id");
            int qty = rsCart.getInt("quantity");
            double price = rsCart.getDouble("price");

            psItems.setInt(1, orderId);
            psItems.setInt(2, productId);
            psItems.setInt(3, qty);
            psItems.setDouble(4, price);
            psItems.executeUpdate();
        }

        // Clear the cart
        PreparedStatement psClear = conn.prepareStatement("DELETE FROM cart WHERE user_email=?");
        psClear.setInt(1, userId);
        psClear.executeUpdate();

        // Redirect
        response.sendRedirect("userDashboard.jsp");

    } catch (Exception e) {
        e.printStackTrace();
    }
%>
