package cpsc4620;

import java.io.IOException;
import java.sql.DriverManager;
import java.sql.SQLException;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class DBConnector {

    // enter your username here
    protected static String user = "mhrrs";
    // enter your password here
    protected static String password = "Burenye3!";
    // enter your database name here
    private static String database_name = "Pizzeria";
    // Do not change the port. 3306 is the default MySQL port
    private static String url = "jdbc:mysql://cpsc4620.clbxtz2utikm.us-east-1.rds.amazonaws.com:3306";
    private static Connection conn;


    /**
     * This function will handle the connection to the database
     *
     * @return true if the connection was successfully made
     * @throws SQLException
     * @throws IOException
     */
    public static Connection make_connection() throws SQLException, IOException {
        conn = DriverManager.getConnection(url + "/" + database_name, user, password);
        return conn;
    }
}
