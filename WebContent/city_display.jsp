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
<link rel="stylesheet" href="./css/city_display.css" />
<link
	href='http://fonts.googleapis.com/css?family=Raleway:400,900,700,100'
	rel='stylesheet' type='text/css'>
<link href='http://fonts.googleapis.com/css?family=Oswald:400,300,700'
	rel='stylesheet' type='text/css'>
<link href='http://fonts.googleapis.com/css?family=Lato:100,300,400,700,900' rel='stylesheet' type='text/css'>
</head>
<body>
	<div class="top_section">
		<h1>
			<a href="http://localhost:8080/NJRestaurants/home.jsp"><span
				id="logo">NJ</span>RESTAURANTS</a>
		</h1>
	</div>
	<div class="mid">

		<%
			Class.forName("org.h2.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:h2:tcp://localhost/~/test", "admin", "password");

			Statement stmt = con.createStatement();
			String currentCity = "";

			String[] assignedResources = request.getParameterValues("name");
			if (assignedResources == null) {
				out.println("ERROR");
			} else {
				currentCity = assignedResources[0];
			}

			out.println("<h2>" + currentCity + "</h2>");
		%>

		<div class="wrapper">
			<div id="left_col">
				<input type="text" id="search" placeholder="Filter"></input>
				<div id="tableheader">
					<div id="head">RESTAURANTID</div>
					<div id="head">RESTAURANT NAME</div>
				</div>
				<%
					try {
						//query for restaurants within the city!
						ResultSet rs = stmt
								.executeQuery("SELECT RESTAURANTID,RESTAURANT_NAME FROM RESTAURANTS WHERE CITY='"
										+ currentCity + "'");

						out.println("<table border=1 width=400>");
						/*out.println("<tr><th>    RESTAURANTID"
								+ "</th><th>    RESTAURANT NAME" + "</th></tr>"); */

						while (rs.next()) {
							String id = rs.getString(1);
							String name = rs.getString(2);
								out.println("<tr><td><a href=\"#\">" + id
										+ "</a></td><td><a href=\"#\">" + name
										+ "</a></td></tr>");
						}
								
						out.println("</table>");
						
						out.println("<form action=\"./restaurant_display.jsp\" method=\"POST\">");
						rs = stmt
								.executeQuery("SELECT RESTAURANTID FROM RESTAURANTS WHERE CITY='"
										+ currentCity + "'");
						
						out.println("<select name=\"restIDSelect\" id=\"idSelect\">");
						while (rs.next()) {
							String name = rs.getString(1);
							out.println("<option>" + name + "</option>");
						} 
						out.println("</select>");
						
						out.println("<input type=\"submit\" name=\"Submit\" id=\"submit\">");
						out.println("</form>");
						
						

					} catch (Exception e) {
						out.println(e.getMessage());
					}
				%>
			</div>
			<div id="right_col">
				<%
					try {
						//query for restaurants within the city!

						out.println("STATISTICS");
						ResultSet rs = stmt
								.executeQuery("SELECT CRIME_RATE FROM CITIES WHERE CITYNAME='"
										+ currentCity + "'");

						out.println("<div id=\"dataBlock\"><div id=\"blockHead\">");
						out.println("<h3>CRIME RATE</h3></div>");
						rs.next();
						out.println(rs.getString(1));
						out.println("</div>");

						rs = stmt
								.executeQuery("SELECT POPULATION FROM CITIES WHERE CITYNAME='"
										+ currentCity + "'");
						out.println("<div id=\"dataBlock\"><div id=\"blockHead\">");
						out.println("<h3>POPULATION</h3></div>");
						rs.next();
						out.println(rs.getString(1));
						out.println("</div>");

						rs = stmt
								.executeQuery("SELECT PERCENT_MARRIED FROM CITIES WHERE CITYNAME='"
										+ currentCity + "'");
						out.println("<div id=\"dataBlock\"><div id=\"blockHead\">");
						out.println("<h3>% OF POPULATION MARRIED</h3></div>");
						rs.next();
						out.println(rs.getString(1));
						out.println("</div>");

						rs = stmt
								.executeQuery("SELECT PCT_HIGH_BMI FROM CITIES WHERE CITYNAME='"
										+ currentCity + "'");
						out.println("<div id=\"dataBlock\"><div id=\"blockHead\">");
						out.println("<h3>% OF POPULATION WITH HIGH BMI</h3></div>");
						rs.next();
						out.println(rs.getString(1));
						out.println("</div>");

					} catch (Exception e) {
						out.println(e.getMessage());
					}
				%>
			</div>
		</div>
	</div>

	<script type="text/javascript"
		src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
	<script type="text/javascript" src="js/code.js"></script>

</body>
</html>
