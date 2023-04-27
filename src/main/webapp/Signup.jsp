<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Sign Up | AnytimeFileAccess</title>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>

    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/2.1.0/sweetalert.min.js"></script>

    <style>

        .bs-example {
            text-align: center;
            border-radius: 20px;
            margin-top: auto;
            box-shadow: 4px 4px 4px 4px lightblue;
            margin-top: 80px;
        }

        .label-font {
            font-size: 15px;
            font-family: Verdana, Geneva, Tahoma, sans-serif;

        }
    </style>

</head>

<body>

    <!-- hidden input field for checking status -->
    <input type="hidden" id="status" value=<%= request.getAttribute("status") %> >

    <div class="container bs-example">

        <div class="container">
            <h2 style="font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">Anytime File Access</h2>
        </div>

        <br><br>

        <form action="SignupServlet" method="POST" id="signupFORM">

            <div class="mb-3 row">
            
                <label for="afa_username" class="col-sm-2 col-form-label label-font">User Name</label>
                
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="afa_username" name="afa_username" required
                        pattern="[a-zA-Z][a-zA-Z0-9]+" minlength="6" maxlength="15"
                        placeholder="No special chracter, length : min 6 to max 15">
                </div>

            </div>

            <br><br>


            <div class="mb-3 row">
                
                <label for="afa_email" class="col-sm-2 col-form-label label-font">Email</label>
                
                <div class="col-sm-10">
                    <input type="email" class="form-control" id="afa_email" name="afa_email" required
                        placeholder="eg) xyz123@gmail.com">
                </div>

            </div>

            <br><br>

            <div class="mb-3 row">
                
                <label for="afa_phone" class="col-sm-2 col-form-label label-font">Phone </label>
                
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="afa_phone" name="afa_phone" required
                        pattern="[6-9][0-9]+" minlength="10" maxlength="10"
                        placeholder="eg) 7434870170 (Indian numbers only)">
                </div>

            </div>


            <br><br>

            <div class="mb-3 row">
                
                <label for="afa_password" class="col-sm-2 col-form-label label-font">Password</label>
            
                <div class="col-sm-10">
                    <input type="password" class="form-control" id="afa_password" name="afa_password" required
                        pattern="[a-zA-Z][a-zA-Z0-9@&_]+" minlength="6" maxlength="15"
                        placeholder="Length : min 6 to max 15">
                </div>

            </div>

            <br><br>

            <input type="submit" class="form-control btn btn-primary" value="Register">

        </form>

    </div>

</body>


	

	<script>
	
	/* When Form is submitted signupFORM */
	
	 $(document).ready(function () {
         $('#loginFORM').submit(function (event) {
           //  event.preventDefault();                 
     	});
     });
	
	let status = document.getElementById("status").value;
	
	console.log("STATUS : "+ status); 
  	
	/* if(status == "success"){
		swal("Congrats", "Account Created Successfully", "success");
	} */
	
  	if(status == "failed")
  	{
  		swal("Error 404", "Details are not proper", "error");
  	}
	

  	if(status == "invalidMail")
  	{
  		swal("Error 404", "Invalid E-mail id", "error");
  	}
  	
  	if(status == "databaseError"){
  		swal("Error 500", "Internal server error", "error");
  	}
  
	</script>
	
	

</html>