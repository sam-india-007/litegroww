import java.sql.*;
import java.util.Scanner;
import java.util.concurrent.TimeUnit;

public class Search_TKR {

    // JDBC driver name and database URL
    static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";  
    static final String DB_URL = "jdbc:mysql://localhost/LiteGroww";

    //  Database credentials
    static final String USER = "root";
    static final String PASS = "rikbithi";

    public static void render(String un, String PAN){
        System.out.print("\033[H\033[2J");
        System.out.flush();
        System.out.println("----- WELCOME TO LITEGROWW -----");
        System.out.println();
        System.out.println("Welcome, "+un);

        Scanner sc  = new Scanner(System.in);
        System.out.print("Enter ticker symbol: ");
        String tkr = sc.nextLine();
        Connection conn = null;
        Statement stmt = null;
        
        try{
            //STEP 1: Register JDBC driver
            Class.forName("com.mysql.jdbc.Driver");

            //STEP 2: Open a connection
            //System.out.println("Connecting to database...");
            conn = DriverManager.getConnection(DB_URL,USER,PASS);

            
            stmt = conn.createStatement();
            String sql;
            sql = "SELECT * FROM Stock where Stock.TKR =\'"+tkr+"\';";
            
            //STEP 4: Execute query
            ResultSet rs = stmt.executeQuery(sql);

            //STEP 5: Extract data from result set
            System.out.println("\nResults in Stocks \n---");
            while(rs.next()){
                String SName = rs.getString("SName");
                double CurValue = rs.getDouble("CurValue");
                double MarketCap = rs.getDouble("MarketCap");
                int AvailShares = rs.getInt("AvailShares");
                System.out.println("Stock Name: "+SName);
                System.out.println("Current Value: "+CurValue);
                System.out.println("Market Cap: "+MarketCap);
                System.out.println("Number of shares available: "+AvailShares);
                System.out.println("---");
            }

            sql = "SELECT * FROM ETF where ETF.TKR =\'"+tkr+"\';";
            
            //STEP 4: Execute query
            rs = stmt.executeQuery(sql);

            //STEP 5: Extract data from result set
            System.out.println("\nResults in ETFs \n---");
            while(rs.next()){
                String SName = rs.getString("SName");
                double Val = rs.getDouble("Val");
                int Stocks_ETF = rs.getInt("Stocks_ETF");
                int AvailShares = rs.getInt("AvailShares");
                System.out.println("Stock Name: "+SName);
                System.out.println("Current Value: "+Val);
                System.out.println("Number of stocks in ETF: "+Stocks_ETF);
                System.out.println("Number of shares available: "+AvailShares);
                System.out.println("---");
            }

            //STEP 6: Clean-up environment
            rs.close();
            stmt.close();
            conn.close();
            

            TimeUnit.SECONDS.sleep(5);
            Home.render(un, PAN);
            
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
        }
    }
}
