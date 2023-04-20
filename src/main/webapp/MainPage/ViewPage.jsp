<!-- Importing Files -->

<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="com.afa.dbms.ConnectionToDatabase"%>
<%@page import="java.sql.Connection"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<!-- If user is Not Logged in send back it to login page -->

<%
	
String userNamecheck=(String)session.getAttribute("afa_username");

System.out.print("\n => user name :  " + userNamecheck);

	if (session.getAttribute("afa_username") == null) 
	{
	  response.sendRedirect("Login.jsp");
	}

%>

<!-- If user is Logged in fetched All its data -->

<%

     /* <--- Global Objects --->  */
     
      	Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
     
     /* <--- Global Variable --->  */
     
     String userName="",userEmail="",queryToFetchAllFile="";
     
     
     /* <--- Establishing Connection with database --->  */
     
     /* Fetched userName and userEmail from session */
     
     userName=(String)session.getAttribute("afa_username");
     userEmail=(String)session.getAttribute("afa_useremail");
     
     if( userName==null || userEmail==null || userName.isEmpty() || userEmail.isEmpty()){
    	
    	 response.sendRedirect("../login.html");
    
     }// Main 'if' closed
     
     else{

    	 try{
    		 
    	/* Getting connection */
    		 
        connection = ConnectionToDatabase.getConnection();   
        	 
        /* Prepare Query */
        
        queryToFetchAllFile="SELECT * FROM filesDetails WHERE useremail= ? ;";
       	preparedStatement=connection.prepareStatement(queryToFetchAllFile);
       	preparedStatement.setString(1, userEmail);
       	
       	/* Fire Query */
       	
       	resultSet=preparedStatement.executeQuery();
       	
       	/* No data avialable */
       	if(!resultSet.next()){
       		
       	}
       	
       	/* Data avialable */
       	else{
       		
       	}
       	
       	
    		 
    	 }
    	 catch (Exception exception) {
 			System.out.println("\n => Error at Database Connection : " + exception);
 		}
 		finally {
 			
 			if (preparedStatement != null) {
 				preparedStatement.close();
 			}
 			
 			if (resultSet != null) {
 				resultSet.close();
 			}
 		}
    	 
    	 
     } // Main 'else' closed

%>



<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>AnyTimeFileAcees | Main</title>

<!-- Link to Bootstrap CSS -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/css/bootstrap.min.css">

<!-- Font-Awsome  -->
<script src="https://kit.fontawesome.com/31ab84d251.js"
	crossorigin="anonymous"></script>

<!-- Link to Jquery JS -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>

<!-- Link to Cookie :  Jquery JS -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>


<!-- Custom styles -->

<link rel="stylesheet" href="MainPage.css">

</head>

<body>

	<!-- Top section -->

	<nav class="navbar navbar-expand-lg">

		<div class="container-fluid">

			<a class="navbar-brand" href="#"><i class="fa-solid fa-circle-h"></i>
				&nbsp; AnyTimeFileAcees</a>

			<div class="navbar-text ms-auto">

				<i class="fa-solid fa-user"></i> <span class="me-3" id="user_name">User
					Name</span> <i id="logout_icon" class="fa-solid fa-right-from-bracket"></i>
			</div>

		</div>

	</nav>


	<!-- Grid layout section -->

	<div class="container my-5">


		<!-- All columns -->

		<div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">

			<%
			/* <--- Database Connection --> */
			System.out.println("\n => I reach here -- 1");

		//	Connection connection = null;
			Statement statement = null;
		//	ResultSet resultSet = null;

			try {
				System.out.println("\n => I reach here -- 2");

				connection = ConnectionToDatabase.getConnection();
				statement = connection.createStatement();

				resultSet = statement.executeQuery("SELECT * FROM userfile ");

				System.out.println("\n => I reach here -- 3 \n => Rs : ");

				System.out.println(resultSet);

				/* No File Saved  */
				if (resultSet == null) {
			%>
			<h1 style="color: red;">No data avilable</h1>
			<%
			}

			else {

			while (resultSet.next()) {
			%>

			<div class="col">

				<div class="card">

					<%
					/* Cheking file is pdf or not  */

					String fileUrl = resultSet.getString("url");

					System.out.print("\n => url : " + fileUrl);

					if (fileUrl.endsWith(".pdf")) {
					%>

					<iframe src=<%=resultSet.getString("url")%> class="card-img-top"></iframe>

					<%
					}

					else {
					%>

					<img src=<%=resultSet.getString("url")%> class="card-img-top"
						alt="...">

					<%
					}
					%>

					<div class="card-body">

						<h5 class="card-title"><%=resultSet.getString("filename")%></h5>

						<p class="card-text"><%=resultSet.getString(3)%></p>

						<div class="d-grid gap-2">

							<a download="w3logo" target="_blank"
								href=<%=resultSet.getString("url")%> type="button"
								class="btn btn-primary"> <i class="fa-solid fa-download"></i>
								&nbsp; Download
							</a>

							<button class="btn btn-outline-primary" type="button">
								<i class="fa-solid fa-circle-info"></i>Details
							</button>

						</div>

					</div>

				</div>

			</div>

			<%
			}

			}

			} catch (Exception exception) {
			System.out.println("\n => Error at Database Connection : " + exception);
			}

			finally {
			if (statement != null) {
			statement.close();
			}
			if (resultSet != null) {
			resultSet.close();
			}
			}
			%>
		</div>

	</div>

	<!-- Fixed button section -->
	<a href="#" style="text-decoration: none;" class="fixed-button"><i
		class="fa-solid fa-plus"></i></a>

	<!-- Link to Bootstrap JS -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.min.js"></script>

</body>

</html>