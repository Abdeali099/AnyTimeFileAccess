package com.afa.authorization;

import java.io.IOException;
import java.sql.Connection;

import com.afa.dbms.ConnectionToDatabase;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


/**
 * Servlet implementation class LogoutServlet
 */

@WebServlet(description = "LogoutUser", urlPatterns = { "/LogoutServlet" })

public class LogoutServlet extends HttpServlet {
	
 
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
		/* Closing connection with dataBase */
		
		try {
			Connection connection=ConnectionToDatabase.getConnection();
			
			if (connection!=null) {
				connection.close();
			}
			
		}catch(Exception e) {
			System.out.println("=> Error at logout Closing connection : " + e);
		}
		
		/* Destroying session */
		HttpSession session = request.getSession();
		
		session.setAttribute("afa_username",null);
	
		RequestDispatcher requestDispatcher = request.getRequestDispatcher(".\\MainPage\\ViewPage.jsp");
        requestDispatcher.forward(request, response);
		
        // session.invalidate(); !!! Not Working !!!
        
		/* Redirect to Login Page  : I should use this but It is not working*/
		//response.sendRedirect("http://localhost:8090/AnytimeFileAccess/Login.jsp");
		
	}

	
}
