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

	if (loggedInUserName == null || loggedInUserName.isEmpty()) 
	{
	  response.sendRedirect("http://localhost:8090/AnytimeFileAccess/Login.jsp");
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
      loggedInUserEmail=(String)session.getAttribute("afa_useremail");
     
     if(loggedInUserEmail==null || loggedInUserEmail.isEmpty()){
    	
    	 response.sendRedirect("http://localhost:8090/AnytimeFileAccess/Login.jsp");
    
     }// Main 'if' closed
     
     else{

    	 try{
    		 
    	/* Getting connection */
    		 
        connection = ConnectionToDatabase.getConnection();   
        	 
        /* Prepare Query */
        
        queryToFetchAllFile="SELECT * FROM files_Details WHERE owner = ? ;";
       	preparedStatement=connection.prepareStatement(queryToFetchAllFile);
       	preparedStatement.setString(1, loggedInUserEmail);
       	
       	/* Fire Query */
       	resultSet=preparedStatement.executeQuery();
       	
       	collectionOfFileData=new ArrayList<>();
       	
      /* Temp vriable  */
      int fileId=0;
	  String ownerOfFile="",fileName="",fileSize="",categoryOfFile="",urlOfFile="",dateCreated="",dateModified="",descOfFile="",dateExpiray="";

	  
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
    		descOfFile = resultSet.getString("description");
    		dateExpiray = resultSet.getString("expiry_date");
       		
       		/* Initilize Modal Object */ 		
       		fileDataModal=new FileDataModal(fileId,ownerOfFile,fileName,fileSize,categoryOfFile,
       			urlOfFile,dateCreated,dateModified,descOfFile,dateExpiray);
 
       		/* Adding object to Arraylist */
       		collectionOfFileData.add(fileDataModal);
       		
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

</head>

<style>

/* Style for the top section */
.navbar {
    background-color: #007bff;
}

.navbar-brand {
    color: #fff;
    font-weight: bold;
}

.navbar-text {
    color: #fff;
}

.logout-icon {
    color: #fff;
}

/* Style for the grid layout */
.card {
    margin-bottom: 1rem;
}

.card-img-top {
    height: 200px;
    object-fit: cover;
}

.card-title {
    margin-bottom: 0.5rem;
    font-size: 1.25rem;
    font-weight: 500;
}

.card-text {
    margin-bottom: 0.5rem;
}

/* Style for the fixed button */
.fixed-button {
    position: fixed;
    bottom: 2rem;
    right: 2rem;
    width: 3rem;
    height: 3rem;
    background-color: #007bff;
    color: #fff;
    border-radius: 50%;
    text-align: center;
    font-size: 2rem;
    line-height: 2.7rem;
}


/* My Css */

#logout_icon{
cursor: pointer;
}

a{
color:white;
text-decoration:none;
}

/* No data div Css  */

.DivNoData {
  margin-top: 50px;
}

.UL_steps {
  list-style-type: none;
  padding-left: 0;
}

.step {
  margin-bottom: 10px;
}

#noData-card{
  border: none;
  box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
}

#noData-card_body {
  padding: 30px;
}

@media only screen and (max-width: 767px) {
  #noData-card_body {
    padding: 20px;
  }
}


</style>


<body>

	<!-- Top section : NavBar -->

	<nav class="navbar navbar-expand-lg">

		<div class="container-fluid">

			<span class="navbar-brand">
			<!-- Here add mini Image / logo Of AFA  -->
			<i class="fa-solid fa-circle-h"></i>
				&nbsp; AnyTimeFileAcees
			</span>

			<div class="navbar-text ms-auto">
				<i class="fa-solid fa-user"></i> 
				<span class="me-3" id="user_name"> <%=loggedInUserName %> </span> 
				
				<a href="http://localhost:8090/AnytimeFileAccess/LogoutServlet" style="text-decoration:none">
				<i id="logout_icon" class="fa-solid fa-right-from-bracket"></i>
				</a>
				
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
				if (collectionOfFileData == null || collectionOfFileData.isEmpty()) {
					
			%>
			
			<!-- End JSP : 1 -->
			
			<!-- <h1 style="color: red;">No data avilable</h1>  -->
			
			<div class="DivNoData container">
                
                <h3 style="text-align: center">Hello <span>
                        <%=loggedInUserName %>
                    </span></h3>

                <div class="row justify-content-center">
                    
                    <div>
                        
                        <div id="noData-card" class="card">
                            
                            <div id="noData-card_body" class="card-body">
                                
                                <ul style="list-style-type: square"	 class="UL_steps">
                                    
                                    <li class="step">You haven't uploaded any file</li>
                                    <li class="step">To upload file follow given Steps</li>
                                    
                                    <ol start="1" type="1">
                                    
                                        <li class="step">Click on '+' icon located at Bottom-Right</li>
                                        <li class="step">Fill Details Of the Form</li>
                                        <li class="step">Click on Upload Button</li>
                                    </ol>

                                </ul>

                            </div>

                        </div>

                    </div>

                </div>

            
            </div>
			
			
			<!-- Start JSP : 2 -->
			<%
		
			} /* If Close : collection is null?  */

			else {
		
				/* Iterate collection and set dtails to HTML code */
				
				for(int i=0;i<collectionOfFileData.size();i++){
				
					/* Getting Object */
					fileDataModal=collectionOfFileData.get(i);
					
				/* Varible to show in Grid/Preview */	
				String previewId="",previewUrl="",previewFileName="",previewFileDesc="";
				
				/* Getting all preview Data */		
				 previewId = ""+fileDataModal.getFileId(); 
				 previewUrl = fileDataModal.getUrlOfFile();
				 previewFileName = fileDataModal.getFileName();
				 previewFileDesc = fileDataModal.getDescOfFile();
				
			%>
				<!-- End JSP : 2 -->

			<div class="col">

				<div class="card">

				<!-- Start JSP : 3 -->
				
					<%
					
					/* Cheking file is pdf or not  */
					
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
				}
				
		} /* else closed : show data in grid */

	} catch (Exception exception) {
		System.out.println("\n => Error at  Grid : " + exception);
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
	<a href="#" style="text-decoration: none;" class="fixed-button">
	<i class="fa-solid fa-plus"></i>
	</a>

	<!-- Link to Bootstrap JS -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.min.js"></script>

<!-- <script>
    window.history.pushState(null, "", window.location.href);
</script> -->

</body>

</html>