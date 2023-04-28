package com.afa.authorization;

import java.io.IOException;
import java.net.InetAddress;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

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
                return; 
            }

            else {

                /* <-- Checking user is already exist or not : duplicate email case --> */

                String queryForMailValidation = "select * from user_details where email = ? ;";

                psForEmailValidation = connection.prepareStatement(queryForMailValidation);
                psForEmailValidation.setString(1, userEmail);
                rsForEmailValidation = psForEmailValidation.executeQuery();

                /* <-- Email Id already in used --> */

                if (rsForEmailValidation.next()) {
                    psForEmailValidation.close();
                    rsForEmailValidation.close();
                    connection.close(); /* New Connection will established */

                    request.setAttribute("status", "failed");
                    requestDispatcher = request.getRequestDispatcher("Signup.jsp");
                    requestDispatcher.forward(request, response);
                    return; 
                }

                /* <-- True new user--> */

                else {	
                    psForEmailValidation.close();
                    rsForEmailValidation.close();

                    /* <--- Sending Confirmation Email  ---> */
                   
                    String PORT=""+request.getServerPort();
                    boolean isMailSent=sendConfirmationMail(userName,userEmail,PORT);
                    
                    if (!isMailSent) {
						/* Mail is not sent : Mail is not proper */
                    	 request.setAttribute("status", "invalidMail");
                         requestDispatcher = request.getRequestDispatcher("Signup.jsp");
                         requestDispatcher.forward(request, response);
                         return;
					}
                    
                    /* <--- Details are Store to database ---> */

                    String queryForStoreData = "insert into user_details values (?,?,?,?) ;";

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
                        session.setAttribute("afa_useremail", userEmail);

                        /*  !!! Not Working !!
                        request.setAttribute("status", "success");  */
                        requestDispatcher = request.getRequestDispatcher(".\\MainPage\\ViewPage.jsp");
                        requestDispatcher.forward(request, response);
                        return; 
                        
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
                        return; 

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
            return; 

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

	private boolean sendConfirmationMail(String userName, String userEmail,String PORT) {
		
			/* Setting AFA credential */
			final String afa_email_id = "anytimefileaccess@gmail.com";
	        final String afa_email_password = "mmnhywyvyaewzvbt";
	        
	        /* Set up the properties for the email server : Gmail server */
	        Properties props = new Properties();
	        props.put("mail.smtp.host", "smtp.gmail.com");
	        props.put("mail.smtp.port", "587");
	        props.put("mail.smtp.auth", "true");
	        props.put("mail.smtp.starttls.enable", "true");

	        try {
	         
	        /* Authinticate AFA with credential and create session */
	        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
	            protected PasswordAuthentication getPasswordAuthentication() {
	                return new PasswordAuthentication(afa_email_id, afa_email_password);
	            }
	        });

        	
	        /* Creating Meassage to send via Mail */
	      	InetAddress inetAddress = InetAddress.getLocalHost();
        	String IP_Of_Client=inetAddress.getHostAddress();
     
	        String URL="http://"+IP_Of_Client+":"+PORT+"/AnytimeFileAccess/Login.jsp";
	        
	        Message message = new MimeMessage(session);
	        message.setFrom(new InternetAddress(afa_email_id));
	        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(userEmail));
	        message.setSubject("AFA account created successfully");
	        message.setText("Hello " + userName 
	        		+ "\n !! Welome to Anytime File Access !!"
	        		+ "\n => Your account  created successfully , Now you can access your documents from anywhere anytime."
	        		+ "\n Login here : "
	        		+ URL);
	         
	        Transport.send(message);
 	        
        }catch (Exception e) {
			System.out.println("\n => Error in sending confirmation mail : " + e);
			return false;
		}
		
		return true;
	}
}
