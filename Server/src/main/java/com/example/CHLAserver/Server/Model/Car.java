package com.example.CHLAserver.Server.Model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import org.codehaus.jackson.map.annotate.JsonDeserialize;
import org.codehaus.jackson.map.annotate.JsonSerialize;

import javax.persistence.*;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import java.sql.Date;

@Entity
public class Car {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(updatable = false, nullable = false)
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

    private String location;
    private String customerType;

    @Transient
    @JsonSerialize
    @JsonDeserialize
    private String[] imageList;

    @Column(name = "date",updatable = false,nullable = false)
    private Date date;


    public Car() {
    }

//    public Car(String name, String phoneNumber, String licensePlate, String color, String type, String make, String images, String parkingLocation, String customerType) {
//        Name = name;
//        this.phoneNumber = phoneNumber;
//        this.licensePlate = licensePlate;
//        this.color = color;
//        this.type = type;
//        this.make = make;
//        this.images = images;
//        this.location = parkingLocation;
//        this.customerType = customerType;
//    }

    public Car(@NotNull String name, @Min(10) String phoneNumber, String licensePlate, String color, String type, String make, String images, String location, String customerType, Date date) {
        Name = name;
        this.phoneNumber = phoneNumber;
        this.licensePlate = licensePlate;
        this.color = color;
        this.type = type;
        this.make = make;
        this.images = images;
        this.location = location;
        this.customerType = customerType;
        this.date = date;
    }
    //    public Car(String phoneNumber, String ticketNumber, String licensePlate, String color, String type, String make, String image_1, String image_2, String image_3, String image_4, boolean customerType, String location) {
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
//    public Car(String phoneNumber, String ticketNumber, String licensePlate, String color, String type, String make, String image_1, String image_2, String image_3, String image_4, String location, String customerType) {
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
//        this.location = location;
//        this.customerType = customerType;
//    }

    public void parseImages(){
        if(!images.isEmpty()){
            this.imageList = getImages().split(",");
        }
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
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

    public String getLocation() {
        return location;
    }

    public Long getTicketNumber() {
        return ticketNumber;
    }

    public void setTicketNumber(Long ticketNumber) {
        this.ticketNumber = ticketNumber;
    }

    public void setLocation(String location) {
        this.location = location;
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
