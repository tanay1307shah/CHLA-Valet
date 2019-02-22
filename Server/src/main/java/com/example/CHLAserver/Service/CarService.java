package com.example.CHLAserver.Service;

import com.example.CHLAserver.Model.Car;
import com.example.CHLAserver.Repositories.CarRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Hashtable;

@Service
public class CarService {

    @Autowired
    private CarRepository cr;

    private Hashtable<String,Car> carDB = new Hashtable<>();

    public boolean addCar(String phoneNumber, String ticketNumber, String licensePlate, String color, String type, String make){

        if(!carDB.containsKey(ticketNumber)){
            Car c = new Car(phoneNumber,ticketNumber,licensePlate,color,type,make);
            cr.save(c);
            carDB.put(ticketNumber,c);
            return true;
        }else
            return false;
    }

    public Iterable<Car> getAll(){
        return cr.findAll();
    }

    public Car getCar(String ticket){
        return cr.findCarByTicket(ticket);
    }
}
