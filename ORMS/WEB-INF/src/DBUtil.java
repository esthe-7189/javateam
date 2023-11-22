package mira;

import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.SQLException;

public class DBUtil {
    public static Connection getConnection(String poolName)
    throws SQLException {
        return DriverManager.getConnection(
            "jdbc:apache:commons:dbcp:/"+poolName);
    }
}