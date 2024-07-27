import java.sql.*;
import java.util.Scanner;

public class DB3 {

    private static final String dbName= "DB84"; // Input your database name
    private static final String dbUser= "G584"; // input user that has access to the database
    private static final String dbPassword= "348g4_2r0"; // input user's password    

    public static void main(String args[]) {

    	Connection dbcon = null;
        
        String url = "jdbc:sqlserver://sqlserver.dmst.aueb.gr:1433;"
         + "databaseName=" + dbName + ";user=" + dbUser + ";password=" + dbPassword + ";encrypt=true;trustServerCertificate=true;";

        
        /* Step 1 -> Dynamically load the driver's class file into memory */
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch(java.lang.ClassNotFoundException e) { 
            System.out.println("ClassNotFoundException: " + e.getMessage());
            System.exit(0);
        }
        
        /*
		 * Step 2 -> Establish a connection with the database and initializes the Connection object (dbcon)
		 */
		try {

			dbcon = DriverManager.getConnection(url);			

		} catch (SQLException e) {			
			System.out.println("SQLException: " + e.getMessage());
			System.exit(0);
			
		}        
        
        /* Execute SQL statements */
        try {           
            
            Scanner sc = new Scanner(System.in);
            System.out.print("Enter the customer code you want to delete: ");
            int userInput = sc.nextInt();

            PreparedStatement pstmt = dbcon.prepareStatement("DELETE FROM orders WHERE custcode = " + userInput + ";" + 
                                                                "DELETE FROM customer WHERE custcode = " + userInput + ";");
            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                System.out.println("Customer and related data deleted successfully.");
            } else {
                System.out.println("This customer code doesn't exist in the database.");
                
            sc.close();
    }
        } catch(SQLException e) {

            System.out.println("SQLException: " + e.getMessage());            

        } finally {
            try {
                dbcon.close();
            } catch (SQLException e) {

            }
        }
    }
}