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
public class SignupServlet extends HttpServlet {

    @SuppressWarnings("static-access")
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        /* <-- Global Objects ---> */

        Connection connection = null;
        RequestDispatcher requestDispatcher = null;
        PreparedStatement psForEmailValidation = null, psForStoreData = null;
        ResultSet rsForEmailValidation = null;
        HttpSession session = null;

        /* <-- Global variables --> */

        String userEmail = "", userPassword = "", userName = "", userPhone = "";

        try {
            /* <--- get details from Signup.jsp ---> */

            userName = request.getParameter("afa_username");
            userEmail = request.getParameter("afa_email");
            userPhone = request.getParameter("afa_phone");
            userPassword = request.getParameter("afa_password");

            /* <-- Getting Connection --> */
            ConnectionToDatabase connectionToDatabase = new ConnectionToDatabase();
            connection = connectionToDatabase.getConnection();

            if (connection == null) {

                System.out.print("\n=> Error In SignUpServlet database connection ");

                /* <-- Keep It to Signup Page --> */

                request.setAttribute("status", "databaseError");
                requestDispatcher = request.getRequestDispatcher("Signup.jsp");
                requestDispatcher.forward(request, response);
            }

            else {

                /* <-- Checking user is already exist or not : duplicate email case --> */

                String queryForMailValidation = "select * from signup where email = ? ;";

                psForEmailValidation = connection.prepareStatement(queryForMailValidation);
                rsForEmailValidation = psForEmailValidation.executeQuery();

                /* <-- Email Id already in used --> */

                if (rsForEmailValidation.next()) {
                    psForEmailValidation.close();
                    rsForEmailValidation.close();
                    connection.close(); /* New Connection will established */

                    request.setAttribute("status", "failed");
                    requestDispatcher = request.getRequestDispatcher("Signup.jsp");
                    requestDispatcher.forward(request, response);
                }

                /* <-- True new user--> */

                else {
                    psForEmailValidation.close();
                    rsForEmailValidation.close();

                    /* <--- Details are Store to database ---> */

                    String queryForStoreData = "insert into signup values(?,?,?,?); ";

                    psForStoreData = connection.prepareStatement(queryForStoreData);

                    psForStoreData.setString(1, userName);
                    psForStoreData.setString(2, userEmail);
                    psForStoreData.setString(3, userPhone);
                    psForStoreData.setString(4, userPassword);

                    int rowCount = psForStoreData.executeUpdate();

                    /* <-- Successfully Added --> */

                    if (rowCount > 0) {
                        if (psForStoreData != null) {
                            psForStoreData.close();
                        }

                        session = request.getSession();
                        session.setAttribute("afa_username", userName);
                        session.setAttribute("afa_email", userEmail);

                        request.setAttribute("status", "success");
                        requestDispatcher = request.getRequestDispatcher(".\\MainPage\\ViewPage.jsp");
                        requestDispatcher.forward(request, response);
                    }

                    /* <-- Failure --> */

                    else {
                        if (psForStoreData != null) {
                            psForStoreData.close();
                        }

                        connection.close(); /* New Connection will established */

                        request.setAttribute("status", "failed");
                        requestDispatcher = request.getRequestDispatcher("Signup.jsp");
                        requestDispatcher.forward(request, response);

                    }

                }

            }

        } catch (Exception e) {

            System.out.print("\n => Error at Inside SignupServlet : " + e);

            try {

                if (connection != null) {
                    connection.close(); /* New Connection will generated */
                }

            } catch (Exception e1) {
                // TODO Auto-generated catch block
                e1.printStackTrace();
            }

            request.setAttribute("status", "failed");
            requestDispatcher = request.getRequestDispatcher("Signup.jsp");
            requestDispatcher.forward(request, response);

        } finally {

            try {

                if (psForEmailValidation != null) {
                    psForEmailValidation.close();
                }

                if (psForStoreData != null) {
                    psForStoreData.close();
                }

                if (rsForEmailValidation != null) {
                    rsForEmailValidation.close();
                }

            } catch (Exception e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }

    }
}
