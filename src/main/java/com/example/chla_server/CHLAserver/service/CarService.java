package com.example.chla_server.CHLAserver.service;

import com.example.chla_server.CHLAserver.model.Car;
import com.example.chla_server.CHLAserver.repositories.CarRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

@Service
public class CarService {

    @Autowired
    private CarRepository cr;

    private Hashtable<String, Car> carDatabase = new Hashtable<>();
    private Hashtable<String,Car> requestList = new Hashtable<>();
    //Database db = new Database();


    public boolean addCar(String phoneNumber, String ticketNumber, String licensePlate, String color, String type, String make){

        if(!carDatabase.containsKey(ticketNumber)){
            Car c = new Car(phoneNumber,ticketNumber,licensePlate,color,type,make);
            //db.addCar(c);
            cr.save(c);
            carDatabase.put(ticketNumber,c);
            return true;
        }else
            return false;
    }

    public List<Car> getAll(){
        if(carDatabase.isEmpty()){
            return null;
        }else {
            List<Car> allCars = new ArrayList<>(carDatabase.values());
            return allCars;
        }
    }

    public boolean addRequestedCar(String ticket){
        if(carDatabase.containsKey(ticket)) {
            requestList.put(ticket, carDatabase.get(ticket));
            return true;
        }else{
            return false;
        }
    }

    public boolean removeCar(String ticket){
        if(carDatabase.containsKey(ticket)){
            carDatabase.remove(ticket);
            if(requestList.containsKey(ticket)) requestList.remove(ticket);
            return true;
        }
        return false;
    }

    public Car getCar(String ticketNumber){
        if(carDatabase.containsKey(ticketNumber)){
            return carDatabase.get(ticketNumber);
        }else{
            return null;
        }
    }
}
