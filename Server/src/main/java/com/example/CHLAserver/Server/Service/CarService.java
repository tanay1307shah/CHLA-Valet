package com.example.CHLAserver.Server.Service;

import com.example.CHLAserver.Server.Model.Car;
import com.example.CHLAserver.Server.Repositories.CarRepository;
import com.example.CHLAserver.Server.Model.Car;
import com.example.CHLAserver.Server.Repositories.CarRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.*;

@Service
public class CarService {

    @Autowired
    private CarRepository cr;

    private Hashtable<Long,Car> carDB = new Hashtable<>();
    private List<Car> requestList = new ArrayList<>();

    public Car addCar(String Name, String phoneNumber, String licensePlate, String color, String type, String make,String images,String location,String cuType){

            Car c = new Car(Name,phoneNumber,licensePlate,color,type,make,images,location,cuType);
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
            carDB.put(tick,c);
            requestList.add(carDB.get(tick));
            System.out.println("Car Added to request list");
            return c;
        }
        return null;
    }


    public Iterable<Car> getAll(){
        Collection<Car> temp = carDB.values();
        Iterable<Car> cars = cr.findAll();
        for(Car c:cars){
            if(c.getImageList() == null)
                c.parseImages();
        }
        return cars;
    }

    public Car getCar(String ticket){
        return cr.findCarByTicket(ticket);
    }

    public void editCarInfo(String ticketNumber, String name, String phoneNumber, String licensePlate, String color, String type, String make, String images,
                            String parkingLocation, String customerType){
        Car currCar = cr.findCarByTicket(ticketNumber);
        currCar.setName(name);
        currCar.setPhoneNumber(phoneNumber);
        currCar.setColor(color);
        currCar.setLicensePlate(licensePlate);
        currCar.setType(type);
        currCar.setMake(make);
        //currCar.setImages(images);
        currCar.setParkingLocation(parkingLocation);
        currCar.setCustomerType(customerType);

        cr.save(currCar);
        long tick = Long.parseLong(ticketNumber);
        carDB.put(tick,currCar);
    }

    public boolean payExistingCar(String ticket){
        long tick =  Long.parseLong(ticket);
        if(carDB.containsKey(tick) && requestList.contains(carDB.get(tick))){
            requestList.remove(carDB.get(tick));
            carDB.remove(tick);
            return true;
        }else{
            return false;
        }
    }
}
