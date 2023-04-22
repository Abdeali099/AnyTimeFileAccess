package com.afa.authorization;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.afa.dbms.*;


@SuppressWarnings("serial")
public class LoginServlet extends HttpServlet {

    // @SuppressWarnings("static-access")
    @SuppressWarnings("static-access")
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        /* <-- Global Objects ---> */

        Connection connection = null;
        RequestDispatcher requestDispatcher = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        HttpSession session = null;

        /* <-- Global variables --> */

        String userEmail = "", userPassword = "", userName = "";

        try {

            /* get details of user */

            userEmail = request.getParameter("afa_email");
            userPassword = request.getParameter("afa_password");

            /* <-- Getting Connection --> */

            ConnectionToDatabase connectionToDatabase = new ConnectionToDatabase();
            connection = connectionToDatabase.getConnection();

            if (connection == null) {

                System.out.print("\n In LogInServlet : Error connecting to database");

                /* <-- Keep It to Login Page --> */

                request.setAttribute("status", "databaseError");
                requestDispatcher = request.getRequestDispatcher("Login.jsp");
                requestDispatcher.forward(request, response);
            }

            else {

                String preparedQuery = "select * from user_details where email = ? and password = ? ;";
                preparedStatement = connection.prepareStatement(preparedQuery);
                preparedStatement.setString(1, userEmail);
                preparedStatement.setString(2, userPassword);

                resultSet = preparedStatement.executeQuery();

                /* <-- User Not exist !!! --> */
                if (!resultSet.next()) {
                    preparedStatement.close();
                    resultSet.close();
                    connection.close(); /* New Connection will established */

                    request.setAttribute("status", "failed");
                    requestDispatcher = request.getRequestDispatcher("Login.jsp");
                    requestDispatcher.forward(request, response);
                }

                /* <-- User exist !!! --> */

                else {

                    /* Getting userName */

                    userName = resultSet.getString("username");

                    preparedStatement.close();
                    resultSet.close();

                    /* Setting Session Attribute */

                    session = request.getSession();
                    session.setAttribute("afa_username", userName);
                    session.setAttribute("afa_useremail", userEmail);

                    /* Redirect to MainPage */
                    
                    /*  !!! Not Working !!
                    request.setAttribute("status", "success");  */
                    
                    /* Trying to Prevent user to It Can't get Login Page after Redirect */
					/*
					 * response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
					 * response.setHeader("Pragma", "no-cache");
					 *  response.setHeader("Expires", "0");
					 */
                    requestDispatcher = request.getRequestDispatcher(".\\MainPage\\ViewPage.jsp");
                    requestDispatcher.forward(request, response);

                }

            }

        } catch (Exception e) {

            System.out.print("\n => Error at Inside LogInServlet : " + e);

            try {

                if (connection != null) {
                    connection.close(); /* New Connection will generated */
                }

            } catch (Exception e1) {
                // TODO Auto-generated catch block
                e1.printStackTrace();
            }

            
            request.setAttribute("status", "failed");
            requestDispatcher = request.getRequestDispatcher("Login.jsp");
            requestDispatcher.forward(request, response);

        } finally {

            try {

                if (preparedStatement != null) {
                    preparedStatement.close();
                }

                if (resultSet != null) {
                    resultSet.close();
                }

            } catch (Exception e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }

        }
    }
}
