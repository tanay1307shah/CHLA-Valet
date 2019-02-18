package service;

import model.Car;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

@Service
public class CarServicce {

    private Hashtable<String, Car> carDatabase = new Hashtable<>();

    public boolean addCar(String phoneNumber, String ticketNumber, String licensePlate, String color, String type, String make){
        if(!carDatabase.containsKey(ticketNumber)){
            Car c = new Car(phoneNumber,ticketNumber,licensePlate,color,type,make);
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

    public Car getCar(String ticketNumber){
        if(carDatabase.containsKey(ticketNumber)){
            return carDatabase.get(ticketNumber);
        }else{
            return null;
        }
    }
}
