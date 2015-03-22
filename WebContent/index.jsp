<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>NJRestaurants</title>
		<!-- <link rel="stylesheet" href="./html5reset.css" />  -->
		<!-- <link rel="stylesheet" href="./normalize.css" />  -->
		<link rel="stylesheet" href="./style.css" />
	</head>
	<body>
		<h1>NJRestaurants</h1>
		<%
		
			try {			
				
				Class.forName("org.h2.Driver");
				Connection con = DriverManager.
			            getConnection("jdbc:h2:tcp://localhost/~/test", "admin", "password");
				
				Statement stmt = con.createStatement();
				ResultSet rs = stmt.executeQuery("SELECT name,beer from LIKES");
				
				/* while(rs.next()){
					String name = rs.getString(1);
					String beer = rs.getString(2);
					out.print(name + " | " + beer+"<br>");
				} */
				
				out.println("<table border=1 width=400>");
				out.println("<tr><td>    drinker"  + "</td><td>    beer"  + "</td></tr>");
				while (rs.next()) {
					String name = rs.getString(1);
					String beer = rs.getString(2);
					out.println("<tr><td>" + name + "</td><td>" + beer+ "</td></tr>");
				} 
				out.println("</table>");
				
			}catch(Exception e){
				out.println(e.getMessage());
			}
		%>
	</body>
</html>
