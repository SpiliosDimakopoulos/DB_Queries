import java.sql.*;
import java.util.Scanner;

public class DB4 {

    private static final String dbName= "dbName"; // Input your database name
    private static final String dbUser= "dbUser"; // input user that has access to the database
    private static final String dbPassword= "dbPassword"; // input user's password    

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
            System.out.print("Enter the order code you want to see: ");
            int userInput = sc.nextInt();

            try (PreparedStatement pstmt = dbcon.prepareStatement(
                "SELECT ordcode, orderDate, shipDate, prcode, custcode FROM orders WHERE ordcode = " + userInput)) {

                try (ResultSet rs = pstmt.executeQuery()) {
                // Process the results
                    while (rs.next()) {
                        int ordcode = rs.getInt("ordcode");
                        java.sql.Date orderDate = rs.getDate("orderDate");
                        java.sql.Date shipDate = rs.getDate("shipDate");
                        int prcode = rs.getInt("prcode");
                        int custcode = rs.getInt("custcode");

                        // Process or print the retrieved data as needed
                        System.out.println("Order code: " + ordcode +
                            ",Order Date: " + orderDate +
                            ", Ship Date: " + shipDate +
                            ", Product Code: " + prcode +
                            ", Customer Code: " + custcode);
                    }
                }

            } catch (SQLException e) {
                System.out.println("SQLException: " + e.getMessage());
            } finally {
                sc.close();
                }
            } finally {
            try {
                dbcon.close();
            } catch (SQLException e) {

            }
        }
    }
}
