<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    String role = (String) session.getAttribute("role");
    String email = (String) session.getAttribute("email");

    if (role == null || !role.equals("user")) {
        response.sendRedirect("Login.jsp");
        return;
    }

    int userId = 0;
    String name = "", phone = "", gender = "", address = "", userEmail = "";

    try {
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM user WHERE email=?");
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            userId = rs.getInt("id");
            name = rs.getString("name");
            phone = rs.getString("phone");
            gender = rs.getString("gender");
            address = rs.getString("address");
            userEmail = rs.getString("email");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f3f4f6; margin: 0; padding: 0; }
        header {
            background: #4f46e5;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        header h1 { margin: 0; }
        .btn {
            display: inline-block; margin-left: 10px;
            padding: 8px 15px; border-radius: 5px;
            color: white; text-decoration: none;
        }
        .home { background: #10b981; }
        .logout { background: #ef4444; }
        .container {
            max-width: 900px; margin: 30px auto;
            background: white; padding: 20px;
            border-radius: 8px; box-shadow: 0px 3px 10px rgba(0,0,0,0.1);
        }
        h2 { color: #333; margin-bottom: 15px; }
        form label { display: block; margin-top: 10px; font-weight: bold; }
        form input, form select, form textarea {
            width: 100%; padding: 8px; margin-top: 5px;
            border: 1px solid #ccc; border-radius: 5px;
        }
        form button {
            margin-top: 15px; padding: 10px;
            background: #4f46e5; color: white;
            border: none; border-radius: 5px; cursor: pointer;
        }
        form button:hover { background: #4338ca; }
        table {
            width: 100%; border-collapse: collapse;
            margin-top: 20px;
        }
        table th, table td {
            border: 1px solid #ddd; padding: 10px; text-align: center;
        }
        table th { background: #f3f4f6; }
    </style>
</head>
<body>
    <header>
        <h1>User Dashboard</h1>
        <div>
            <a href="home.jsp" class="btn home">🏠 Home</a>
            <a href="logout.jsp" class="btn logout">Logout</a>
        </div>
    </header>

    <div class="container">
        <!-- Profile Section -->
        <h2>Update Profile</h2>
        <form action="updateProfile.jsp" method="post">
            <input type="hidden" name="id" value="<%= userId %>">

            <label>Full Name:</label>
            <input type="text" name="name" value="<%= name %>" required>

            <label>Phone:</label>
            <input type="text" name="phone" value="<%= phone %>" required>

            <label>Gender:</label>
            <select name="gender" required>
                <option value="">-- Select Gender --</option>
                <option value="Male" <%= "Male".equals(gender) ? "selected" : "" %>>Male</option>
                <option value="Female" <%= "Female".equals(gender) ? "selected" : "" %>>Female</option>
                <option value="Other" <%= "Other".equals(gender) ? "selected" : "" %>>Other</option>
            </select>

            <label>Address:</label>
            <textarea name="address" required><%= address %></textarea>

            <label>Email:</label>
            <input type="email" name="email" value="<%= userEmail %>" required>

            <button type="submit">Update Profile</button>
        </form>
    </div>

    <div class="container">
        <!-- Orders Section -->
        <h2>My Orders</h2>
        <table>
            <tr>
                <th>Order ID</th>
                <th>Total Amount</th>
                <th>Status</th>
                <th>Order Date</th>
            </tr>
            <%
                try {
                    PreparedStatement ps = conn.prepareStatement("SELECT * FROM orders WHERE user_id=? ORDER BY created_at DESC");
                    ps.setInt(1, userId);
                    ResultSet rs = ps.executeQuery();
                    while (rs.next()) {
            %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td>$<%= rs.getDouble("total_amount") %></td>
                    <td><%= rs.getString("status") %></td>
                    <td><%= rs.getTimestamp("created_at") %></td>
                </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
        </table>
    </div>
</body>
</html>
