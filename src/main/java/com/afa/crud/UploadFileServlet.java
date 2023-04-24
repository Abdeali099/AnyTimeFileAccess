package com.afa.crud;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.afa.dbms.ConnectionToDatabase;
import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@SuppressWarnings("serial")
@WebServlet("/UploadFileServlet")
@MultipartConfig
public class UploadFileServlet extends HttpServlet {
	
	/* File - Variable  */
	
	private String fileName,category,otherCategory,expiryDate,description,fileURL,fileSize,uploadedDate;
	
	/*Init Method : Only one time establish connection */
	
		/* Connnection Object */
		Connection connection = null;
		
	@Override
	public void init() throws ServletException {
		
		try {

			connection = ConnectionToDatabase.getConnection();

			if (connection == null) {
				System.out.print("\n In uploading servlet  Error : connecting to database");
				return;
			}

		} catch (Exception exception) {

			System.out.println("=> Error at DB connection uploading servlet :  " + exception);

		}

		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	
		if (connection==null) {
			System.err.println("=> Error : Connection is null");
			return;
		}
		
		/* <---- If database connection is successfull ----> */

		/* Taking parameter from 'request' object */

		try {

			 Part fileSelected = request.getPart("fileSelected"); 
			 fileName =fileSelected.getSubmittedFileName();
			 
			 long size = fileSelected.getSize(); 
			 size = size/1024L; 
			 fileSize =Long.toString(size) + " KB";

			 category = request.getParameter("category");
			 otherCategory = request.getParameter("otherCategory");
	
			 expiryDate = request.getParameter("expiryDate");
			 
			 if (expiryDate.isEmpty() || expiryDate==null) {
				 expiryDate="";
			}
			 
			 description = request.getParameter("desc");

			// -> Initially date created and modified will be same
			Date date = new Date();
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
			 uploadedDate = formatter.format(date);
			
				/*
				 * System.out.println(" 1) " + fileName); 
				 * System.out.println(" 2) " +fileSize);
				 * System.out.println(" 3) " +category); 
				 * System.out.println(" 4) " +otherCategory); 
				 * System.out.println(" 5) " +description);
				 * System.out.println(" 6) " +expiryDate); 
				 * System.out.println(" 7) " +uploadedDate);
				 */
			
			/* Saving File to cloudinary */
			
			boolean isFileSavedToCloudinary=saveFileToCloudinary(fileSelected,request);
			
			/* Saving data to Database */
			
			if (isFileSavedToCloudinary) {
			  
			  saveDataToDataBase(request,response);
			  
			  }
		

		} catch (Exception exception) {

			System.out.println("=> Error at UploadServlet Fetching data from Request Object :  " + exception);

		}

	}

	@SuppressWarnings("deprecation")
	private boolean saveFileToCloudinary(Part fileSelected, HttpServletRequest request) throws Exception {
		
		/* Objects */
		
		InputStream inputStream=null;
		FileOutputStream fileOutputStream=null; 
		
		try {

			/* Setting File to folder (Temporary ) */

			/* Taking input stream from file*/
			inputStream = fileSelected.getInputStream();
			
			/* data will be stored in this array */
			byte[] data = new byte[inputStream.available()];
			inputStream.read(data);

			/* This refer to server path (used temporary) */
			String myPath = request.getRealPath("/") + fileName;

			System.out.println("Path : " + myPath);

			/* Configure FileOutputStream */
			fileOutputStream = new FileOutputStream(myPath);
			fileOutputStream.write(data);

			/* Only file object can pass as parameter in upload() */
			File file = new File(myPath);

			/* Configure Cloudinary accocunt where data will store */
			Map config = new HashMap();
			config.put("cloud_name", "dio7sp8nb");
			config.put("api_key", "932688191116721");
			config.put("api_secret", "pXYPzXaJHYgbNQjMYbEN5AuM1X4");
			Cloudinary cloudinary = new Cloudinary(config);
			
			/* Uploading data to cloudinary */
			Map<String, Object> result = cloudinary.uploader().upload(file, ObjectUtils.asMap("public_id", fileName));

			/* getting the public URL of the uploaded file */
			fileURL = (String) result.get("url");
			
			/* Deleting File (Permnantly saved in cloudinary) */
			file.delete();

		} catch (IOException exception) {
			System.out.println("=> Error at clodinary logic : " + exception);
			return false;
		}finally {
			if(fileOutputStream!=null) {
				fileOutputStream.close();
			}
			if(inputStream!=null) {
				inputStream.close();
			}
		}
		
		return true;
		
	}


	private void saveDataToDataBase(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
		
		/* Getting user email from session */
		
		HttpSession session=request.getSession();
		
		String loggedInUserEmail=(String)session.getAttribute("afa_useremail");
		     
		if(loggedInUserEmail==null || loggedInUserEmail.isEmpty()){
		    
			System.out.println("Email is not in session");
			
		    response.sendRedirect("../AnytimeFileAccess/Login.jsp");
		    
		    return;
		    
		 }
		
		
		/* Database objects */
		PreparedStatement preparedStatement=null;
		
		try {
			
		preparedStatement = connection.prepareStatement("INSERT INTO files_details (owner,file_name,file_size,category,url,date_created,date_modified,description,expiry_date) VALUES (?,?,?,?,?,?,?,?,?) ");
		
		preparedStatement.setString(1,loggedInUserEmail);
		preparedStatement.setString(2,fileName);
		preparedStatement.setString(3,fileSize);
		
		 
		 if (category.equalsIgnoreCase("Other")) {
			 preparedStatement.setString(4,otherCategory);
		}
		 else {
			 preparedStatement.setString(4,category);
		}
		 		
		preparedStatement.setString(5,fileURL);
		preparedStatement.setString(6,uploadedDate);
		preparedStatement.setString(7,uploadedDate);
		preparedStatement.setString(8,description);
		preparedStatement.setString(9,expiryDate);
		
		int rowAffect = preparedStatement.executeUpdate();
		
		 if (rowAffect!=1) { 
			 System.out.println("*File data Not Saved To Database!"); 
			 return;
		 }
			
		} catch (Exception e) {
			System.out.println("=> Error in saving file data in databse : " + e);
			return;
		
		}finally {
			
			if (preparedStatement!=null) {
				preparedStatement.close();
			}
			
			
		}
		     
		
	}	
	
}
