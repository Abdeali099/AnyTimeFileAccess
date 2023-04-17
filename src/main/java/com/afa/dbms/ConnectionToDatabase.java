package com.afa.dbms;

import java.sql.DriverManager;
//import java.io.File;
import java.io.FileInputStream;
import java.sql.Connection;
import java.util.Properties;

public class ConnectionToDatabase {

	/* <---- static attribute ----> */

	private static Connection connection;

	/* <---- Only One time execute ----> */

	static {

		try {

			/* Registering Driver class for 'mysql' */
			Class.forName("com.mysql.cj.jdbc.Driver");

			/* Initialize connection object */
			connection = null;

		} catch (Exception exception) {
			System.out.println(" => Error at static block Database connection : " + exception);
		}

	}

	/* <---- On objection creation Connection should established ----> 
	 * 
	 * Note : Create object only in LoginServlet,SignupServlet so constructor will be call (only once).
	 *        
	 * */

	public ConnectionToDatabase() {
		
		String url="",username="",password=""; 
		
		/* Fetching Data from credential.props */
		
		try {

			String path = "E:\\AJT_Project\\AnytimeFileAccess\\src\\assets\\credential.props";
			
			/* Problem : No getting context path, it works on absolte path which will differ
			 * for all so need to change !!
			 * 
			 *  File file=new File("E:\\AJT_Project\\AnytimeFileAccess\\src\\assets\\credential.props");
			System.out.println(file.getAbsolutePath());
			System.out.println(file.getPath()); */
			
			FileInputStream fis = new FileInputStream(path);
			Properties prop = new Properties();
			prop.load(fis);

			 url = prop.getProperty("url");
			 username = prop.getProperty("userName");
			 password = prop.getProperty("password");
			 
		} catch (Exception exception) {
			System.out.println("=> Error at fetching Props : " + exception);
		}

		/* Establishing Connection  */
		
		try {
			connection = DriverManager.getConnection(url, username, password);	
			System.out.println("Connection : " + connection);
		} catch (Exception exception) {
			System.out.println("=> Error at Creating connection : " + exception);
		}
		
		
	}
	
	/* <---- Whenever connection need call this via Class (ConnectionToDatabase.getConnection) ---->*/

	/* Note :  Call by object in Login/Signup */
	
	public static Connection getConnection() {
		
		try {
			return connection;
		}

		catch (Exception exp) {
			System.out.println("=> Error at returning connection : " + exp);
			return null;
		}

	}

}
