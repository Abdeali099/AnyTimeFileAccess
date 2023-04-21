<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Log-in | AnytimeFileAccess</title>

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

	<input type="hidden" id="status" value=<%=request.getAttribute("status")%>>

    <div class="container bs-example">

        <div class="container">
            <h2 style="font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">Anytime File Access</h2>
        </div>

        <br>
        <br>

        <!-- action="LoginServlet" method="POST"  -->

        <form action="LoginServlet" method="post" id="loginFORM">

            <br>
            <br>

            <div class="mb-3 row">
                <label for="afa_email" class="col-sm-2 col-form-label label-font">Email</label>
                <div class="col-sm-10">
                    <input type="email" name="afa_email" id="afa_email" class="form-control" required>
                </div>
            </div>


            <br>
            <br>

            <div class="mb-3 row">
                <label for="afa_password" class="col-sm-2 col-form-label label-font">Password</label>
                <div class="col-sm-10">
                    <input type="password" name="afa_password" id="afa_password" class="form-control" required>
                </div>
            </div>

            <br>
            <br>

            <input type="submit" value="Login" class="form-control btn btn-primary">

            <br>
            <br>

            <h4 style="font-family: Verdana, Geneva, Tahoma, sans-serif;">
                Not have an account?
                <a href="./Signup.jsp"> Click here to Create an account</a>
            </h4>

        </form>

    </div>

</body>

	<script>
	
	
	/* When Form is submitted */
	
	    $(document).ready(function () {
            $('#loginFORM').submit(function (event) {
                 // event.preventDefault();                 
        	});
        });
	
	
	let status = document.getElementById("status").value;
	
	/* if(status == "success"){
		swal("Congrats", "Loged-In successfully", "success");
	} */
  	
  	if(status == "failed")
  	{
  		swal("Error 404", "Wrong username or password", "error");
  	}
  	
  	if(status == "databaseError"){
  		swal("Error 500", "Internal server error", "error");
  	}
  	
	</script>


</html>