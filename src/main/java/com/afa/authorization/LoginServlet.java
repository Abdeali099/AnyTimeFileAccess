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

			// add cookies
			Cookie pswd = new Cookie("password", password);
			Cookie emailId = new Cookie("email", email);

			response.addCookie(pswd);
			response.addCookie(emailId);
			

			/* <-- Getting Connection -->*/
			ConnectionToDatabase connectionToDatabase=new ConnectionToDatabase();
			con = connectionToDatabase.getConnection();
			
			if (con == null) {
				System.out.print("\n In LogInServlet : Error connecting to database");
			} else {
				String query = "select * from signup where email = '" + email + "' and password = '" + password + "'";
				Statement stmt = (Statement) con.createStatement();
				ResultSet rs = stmt.executeQuery(query);
				if (!rs.next()) {
					response.sendRedirect(".\\HelperPages\\error.html");
				}

				else {
					// call main page (upload file page)
					// out.print("user exists");
				}

			}

		} catch (Exception e) {
			System.out.print("\n Inside LogInServlet class - Exception occurred : " + e.getMessage());
		}
	}
}
