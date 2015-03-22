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
<link href="css/graph.css" rel="stylesheet" type="text/css"
	media="screen" />
<link
	href='http://fonts.googleapis.com/css?family=Raleway:400,900,700,100'
	rel='stylesheet' type='text/css'>
<link href='http://fonts.googleapis.com/css?family=Oswald:400,300,700'
	rel='stylesheet' type='text/css'>
<link
	href='http://fonts.googleapis.com/css?family=Lato:100,300,400,700,900'
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

		<%
			Class.forName("org.h2.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:h2:tcp://localhost/~/test", "admin", "password");

			Statement stmt = con.createStatement();
			String currentRestaurantID = "";
			String currentRestName = "";
			int numberofweeksago = 0;

			String[] assignedResources = request
					.getParameterValues("restIDSelect");
			if (assignedResources == null) {
				out.println("ERROR");
			} else {
				currentRestaurantID = assignedResources[0];
			}

			if (request.getParameterValues("weeksagoSelect") != null) {
				String x = request.getParameterValues("weeksagoSelect")[0];
				numberofweeksago = Integer.parseInt(x);
			}

			ResultSet rs = stmt
					.executeQuery("SELECT RESTAURANT_NAME FROM RESTAURANTS WHERE RESTAURANTID="
							+ currentRestaurantID);

			rs.next();
			currentRestName = rs.getString(1);
			if (currentRestName.contains("_")) {
				int i = currentRestName.indexOf("_");
				String[] words = currentRestName.split("_");
				currentRestName = "";
				for (int z = 0; z < words.length; z++) {
					currentRestName += words[z] + " ";
				}
			}

			out.println("<h2>" + currentRestName + "</h2>");
		%>

		<div class="wrapper">
			<div id="left_col">
				<!-- <input type="text" id="search" placeholder="Filter"></input>
				<div id="tableheader">
					<div id="head">
						RESTAURANTID
					</div>
					<div id="head">
						RESTAURANT NAME
					</div>
				</div> -->
				<%
				double[] averages = null;
					try {
						//query for restaurants within the city!
						rs = stmt
								.executeQuery("SELECT AVG(Cast (RATING as double)) AS WEEKLYRATING, NUMBEROFWEEKSAGO FROM RATINGS  WHERE RESTAURANTID = '"
										+ currentRestaurantID
										+ "' and NUMBEROFWEEKSAGO=" + numberofweeksago);

						rs.next();
						String overall_rating = rs.getString(1);
						double a = Double.valueOf(overall_rating);
						a = Math.round(a * 100.0) / 100.0;
						if (a < 3.33) {
							out.println("<span id=\"redText\">" + a);
						} else if (a < 6.66) {
							out.println("<span id=\"yellowText\">" + a);
						} else {
							out.println("<span id=\"greenText\">" + a);
						}
						out.println("</span>");
						if (numberofweeksago == 0) {
							out.println("<p id=\"sub\">CURRENT WEEK'S AVERAGE CUSTOMER RATING</p>");
						} else {
							out.println("<p id=\"sub\">AVERAGE CUSTOMER RATING "
									+ numberofweeksago + " WEEKS AGO</p>");
						}

						out.println("<form action=\"./restaurant_display.jsp\" method=\"POST\">");
						out.println("<select name=\"restIDSelect\" type=\"hidden\" id=\"invisible\"><option>"
								+ currentRestaurantID + "</option></select>");
						out.println("<p># of weeks ago: </p><select name=\"weeksagoSelect\" id=\"idSelect\">");
						int x = 0;

						while (x < 27) {
							String name = rs.getString(1);
							out.println("<option>" + x + "</option>");
							x++;
						}

						out.println("</select>");
						out.println("<br><input type=\"submit\" name=\"Submit\" id=\"submit\">");
						out.println("</form>");

						rs = stmt
								.executeQuery("SELECT AVG(Cast (RATING as double)) AS WEEKLYRATING, NUMBEROFWEEKSAGO FROM RATINGS  WHERE RESTAURANTID = '"
										+ currentRestaurantID
										+ "' GROUP BY NUMBEROFWEEKSAGO ORDER BY CAST (NUMBEROFWEEKSAGO AS int)");

						averages = new double[27];
						int i = 0;
						while (rs.next()) {
							averages[i] = rs.getDouble(1);
						}
						
						/* out.println("<div class=\"wrappergraph\">");
						out.println("<div class=\"chart\" id=\"p1\">");
						out.println("<canvas id=\"c1\">");
						out.println("</canvas></div></div>"); */
						
						out.println("");
						
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
						rs = stmt
								.executeQuery("SELECT RATING FROM RESTAURANTS WHERE RESTAURANTID="
										+ currentRestaurantID);

						out.println("<div id=\"dataBlock\"><div id=\"blockHead\">");
						out.println("<h3>OVERALL RATING</h3></div>");
						rs.next();
						out.println(rs.getString(1) + "/10");
						out.println("</div>");

						rs = stmt
								.executeQuery("SELECT CITY FROM RESTAURANTS WHERE RESTAURANTID="
										+ currentRestaurantID);
						out.println("<div id=\"dataBlock\"><div id=\"blockHead\">");
						out.println("<h3>CITY</h3></div>");
						rs.next();
						out.println(rs.getString(1));
						out.println("</div>");

						rs = stmt
								.executeQuery("SELECT PROXIMITY_TO_CITY_CENTER FROM RESTAURANTS WHERE RESTAURANTID="
										+ currentRestaurantID);
						out.println("<div id=\"dataBlock\"><div id=\"blockHead\">");
						out.println("<h3>PROXIMITY TO CITY CENTER</h3></div>");
						rs.next();
						out.println(rs.getString(1) + " miles");
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
	<%-- <script type="text/javascript">
	var c1 = document.getElementById("c1");
	var parent = document.getElementById("p1");
	c1.width = parent.offsetWidth - 40;
	c1.height = parent.offsetHeight - 40;

	var data1 = {
	  labels : ["0","1","2","3","4","5","6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27"],
	  datasets : [
	    {
	      fillColor : "rgba(255,255,255,.1)",
	      strokeColor : "rgba(255,255,255,1)",
	      pointColor : "#123",
	      pointStrokeColor : "rgba(255,255,255,1)",
	      data : [2,<% int i=0;while(i< 27){out.println(averages[i] + ",");}%>]
	    }
	  ]
	}

	var options1 = {
	  scaleFontColor : "rgba(255,255,255,1)",
	  scaleLineColor : "rgba(255,255,255,1)",
	  scaleGridLineColor : "transparent",
	  bezierCurve : false,
	  scaleOverride : true,
	  scaleSteps : 10,
	  scaleStepWidth : 1,
	  scaleStartValue : 0
	}

	new Chart(c1.getContext("2d")).Line(data1,options1)
	</script> --%>

</body>
</html>
