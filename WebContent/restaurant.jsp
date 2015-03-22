<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.sql.*"%>
<%@ page import="javax.naming.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>NJRestaurants</title>
<link rel="stylesheet" href="./css/html5reset.css" />
<link rel="stylesheet" href="./css/normalize.css" />
<link rel="stylesheet" href="./css/home_style.css" />
<link
	href='http://fonts.googleapis.com/css?family=Raleway:400,900,700,100'
	rel='stylesheet' type='text/css'>
</head>
<body>
	<div class="top_section">
		<h1>
			<a href="http://localhost:8080/NJRestaurants/home.jsp"><span
				id="logo">NJ</span>RESTAURANTS</a>
		</h1>
	</div>
	<div class="mid">
		<h2>Find a restaurant</h2>
		<form action="./restaurant_select.jsp" method="POST">
			<%
		
			try {			
				
				Class.forName("org.h2.Driver");
				Connection con = DriverManager.
			            getConnection("jdbc:h2:tcp://localhost/~/test", "admin", "password");
				
				Statement stmt = con.createStatement();
				ResultSet rs = stmt.executeQuery("SELECT DISTINCT RESTAURANT_NAME FROM RESTAURANTS");
				out.println("");
				out.println("<select name=\"rest\">");
				while (rs.next()) {
					String name = rs.getString(1);
					out.println("<option>" + name + "</option>");
				} 
				out.println("</select>");
				
				rs = stmt.executeQuery("SELECT CITYNAME from CITIES");
				out.println("<select name=\"city\">");
				while (rs.next()) {
					String name = rs.getString(1);
					out.println("<option>" + name + "</option>");
				} 
				out.println("</select>");
				
				
			}catch(Exception e){
				out.println(e.getMessage());
			}
		%>

			<br><input type="submit" name="submit" id="submit"></form>
		<!-- <br> <a href="./city_data.jsp" id="submit">SUBMIT</a> -->
	</div>

</body>
</html>
