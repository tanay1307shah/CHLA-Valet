package com.example.CHLAserver.Server.Service;

import com.example.CHLAserver.Server.Model.Car;
import com.example.CHLAserver.Server.Model.Twillio;
import com.example.CHLAserver.Server.Repositories.CarRepository;
import com.example.CHLAserver.Server.controller.MainController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Date;
import java.util.*;

@Service
public class CarService {

    @Autowired
    private CarRepository cr;

    private Hashtable<Long,Car> carsParked = new Hashtable<>();
    private List<Car> requestList = new ArrayList<>();

    public Car addCar(String Name, String phoneNumber, String licensePlate, String color, String type, String make,String images,String location,String cuType){

            Car c = new Car(Name,phoneNumber,licensePlate,color,type,make,images,location,cuType,new Date(Calendar.getInstance().getTime().getTime()));
            c.parseImages();
            Car cd = cr.save(c);
            System.out.println(cd.toString());
            carsParked.put(cd.getTicketNumber(),cd);
            return cd;
    }

    public Iterable<Car> getCarsToRemove(){
        Iterable<Car> it = cr.getCarsToRemove();
        return it;
    }

    public void removeCars(List<Car> carsList){
        cr.deleteAll(carsList);
    }


    public Iterable<Car> getRequested(){
        System.out.println("Request list fetching");
        return requestList;
    }

    public Car request(String ticket){
        Car c  =cr.findCarByTicket(ticket);
        long tick = Long.parseLong(ticket);
        if(c.getImageList() == null){
            c.parseImages();
        }
        if(carsParked.containsKey(tick)) {
            carsParked.put(tick,c);
            if(!c.getCustomerType().equalsIgnoreCase("employee")) {
                requestList.add(carsParked.get(tick));
                System.out.println("Car Added to request list");
            }
            return c;
        }
        return null;
    }


    public Iterable<Car> getAll(){
        return new ArrayList<>(carsParked.values());
    }

    public Car getCar(String ticket){
        return cr.findCarByTicket(ticket);
    }

    public void editCarInfo(String ticketNumber, String name, String phoneNumber, String licensePlate, String color, String type, String make, String images,
                            String parkingLocation, String customerType){
        Car currCar = cr.findCarByTicket(ticketNumber);
        if(currCar.getPhoneNumber().compareToIgnoreCase(phoneNumber) !=0){
            String msg = "";
            if(currCar.getCustomerType().compareToIgnoreCase("patient") == 0){
                String url = MainController.AZURE_REQ_URL+"/request.html?id=" + ticketNumber;
                String sp_msg = "You can request your car back by using the link provided below. ";
                msg = MainController.MSG_PRESET + sp_msg + url;
            }else{
                String url = MainController.AZURE_REQ_URL+"/employee.html?id=" + ticketNumber;
                String sp_msg = "You can find your cars parking location by the link provided below. ";
                msg = MainController.MSG_PRESET + sp_msg + url;
            }
            Twillio.sendSMS(msg, phoneNumber);
        }
        currCar.setName(name);
        currCar.setPhoneNumber(phoneNumber);
        currCar.setColor(color);
        currCar.setLicensePlate(licensePlate);
        currCar.setType(type);
        currCar.setMake(make);
        //currCar.setImages(images);
        currCar.setLocation(parkingLocation);
        currCar.setCustomerType(customerType);

        cr.save(currCar);
        long tick = Long.parseLong(ticketNumber);
        carsParked.put(tick,currCar);
    }

    public boolean payExistingCar(String ticket){
        long tick =  Long.parseLong(ticket);
        if(carsParked.containsKey(tick)){

            if(carsParked.get(tick).getCustomerType().equalsIgnoreCase("employee")){
                carsParked.remove(tick);
                return true;
            }
            if(requestList.contains(carsParked.get(tick))){
                requestList.remove(carsParked.get(tick));
                carsParked.remove(tick);
                return true;
            }else{
                return false;
            }
        }
        return false;
    }
}
