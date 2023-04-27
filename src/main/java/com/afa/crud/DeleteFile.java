package com.afa.crud;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;


import com.afa.dbms.ConnectionToDatabase;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class DeleteFile extends HttpServlet {
	public void doPost(HttpServletRequest req,HttpServletResponse res) throws IOException, ServletException {
		String id=req.getParameter("file-id");
		
		
		
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

	                System.out.print("\n In DeleteFile : Error connecting to database");  
	            }
			 else {
				  query="delete from files_details where id=?";		
				  pstmt=con.prepareStatement(query);
					//Set the value of parameter
					
					pstmt.setInt(1,Integer.parseInt(id) );
					pstmt.executeUpdate();
					System.out.print("Deleted Sucessfully");
			 }
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
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
