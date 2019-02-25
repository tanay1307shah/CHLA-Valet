package com.example.CHLAserver.Server.Model;

import javax.persistence.*;
import java.util.List;

@Entity
public class Car {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private String phoneNumber;
    private String ticketNumber;
    private String licensePlate;
    private String color;
    private String type;
    private String make;
    private String Image_1;
    private String Image_2;
    private String Image_3;
    private String Image_4;
    private boolean customerType;
    private String parkingLocation;

    public Car(){}


    public Car(String phoneNumber, String ticketNumber, String licensePlate, String color, String type, String make, String image_1, String image_2, String image_3, String image_4, boolean customerType, String parkingLocation) {
        this.phoneNumber = phoneNumber;
        this.ticketNumber = ticketNumber;
        this.licensePlate = licensePlate;
        this.color = color;
        this.type = type;
        this.make = make;
        Image_1 = image_1;
        Image_2 = image_2;
        Image_3 = image_3;
        Image_4 = image_4;
        this.customerType = customerType;
        this.parkingLocation = parkingLocation;
    }

    public Car(String phoneNumber, String ticketNumber, String licensePlate, String color, String type, String make, String image_1, String image_2, String image_3, String image_4) {
        this.phoneNumber = phoneNumber;
        this.ticketNumber = ticketNumber;
        this.licensePlate = licensePlate;
        this.color = color;
        this.type = type;
        this.make = make;
        Image_1 = image_1;
        Image_2 = image_2;
        Image_3 = image_3;
        Image_4 = image_4;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getTicketNumber() {
        return ticketNumber;
    }

    public void setTicketNumber(String ticketNumber) {
        this.ticketNumber = ticketNumber;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getMake() {
        return make;
    }

    public void setMake(String make) {
        this.make = make;
    }

    public String getImage_1() {
        return Image_1;
    }

    public void setImage_1(String image_1) {
        Image_1 = image_1;
    }

    public String getImage_2() {
        return Image_2;
    }

    public void setImage_2(String image_2) {
        Image_2 = image_2;
    }

    public String getImage_3() {
        return Image_3;
    }

    public void setImage_3(String image_3) {
        Image_3 = image_3;
    }

    public String getImage_4() {
        return Image_4;
    }

    public void setImage_4(String image_4) {
        Image_4 = image_4;
    }
}
