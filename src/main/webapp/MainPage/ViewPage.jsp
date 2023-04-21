<!-- Importing Files -->

<%@page import="java.util.ArrayList"%>
<%@page import="com.afa.modal.FileDataModal"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="com.afa.dbms.ConnectionToDatabase"%>
<%@page import="java.sql.Connection"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<!-- If user is Not Logged in send back it to login page -->

<%

String loggedInUserName=(String)session.getAttribute("afa_username");

System.out.print("\n => user name :  " + loggedInUserName);

	if (loggedInUserName == null || loggedInUserName.isEmpty()) 
	{
	  response.sendRedirect("../Login.jsp");
	  return;
	}

%>

<!-- If user is Logged in fetched All its data -->

<%

     /* <--- Global Objects --->  */
     
      	Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		FileDataModal fileDataModal=null;
		ArrayList<FileDataModal> collectionOfFileData=null;
     
     /* <--- Global Variable --->  */
     
     String loggedInUserEmail="",queryToFetchAllFile="";
     
     
     /* <--- Establishing Connection with database --->  */
     
     /* Fetched loggedInUserEmail from session */
      loggedInUserEmail=(String)session.getAttribute("afa_loggedInUserEmail");
     
     if(loggedInUserEmail==null || loggedInUserEmail.isEmpty()){
    	
    	 response.sendRedirect("../Login.jsp");
    
     }// Main 'if' closed
     
     else{

    	 try{
    		 
    	/* Getting connection */
    		 
        connection = ConnectionToDatabase.getConnection();   
        	 
        /* Prepare Query */
        
        queryToFetchAllFile="SELECT * FROM files_Details WHERE = ? ;";
       	preparedStatement=connection.prepareStatement(queryToFetchAllFile);
       	preparedStatement.setString(1, loggedInUserEmail);
       	
       	/* Fire Query */
       	resultSet=preparedStatement.executeQuery();
       	
       	/* Only if data avialable : .first() set to first row and return 'true' / 'false' */
       	
      /* Temp vriable  */
      int fileId=0;
	  String ownerOfFile="",fileName="",fileSize="",categoryOfFile="",urlOfFile="",dateCreated="",dateModified="",descOfFile="",dateExpiray="";
	   			
       	if (resultSet.first())
       	{
       		while(resultSet.next()){
       			
       		/* Fetching data from resultset */
       		fileId=resultSet.getInt("Id");
       		ownerOfFile=resultSet.getString("owner");
       		fileName=resultSet.getString("file_name");
       		fileSize=resultSet.getString("file_size");
       		categoryOfFile = resultSet.getString("category");
    		urlOfFile =resultSet.getString("url");
    		dateCreated = resultSet.getString("date_created");
    		dateModified =resultSet.getString("date_modified");
    		descOfFile = resultSet.getString("desc");
    		dateExpiray = resultSet.getString("expiry_date");
       		
       		/* Initilize Modal Object */ 		
       		fileDataModal=new FileDataModal(fileId,ownerOfFile,fileName,fileSize,categoryOfFile,
       			urlOfFile,dateCreated,dateModified,descOfFile,dateExpiray);
 
       		/* Adding object to Arraylist */
       		collectionOfFileData.add(fileDataModal);
       		
       		}
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

<!-- Main Frontend-Html Code -->

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>AnyTimeFileAcees | Main </title>

<!-- Link to Bootstrap CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/css/bootstrap.min.css">

<!-- Font-Awsome  -->
<script src="https://kit.fontawesome.com/31ab84d251.js" crossorigin="anonymous"></script>

<!-- Link to Jquery JS -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>

<!-- Link to Cookie :  Jquery JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>

<!-- Custom styles -->
<link rel="stylesheet" href="./MainPage.css">

</head>

<body>

	<!-- Top section : NavBar -->

	<nav class="navbar navbar-expand-lg">

		<div class="container-fluid">

			<a class="navbar-brand">
			<!-- Here add mini Image / logo Of AFA  -->
			<i class="fa-solid fa-circle-h"></i>
				&nbsp; AnyTimeFileAcees
			</a>

			<div class="navbar-text ms-auto">
				<i class="fa-solid fa-user"></i> 
				<span class="me-3" id="user_name"> <%=loggedInUserName %> </span> 
				<i id="logout_icon" class="fa-solid fa-right-from-bracket"></i>
			</div>

		</div>

	</nav>


	<!-- Grid layout section -->

	<div class="container my-5">

		<!-- All columns  : Dynamic row  : 4 columns -->

		<div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">

		<!-- !! JSP !! Java Logic !! : Iterate all data and show them in the grid form -->
		
		<!-- Start JSP : 1 -->
			<%
			
			try {
				
				/* No File Saved  */
				if (collectionOfFileData == null) {
					
			%>
			
			<!-- End JSP : 1 -->
			
			<h1 style="color: red;">No data avilable</h1>
			
			<!-- Start JSP : 2 -->
			<%
		
			} /* If Close : collection is null?  */

			else {
		
			collectionOfFileData.forEach(fileData -> {
				
				/* Varible to show in Grid/Preview */	
				String previewId="",previewUrl="",previewFileName="",previewFileDesc="";
				
				/* Getting all preview Data */		
				 previewId = ""+fileData.getFileId(); 
				 previewUrl = fileData.getUrlOfFile();
				 previewFileName = fileData.getFileName();
				 previewFileDesc = fileData.getDescOfFile();
				
			%>
				<!-- End JSP : 2 -->

			<div class="col">

				<div class="card">

				<!-- Start JSP : 3 -->
				
					<%
					
					/* Cheking file is pdf or not  */

					System.out.print("\n => url : " + previewUrl);

					if (previewUrl.endsWith(".pdf")) {
						
					%>

				<!-- End JSP : 3 -->
			
					<iframe src=<%=previewUrl %> class="card-img-top"></iframe>

				<!-- Start JSP : 4 -->

					<%
					
					} /* If close : is pdf? */

					else {
						
					%>
			
				<!-- End JSP : 4 -->

			<img src=<%=previewUrl %> class="card-img-top" alt=<%=previewFileName %>>

		<!-- Start JSP : 5 -->
					<%
					} /* else close : img file */
					%>
		<!-- End JSP : 5 -->

					<div class="card-body">

						<h5 class="card-title"><%=previewFileName %></h5>

						<p class="card-text"><%=previewFileDesc %></p>

						<div class="d-grid gap-2">

							<a target="_blank"
								href=<%=previewUrl %> type="button"
								class="btn btn-primary">
								 
								<i class="fa-solid fa-download"></i>
								&nbsp; Download
							</a>

							<button id=<%=previewId %> class="btn btn-outline-primary" type="button">
								<i class="fa-solid fa-circle-info"></i>Details
							</button>

						</div>

					</div>

				</div>

			</div>

	<!-- Start JSP : 6 -->

	<%
			
			}); /* forEach is closed */
			
		} /* else closed : show data in grid */

	} catch (Exception exception) {
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

	%>
			
	<!-- End JSP : 6 -->
	
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