<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>
<%    String role = (String) session.getAttribute("role");
    String username = (String) session.getAttribute("username");
    if (role == null || !role.equals("admin")) {
        response.sendRedirect("Login.jsp");
        return;
    }

    int totalProducts = 0;
    int totalOrders = 0;
    int totalUsers = 0;
    double totalRevenue = 0;

    // Admin profile info
    String fullName = "";
    String email = "";
    String phone = "";

    try {
        Statement st = conn.createStatement();

        ResultSet rs1 = st.executeQuery("SELECT COUNT(*) FROM products");
        if (rs1.next()) {
            totalProducts = rs1.getInt(1);
        }

        ResultSet rs2 = st.executeQuery("SELECT COUNT(*) FROM orders");
        if (rs2.next()) {
            totalOrders = rs2.getInt(1);
        }

        ResultSet rs3 = st.executeQuery("SELECT COUNT(*) FROM user WHERE role='user'");
        if (rs3.next()) {
            totalUsers = rs3.getInt(1);
        }

        ResultSet rs4 = st.executeQuery("SELECT SUM(total_amount) FROM orders");
        if (rs4.next()) {
            totalRevenue = rs4.getDouble(1);
        }

        // Admin profile fetch
        PreparedStatement ps = conn.prepareStatement("SELECT full_name, email, phone FROM user WHERE username=? AND role='admin'");
        ps.setString(1, username);
        ResultSet rs5 = ps.executeQuery();
        if (rs5.next()) {
            fullName = rs5.getString("full_name");
            email = rs5.getString("email");
            phone = rs5.getString("phone");
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - E-commerce</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                font-family: 'Inter', sans-serif;
                margin:0;
                background:#f5f6fa;
            }
            .dashboard-container {
                display:flex;
                min-height:100vh;
            }
            .sidebar {
                width:240px;
                background:#1f2937;
                color:#fff;
                padding:20px 0;
            }
            .sidebar h2 {
                text-align:center;
                margin-bottom:20px;
                font-size:20px;
            }
            .nav-menu {
                list-style:none;
                padding:0;
            }
            .nav-menu li {
                margin:10px 0;
            }
            .nav-menu a {
                display:block;
                padding:10px 20px;
                color:#ddd;
                text-decoration:none;
            }
            .nav-menu a:hover, .nav-menu a.active {
                background:#374151;
                color:#fff;
            }

            .main-content {
                flex:1;
                padding:20px;
            }
            .header {
                display:flex;
                justify-content:space-between;
                align-items:center;
                margin-bottom:20px;
            }
            .header h1 {
                font-size:22px;
            }
            .logout-btn {
                padding:6px 12px;
                background:#ef4444;
                color:#fff;
                border:none;
                border-radius:4px;
                cursor:pointer;
            }

            .stats-grid {
                display:grid;
                grid-template-columns:repeat(auto-fit, minmax(200px,1fr));
                gap:15px;
                margin-bottom:20px;
            }
            .stat-card {
                background:#fff;
                padding:15px;
                border-radius:8px;
                box-shadow:0 2px 4px rgba(0,0,0,.1);
            }
            .stat-title {
                font-size:14px;
                color:#666;
            }
            .stat-value {
                font-size:20px;
                font-weight:600;
            }

            .management-grid {
                display:grid;
                grid-template-columns:repeat(auto-fit, minmax(250px,1fr));
                gap:15px;
                margin-bottom:20px;
            }
            .management-card {
                background:#fff;
                padding:15px;
                border-radius:8px;
                box-shadow:0 2px 4px rgba(0,0,0,.1);
            }
            .card-action {
                display:inline-block;
                margin-top:10px;
                padding:6px 12px;
                background:#2563eb;
                color:#fff;
                text-decoration:none;
                border-radius:4px;
            }

            .profile-card {
                background:#fff;
                padding:20px;
                border-radius:8px;
                box-shadow:0 2px 4px rgba(0,0,0,.1);
            }
            .profile-card h3 {
                margin-bottom:15px;
            }
            .profile-form {
                display:flex;
                flex-direction:column;
                gap:10px;
            }
            .profile-form input {
                padding:8px;
                border:1px solid #ccc;
                border-radius:4px;
            }
            .profile-form button {
                padding:8px 12px;
                background:#10b981;
                border:none;
                color:#fff;
                border-radius:4px;
                cursor:pointer;
            }
        </style>
    </head>
    <body>
        <div class="dashboard-container">
            <aside class="sidebar">
                <h2>Admin Panel</h2>
                <ul class="nav-menu">
                    <li><a href="admin" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="manage_products.jsp"><i class="fas fa-box"></i> Products</a></li>
                    <li><a href="manage_orders.jsp"><i class="fas fa-shopping-cart"></i> Orders</a></li>
                    <li><a href="user.jsp"><i class="fas fa-user-cog"></i> Profile</a></li><!--
                    <li><a href="#settings"><i class="fas fa-user-cog"></i> Setting</a></li>-->
                </ul>
            </aside>

            <main class="main-content">
                <div class="header">
                    <h1>Dashboard Overview</h1>
                    <button class="logout-btn" onclick="window.location.href = 'logout.jsp'">Logout</button>
                </div>

                <!-- Stats -->
                <div class="stats-grid">
                    <div class="stat-card"><div class="stat-title">Total Products</div><div class="stat-value"><%= totalProducts%></div></div>
                    <div class="stat-card"><div class="stat-title">Total Orders</div><div class="stat-value"><%= totalOrders%></div></div>
                    <div class="stat-card"><div class="stat-title">Total Users</div><div class="stat-value"><%= totalUsers%></div></div>
                    <div class="stat-card"><div class="stat-title">Total Revenue</div><div class="stat-value">₹<%= String.format("%.2f", totalRevenue)%></div></div>
                </div>

<!--                 Management 
                <div class="management-grid">
                    <div class="management-card" id="products"><h3>Product Management</h3><p>Manage all products.</p><a href="manage_products.jsp" class="card-action">Manage</a></div>
                    <div class="management-card" id="orders"><h3>Order Management</h3><p>View and manage orders.</p><a href="manage_orders.jsp" class="card-action">Manage</a></div>
                    <div class="management-card" id="users"><h3>User Management</h3><p>View and manage users.</p><a href="manage_users.jsp" class="card-action">Manage</a></div>
                </div>-->

            </main>
        </div>
    </body>
</html>
