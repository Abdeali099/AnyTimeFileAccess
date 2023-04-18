package com.afa.authorization;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.afa.dbms.*;

@SuppressWarnings("serial")
public class LoginServlet extends HttpServlet {
	
	@SuppressWarnings("static-access")
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		Connection con = null;
		
		try {
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();

			// get details of user

			String email = request.getParameter("emailId");
			String password = request.getParameter("pswd");

			// add cookies;
			Cookie pswd = new Cookie("afa_password",password);
			Cookie emailId = new Cookie("afa_email",email);

			response.addCookie(pswd);
			response.addCookie(emailId);
			
			/* Here also add userName Cookie !!! */
			
			/* <-- Getting Connection -->*/
			ConnectionToDatabase connectionToDatabase=new ConnectionToDatabase();
			con = connectionToDatabase.getConnection();
			
			Statement stmt=null;
			ResultSet rs =null;
			
			
			if (con == null) {
				System.out.print("\n In LogInServlet : Error connecting to database");
			} else {
				
				String query = "select * from signup where email = '" + email + "' and password = '" + password + "'";
				 stmt = (Statement) con.createStatement();
				 rs = stmt.executeQuery(query);
				
				
				if (!rs.next()) {
					stmt.close();
					rs.close();
					response.sendRedirect(".\\HelperPages\\error.html");
				}

				else {
					
					/* Getting userName */
					
					String user_name=rs.getString("username");
					Cookie uname = new Cookie("afa_username",user_name);
					response.addCookie(uname);
					
					stmt.close();
					rs.close();
					
					/* Redirect to MainPage */
					response.sendRedirect(".\\MainPage\\MainPage.html");
				}

			}

		} catch (Exception e) {
			System.out.print("\n Inside LogInServlet class - Exception occurred : " + e.getMessage());
		}
	}
}
