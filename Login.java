
import java.io.Console;
import java.sql.*;
import java.util.Scanner;

public class Login {
   // JDBC driver name and database URL
   static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";  
   static final String DB_URL = "jdbc:mysql://localhost/LiteGroww";

   //  Database credentials
   static final String USER = "root";
   static final String PASS = "rikbithi";

   public static void main(String[] args){
       render();
   }
   
   public static void render() {
   Connection conn = null;
   Statement stmt = null;
   
   try{
      //STEP 1: Register JDBC driver
      Class.forName("com.mysql.jdbc.Driver");

      //STEP 2: Open a connection
      //System.out.println("Connecting to database...");
      conn = DriverManager.getConnection(DB_URL,USER,PASS);

      Scanner in = new Scanner(System.in);

      System.out.print("\033[H\033[2J");
      System.out.flush();

      System.out.println("----- WELCOME TO LITEGROWW -----");
      System.out.println();
      System.out.print("Enter username: ");
      String un = in.nextLine();
      Console console = System.console();
      char[] passwordArray = console.readPassword("Enter your password: ");
      String pass = String.valueOf(passwordArray);



      //STEP 3: Create a statement
      //System.out.println("Creating statement...");
      stmt = conn.createStatement();
      String sql;
      sql = "select * from Cust where Username = \'"+un+"\' and Passwrd = \'"+pass+"\';";
      
      //STEP 4: Execute query
      ResultSet rs = stmt.executeQuery(sql);

      //STEP 5: Extract data from result set
      int i=0;
      while(rs.next()){
         //Retrieve by column name
         
         String PAN = rs.getString("PAN");
         String UName = rs.getString("UName");

         //Display values
         System.out.print("PAN: " + PAN);
         System.out.print(", UName: " + UName);
         System.out.println();
         if(i==0) Home.render(un, PAN);
         i++;
         
      }
      if(i==0) System.out.println("Sorry, Login Failed");
      //STEP 6: Clean-up environment
      rs.close();
      stmt.close();
      conn.close();
      in.close();
   }catch(SQLException se){
      //Handle errors for JDBC
      se.printStackTrace();
   }catch(Exception e){
      //Handle errors for Class.forName
      e.printStackTrace();
   }finally{
      //finally block used to close resources
      try{
         if(stmt!=null)
            stmt.close();
      }catch(SQLException se2){
      }// nothing we can do
      try{
         if(conn!=null)
            conn.close();
      }catch(SQLException se){
         se.printStackTrace();
      }//end finally try
   }//end try
   
   
}//end main
public final static void clearConsole()
{
    try
    {
        final String os = System.getProperty("os.name");

        if (os.contains("Windows"))
        {
            Runtime.getRuntime().exec("cls");
        }
        else
        {
            Runtime.getRuntime().exec("clear");
        }
    }
    catch (final Exception e)
    {
        //  Handle any exceptions.
    }
}
}//end JdbcBoilerplate
