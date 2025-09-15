<%@ page import="java.sql.*" %>
<%
    Connection conn = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection( "jdbc:mysql://localhost:3306/ecommerce_db", "root", "Shrinu@12");
        out.println("Connection successful!");
    } catch(Exception e) {
        out.println("Database connection error: " + e.getMessage());
    } 
%>
