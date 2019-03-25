package com.example.CHLAserver.Server.Service;

import com.example.CHLAserver.Server.Model.Car;
import com.example.CHLAserver.Server.Repositories.CarRepository;
import com.example.CHLAserver.Server.Model.Car;
import com.example.CHLAserver.Server.Repositories.CarRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class CarService {

    @Autowired
    private CarRepository cr;

    private Hashtable<Long,Car> carDB = new Hashtable<>();
    private List<Car> requestList = new ArrayList<>();

    public Car addCar(String Name, String phoneNumber, String licensePlate, String color, String type, String make,String im1,String im2,String im3,String im4,String location,String cuType){

            Car c = new Car(Name,phoneNumber,licensePlate,color,make,type,im1,im2,im3,im4,location,cuType);
            Car cd = cr.save(c);
            System.out.println(cd.toString());
            carDB.put(cd.getTicketNumber(),cd);
            return cd;
    }

    public Iterable<Car> getRequested(){
        System.out.println("Request list fetching");
        return requestList;
    }

    public Car request(String ticket){
        Car c  =cr.findCarByTicket(ticket);
        long tick = Long.parseLong(ticket);
        if(carDB.containsKey(tick)) {
            requestList.add(c);
            System.out.println("Car Added to request list");
            return c;
        }
        return null;
    }


    public Iterable<Car> getAll(){
        return cr.findAll();
    }

    public Car getCar(String ticket){
        return cr.findCarByTicket(ticket);
    }

    public void editCarInfo(String phoneNumber, String ticketNumber, String licensePlate, String color, String type, String make){
        Car currCar = cr.findCarByTicket(ticketNumber);

        currCar.setPhoneNumber(phoneNumber);
        currCar.setColor(color);
        currCar.setLicensePlate(licensePlate);
        currCar.setType(type);
        currCar.setMake(make);

        cr.save(currCar);
    }
}
