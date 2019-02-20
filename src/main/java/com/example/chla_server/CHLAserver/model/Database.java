package com.example.chla_server.CHLAserver.model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class Database {

    static Connection conn = null;
    public Database(){
        try {
            Class.forName("com.mysql.jdbc.driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/CHLAsql","root","tShah0713!");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void addCar(Car c){
        PreparedStatement ps = null;
        try {
            ps = conn.prepareStatement("INSERT INTO NewCar(mobileNumber,ticketNumber,plateNumber,color,carType,carMake) VALUES(?,?,?,?,?,?)");
            ps.setString(1,c.getPhoneNumber());
            ps.setString(2,c.getTicketNumber());
            ps.setString(3,c.getLicensePlate());
            ps.setString(4,c.getColor());
            ps.setString(5,c.getType());
            ps.setString(6,c.getMake());
            int row = ps.executeUpdate();

            PreparedStatement ps1 = conn.prepareStatement("INSERT INTO CarList(carID) VALUES (?)");
            ps1.setInt(1,row);
            int x = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

