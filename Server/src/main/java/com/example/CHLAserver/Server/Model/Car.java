package com.example.CHLAserver.Server.Model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;
import org.aspectj.lang.annotation.RequiredTypes;
import org.codehaus.jackson.map.annotate.JsonDeserialize;
import org.codehaus.jackson.map.annotate.JsonSerialize;
import org.hibernate.validator.constraints.Length;

import javax.persistence.*;
import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Entity
public class Car {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(updatable = false, nullable = false)
    @Max(4)
    private Long ticketNumber;

    @NotNull
    private String Name;

    @Min(10)
    private String phoneNumber;
    private String licensePlate;
    private String color;
    private String type;
    private String make;

    @JsonIgnore
    @Column(columnDefinition = "MEDIUMTEXT")
    private String images;

    private String parkingLocation;
    private String customerType;

    @Transient
    @JsonSerialize
    @JsonDeserialize
    private String[] imageList;

    public Car() {
    }

    public Car(String name, String phoneNumber, String licensePlate, String color, String type, String make, String images, String parkingLocation, String customerType) {
        Name = name;
        this.phoneNumber = phoneNumber;
        this.licensePlate = licensePlate;
        this.color = color;
        this.type = type;
        this.make = make;
        this.images = images;
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

    public void parseImages(){
        this.imageList = getImages().split(",");
    }
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

    public String getImages() {
        return images;
    }

    public void setImages(String images) {
        this.images = images;
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

    public String[] getImageList() {
        return imageList;
    }

    public void setImageList(String[] imageList) {
        this.imageList = imageList;
    }
}
