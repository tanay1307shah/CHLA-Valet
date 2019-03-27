package com.example.CHLAserver.Server.Model;

import org.aspectj.lang.annotation.RequiredTypes;

import javax.persistence.*;
import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import java.util.ArrayList;
import java.util.List;

@Entity
public class Car {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(updatable = false,nullable = false)
    private Long ticketNumber;

    @NotNull
    private String Name;

    @Min(10)
    private String phoneNumber;
    private String licensePlate;
    private String color;
    private String type;
    private String make;
    private String Image_1;
    private String Image_2;
    private String Image_3;
    private String Image_4;
    private String parkingLocation;
    private String customerType;

    public Car(){}

    public Car(String name, String phoneNumber, String licensePlate, String color, String type, String make, String image_1, String image_2, String image_3, String image_4, String parkingLocation, String customerType) {
        Name = name;
        this.phoneNumber = phoneNumber;
        this.licensePlate = licensePlate;
        this.color = color;
        this.type = type;
        this.make = make;
        Image_1 = image_1;
        Image_2 = image_2;
        Image_3 = image_3;
        Image_4 = image_4;
        this.parkingLocation = parkingLocation;
        this.customerType = customerType;
    }

//    public Car(String phoneNumber, String ticketNumber, String licensePlate, String color, String type, String make, String image_1, String image_2, String image_3, String image_4, boolean customerType, String parkingLocation) {
//        this.phoneNumber = phoneNumber;
//        this.ticketNumber = ticketNumber;
//        this.licensePlate = licensePlate;
//        this.color = color;
//        this.type = type;
//        this.make = make;
//        Image_1 = image_1;
//        Image_2 = image_2;
//        Image_3 = image_3;
//        Image_4 = image_4;
//    }
//
//    public Car(String phoneNumber, String ticketNumber, String licensePlate, String color, String type, String make, String image_1, String image_2, String image_3, String image_4, String parkingLocation, String customerType) {
//        this.phoneNumber = phoneNumber;
//        this.ticketNumber = ticketNumber;
//        this.licensePlate = licensePlate;
//        this.color = color;
//        this.type = type;
//        this.make = make;
//        Image_1 = image_1;
//        Image_2 = image_2;
//        Image_3 = image_3;
//        Image_4 = image_4;
//        this.parkingLocation = parkingLocation;
//        this.customerType = customerType;
//    }


    public String getName() {
        return Name;
    }

    public void setName(String name) {
        Name = name;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
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

    public String getParkingLocation() {
        return parkingLocation;
    }

    public Long getTicketNumber() {
        return ticketNumber;
    }

    public void setTicketNumber(Long ticketNumber) {
        this.ticketNumber = ticketNumber;
    }

    public void setParkingLocation(String parkingLocation) {
        this.parkingLocation = parkingLocation;
    }

    public String getCustomerType() {
        return customerType;
    }

    public void setCustomerType(String customerType) {
        this.customerType = customerType;
    }

//    public ArrayList<String> getImages() {
//        return images;
//    }
//
//    public void setImages(ArrayList<String> images) {
//        this.images = images;
//    }

    //    @Override
//    public String toString() {
//        String s = "Car{" + "ID:" + this.id+ "}";
//        return s;
//    }
}
