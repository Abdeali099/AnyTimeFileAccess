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
	  response.sendRedirect("../AnytimeFileAccess/Login.jsp");
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
    	
    	 response.sendRedirect("../AnytimeFileAccess/Login.jsp");
    
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

<!-- Link to Sweet Alert  -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/2.1.0/sweetalert.min.js"></script>


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
    text-align: center;
    font-size: 2rem;
    line-height: 2.7rem;
    border-color: steelblue;
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


<!-- hidden input field for checking status -->
	<input type="hidden" id="status" value=<%=request.getAttribute("statusOfViewPage")%>>

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
				
				<a href="../AnytimeFileAccess/LogoutServlet" style="text-decoration:none">
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
	
	<button type="button"  class="fixed-button"
    data-bs-toggle="modal" data-bs-target="#uploadModal" data-bs-whatever="@mdo">
    <i class="fa-solid fa-plus"></i>
    </button>
	

	<!-- Modal for uploading files -->
<div class="modal fade" id="uploadModal" tabindex="-1" aria-labelledby="uploadModalLabel" aria-hidden="true">

    <div class="modal-dialog">

      <div class="modal-content">

        <!-- Heading of Modal -->

        <div class="modal-header">

          <h1 class="modal-title fs-5" id="uploadModalLabel"><img src="https://res.cloudinary.com/footprints23/image/upload/v1682371987/upload_tfuey7.png" alt="UploadIcon"
              style="width: 22px; height: 22px" />&nbsp;&nbsp;File Upload</h1>

          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>

        </div>

        <!-- Body of Modal contains Form  -->

        <div class="modal-body">

          <!-- Form Of File Details  action="../AnytimeFileAccess/UploadFileServlet" -->
          <form method="post"   id="uploadFileFORM" enctype='multipart/form-data'>

            <div class="mb-3">

              <!-- 1) Select file -->
              <label for="formFile" class="form-label">Select document</label>
              <input class="form-control" type="file" id="formFile" name="fileSelected"
                accept="image/*, application/pdf" required>

            </div>

            
              <!-- 2) Choose Category -->
            <div class="mb-3">

              <label for="category-select" class="form-label">Category</label>

              <select class="form-select" id="category-select" name="category">
                <option value="Personal">Personal</option>
                <option value="Government">Government</option>
                <option value="Office">Office</option>
                <option value="Education">Education</option>
                <option value="Health">Health</option>
                <option value="Finance">Finance</option>
                <option value="Other">Other</option>
              </select>

              <!-- 2.1) If "other" chosen -->
              <div id="other-category" class="form-floating d-none">

                <input type="text" class="form-control" id="other-category-input" name="otherCategory" placeholder="Specify category">
                <label for="other-category-input">Specify category</label>

              </div>

            </div>

            <!-- 3) Choose Expiary date if Available -->

            <div class="mb-3 form-check">
              <input type="checkbox" class="form-check-input" id="expiry-checkbox">
              <label class="form-check-label" for="expiry-checkbox">Add Expiry Date</label>
            </div>

            <!-- 3.1) Only if checkbox is checked -->
            <div class="mb-3 d-none" id="expiry-date">
              <label for="expiry-date-input" class="form-label">Expiry Date</label>
              <input type="date" class="form-control" id="expiry-date-input" name="expiryDate">
            </div>

            <div class="mb-3">
              <label for="description-input" class="form-label">Description</label>
              <textarea class="form-control" id="description-input" name="desc" placeholder="Enter a description..." required></textarea>
            </div>

            <div class="modal-footer">
              <button type="submit" class="btn btn-primary">Upload</button>
            </div>

          </form>


        </div>

      </div>

    </div>

  </div>

	<!-- Link to Bootstrap JS -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.min.js"></script>


  <script>

  /* Upload Button submitted */
  
  $(document).ready(function() {
	  
  $("#uploadFileFORM").submit(function(event) {
	  
    event.preventDefault(); // Prevent default form submission

    $.ajax({
      url: "../AnytimeFileAccess/UploadFileServlet",
      type: "POST",
      data: new FormData(this),
      processData: false,
      contentType: false,
      success: function(response) {
        console.log("Response : " , response); // Log the response from the server

        // Reload Page 
        location.reload(true);
        
      },
      error: function(jqXHR, textStatus, errorThrown) {
        console.log(errorThrown); // Log the error message
      }
    });
  
  });
  
});


    /* If user select "other" , Textfiled open */
    const categorySelect = document.querySelector('#category-select');
    const otherCategory = document.querySelector('#other-category');

    categorySelect.addEventListener('change', () => {
      if (categorySelect.value === 'Other') {
        otherCategory.classList.remove('d-none');
        otherCategory.querySelector('input').setAttribute('required', '');
      } else {
        otherCategory.classList.add('d-none');
        otherCategory.querySelector('input').removeAttribute('required');
      }
    });

    /* If there is an Expiray date(Checkbox is checked) then and then date is visible */
    const expiryCheckbox = document.querySelector('#expiry-checkbox');
    const expiryDate = document.querySelector('#expiry-date');

    expiryCheckbox.addEventListener('change', () => {
      if (expiryCheckbox.checked) {
        expiryDate.classList.remove('d-none');
        expiryDate.querySelector('input').setAttribute('required', '');
      } else {
        expiryDate.classList.add('d-none');
        expiryDate.querySelector('input').removeAttribute('required');
      }
    });

  </script>
  
</body>

</html>