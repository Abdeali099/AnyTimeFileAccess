package com.afa.crud;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import com.afa.dbms.ConnectionToDatabase;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class UpdateFileDetail extends HttpServlet {
	public void doPost(HttpServletRequest req,HttpServletResponse res) throws IOException, ServletException {
		String id=req.getParameter("file-id");
		String name=req.getParameter("file-name");
		String desc=req.getParameter("file-desc");
		String category=req.getParameter("file-type");
		String expiryDate=req.getParameter("expiry-date");
		LocalDate lastModified = LocalDate.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		String formattedDate = lastModified.format(formatter);
		
		
		//System.out.println(formattedDate);
//		System.out.println(id);
//		System.out.println(name);
//		System.out.println(category);
//		System.out.println(expiryDate);
//		System.out.println(formattedDate);
		
		 String query="";
		 PreparedStatement pstmt=null;
		 Connection con=null;
//		 //Prepared Statement
		 try {
			  con = ConnectionToDatabase.getConnection();
			 
			 if (con == null) {

	                System.out.print("\n In UpdateFileDetail : Error connecting to database");  
	            }
			 else {
				 query="update files_details set file_name=?, category=?, expiry_date=?, date_modified=?,description=? where id=?";
				 pstmt=con.prepareStatement(query);
					//Set the value of parameter
					pstmt.setString(1, name);
					pstmt.setString(2,category);
					pstmt.setString(3, expiryDate);
					pstmt.setString(4,formattedDate);
					pstmt.setString(5,desc);
					
					pstmt.setInt(6,Integer.parseInt(id) );
					pstmt.executeUpdate();
					System.out.print("Updated Sucessfully");
			 }
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			System.out.println("Error in Update Detail SQL");
			e.printStackTrace();
		} finally {

            try {

                if (pstmt != null) {
                    pstmt.close();
                }


            } catch (Exception e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }

        }

	}
}
