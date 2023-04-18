package com.afa.authorization;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.afa.dbms.*;

@SuppressWarnings("serial")
public class SignupServlet extends HttpServlet
{
	Connection con=null;
	@SuppressWarnings("static-access")
	public void init()
	{
		try
		{
			/* <-- Getting Connection -->*/
			ConnectionToDatabase connectionToDatabase=new ConnectionToDatabase();
			con = connectionToDatabase.getConnection();
			
			if(con == null)
			{
				System.out.print("\n Error connecting to database");
			}
		}
		catch(Exception e)
		{
			System.out.print("\n In init method of SignUpServlet : "+e.getMessage());
		}
	}
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException
	{
		try
		{
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			
			// get details of user
			
			String username = request.getParameter("username");
			String email = request.getParameter("emailId");
			String password = request.getParameter("pswd");
			String phone = request.getParameter("phn");
			
			//
			// add cookies
			Cookie uname = new Cookie("username",username);
			Cookie pswd = new Cookie("password",password);
			Cookie emailId = new Cookie("email",email);
			Cookie phn = new Cookie("phone",phone);
			
			response.addCookie(uname);
			response.addCookie(pswd);
			response.addCookie(emailId);
			response.addCookie(phn);
			//
			
			
			
			String query1 = "select * from signup where email = '"+email+"'";
			Statement stmt1 = (Statement) con.createStatement();
			ResultSet rs = stmt1.executeQuery(query1);
			
			if(rs.next())
			{
				response.sendRedirect("..\\HelperPages\\UserAlreadyExists.html");
				stmt1.close();
				con.close();
			}
			
			else
			{
				Statement stmt = con.createStatement();
				String query = "insert into signup values('"+username+"', '"+ email+"','"+phone+"' , '"+ password+"')";
				stmt.executeUpdate(query);
				
				stmt.close();
				con.close();
			}
			
			
			
			
			
		}
		catch(Exception e)
		{
			System.out.print("\n Inside SignUpServlet class - Exception occurred : "+e.getMessage());
		}
	}
}
