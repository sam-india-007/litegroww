import java.sql.*;
import java.util.Scanner;
import java.util.concurrent.TimeUnit;

public class SellStock {

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

        System.out.print("Enter ticker of stock to sell: ");
        String stock = sc.nextLine();
        System.out.print("Enter number of shares to be sold: ");
        int num_shares = sc.nextInt();
        System.out.print("Enter sell price: ");
        double sell_price = sc.nextDouble();

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
            sql = "select * from Stock where TKR = \'"+stock+"\';";
            
            //STEP 4: Execute query
            ResultSet rs = stmt.executeQuery(sql);

            //STEP 5: Extract data from result set
            while(rs.next()){
                
                double curval = rs.getDouble("CurValue");
                if(sell_price > curval){
                    System.out.println("trying to sell at price higher than current value, quitting");
                    return;
                }
                break;
            }

            sql = "select * from Cust_Stock where TKR = \'"+stock+"\' and PAN = \'"+PAN+"\';";
            rs = stmt.executeQuery(sql);
            int i=0;

            while(rs.next()){
                i++;
                
                int ns = rs.getInt("Num_Shares");
                if(num_shares > ns){
                    System.out.println("trying to sell more shares than bought, quitting");
                    return;
                }
                break;
            }
            if (i==0){
                System.out.println("you do not own any shares of this stock, quitting");
                return;
            }
            
            
            sql = "call sell_share ("+num_shares+", "+sell_price+", \'"+stock+"\', \'"+PAN+"\');";
            stmt.executeUpdate(sql);
            
            //STEP 6: Clean-up environment
            rs.close();
            stmt.close();
            conn.close();

            System.out.println("Successful sale, returning to home page...");
            TimeUnit.SECONDS.sleep(1);
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
        sc.close();        
    }
}
