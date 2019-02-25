package com.example.CHLAserver.Server.Service;

import com.example.CHLAserver.Server.Model.Car;
import com.example.CHLAserver.Server.Repositories.CarRepository;
import com.example.CHLAserver.Server.Model.Car;
import com.example.CHLAserver.Server.Repositories.CarRepository;
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
