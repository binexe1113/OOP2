package com.academia.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DbConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/sistema_academia";
    private static final String USER = "root";
    private static final String PASSWORD = "rootpassword"; // Por padrão vazio, ajustável conforme necessidade

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver JDBC do MySQL não encontrado", e);
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
