import java.util.Scanner;

public class Home {
    // JDBC driver name and database URL
    static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";  
    static final String DB_URL = "jdbc:mysql://localhost/LiteGroww";

    //  Database credentials
    static final String USER = "root";
    static final String PASS = "rikbithi";
    
    public static void main(String[] args) {
   
   
   
    }//end main
    
    public static void render(String un, String PAN) {

        System.out.print("\033[H\033[2J");
        System.out.flush();
        System.out.println("----- WELCOME TO LITEGROWW -----");
        System.out.println();
        System.out.println("Welcome, "+un);

        Scanner sc  = new Scanner(System.in);

        System.out.println("Choose action");
        System.out.println("1. Buy Stocks");
        System.out.println("2. Buy ETFs");
        System.out.println("3. Sell Stocks");
        System.out.println("4. Sell ETFS");
        System.out.println("5. Search Stocks by Category");
        System.out.println("6. Search Stocks/ETFs by Ticker");
        System.out.println("7. My Profile");
        System.out.println("8. Logout");

        int i = sc.nextInt();

        switch(i)
        {
            case 1: BuyStock.render(un, PAN); break;
            case 2: BuyETF.render(un, PAN); break;
            case 3: SellStock.render(un, PAN); break;
            case 4: SellETF.render(un, PAN); break;
            case 5: Search.render(un, PAN); break;
            case 6: Search_TKR.render(un, PAN); break;
            case 7: Profile.render(un, PAN); break;
            case 8: Login.render(); break;
            default: System.out.println("Input not in proper format, quitting");
        }

        sc.close();
   
   
    }


}//end JdbcBoilerplate
