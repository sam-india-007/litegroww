import java.sql.*;

import java.util.concurrent.TimeUnit;

public class Profile {

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
            sql = "SELECT AccBal FROM Cust where Cust.PAN = \'"+PAN+"\';";
            
            //STEP 4: Execute query
            ResultSet rs = stmt.executeQuery(sql);

            //STEP 5: Extract data from result set
            
            while(rs.next()){
                System.out.println("Account Balance: INR "+rs.getDouble("AccBal"));
                break;
            }

            sql = "SELECT SUM(Stock.CurValue-Cust_Stock.Hold_Val) as Stock_profit from Cust_Stock,Stock where Cust_Stock.TKR=Stock.TKR AND Cust_Stock.PAN = \'"+PAN+"\';";
            
            //STEP 4: Execute query
            rs = stmt.executeQuery(sql);

            //STEP 5: Extract data from result set
            
            while(rs.next()){
                System.out.println("Stock profit/loss: INR "+rs.getDouble("Stock_profit"));
                break;
            }

            sql = "SELECT SUM(ETF.Val-Cust_ETF.Hold_Val) as ETF_profit from Cust_ETF,ETF where Cust_ETF.TKR=ETF.TKR AND Cust_ETF.PAN = \'"+PAN+"\';";
            
            //STEP 4: Execute query
            rs = stmt.executeQuery(sql);

            //STEP 5: Extract data from result set
            
            while(rs.next()){
                System.out.println("ETF profit/loss: INR "+rs.getDouble("ETF_profit"));
                break;
            }

            System.out.println("\nYour Holdings");

            sql = "SELECT Cust_Stock.TKR,Cust_Stock.Num_Shares,Stock.SName,Cust_Stock.Avg_Buy_Price from Stock,Cust_Stock where Cust_Stock.TKR = Stock.TKR AND Cust_Stock.PAN = \'"+PAN+"\'";
            
            //STEP 4: Execute query
            rs = stmt.executeQuery(sql);

            //STEP 5: Extract data from result set
            
            while(rs.next()){
                System.out.println("Ticker: "+rs.getString("Cust_Stock.TKR"));
                System.out.println("Name: "+rs.getString("Stock.SName"));
                System.out.println("Shares bought: "+rs.getInt("Cust_Stock.Num_Shares"));
                System.out.println("Average buy price: "+rs.getDouble("Cust_Stock.Avg_Buy_Price"));
                System.out.println();
            }

            sql = "SELECT Cust_ETF.TKR,Cust_ETF.Num_Shares,ETF.SName,Cust_ETF.Avg_Buy_Price from Cust_ETF,ETF where Cust_ETF.TKR = ETF.TKR and Cust_ETF.PAN = \'"+PAN+"\';";
            
            //STEP 4: Execute query
            rs = stmt.executeQuery(sql);

            //STEP 5: Extract data from result set
            
            while(rs.next()){
                System.out.println("Ticker: "+rs.getString("Cust_ETF.TKR"));
                System.out.println("Name: "+rs.getString("ETF.SName"));
                System.out.println("Shares bought: "+rs.getInt("Cust_ETF.Num_Shares"));
                System.out.println("Average buy price: "+rs.getDouble("Cust_ETF.Avg_Buy_Price"));
                System.out.println();
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
