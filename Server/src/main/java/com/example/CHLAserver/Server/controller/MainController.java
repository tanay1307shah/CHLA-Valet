package com.example.CHLAserver.Server.controller;

import com.example.CHLAserver.Server.Model.Car;
import com.example.CHLAserver.Server.Service.CarService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.twilio.sdk.TwilioRestClient;
import com.twilio.sdk.TwilioRestException;
import com.twilio.sdk.resource.factory.MessageFactory;
import com.twilio.sdk.resource.instance.Message;
import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;


import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import static org.springframework.http.HttpStatus.*;

//TODO: New local storage for employee parked cars and patient parked cars
//TODO: New endpoints for /getPatientParkedCars and /getEmployeeParkedCars
//TODO: New endpoint for getAllParkedCars (Leave for now)


@Controller
@RequestMapping("/chla")
public class MainController {


    public static final String ACCOUNT_SID = "ACe6274305c04d3c304fda8f3c9ee96f41";
    public static final String AUTH_TOKEN = "9970b693a54501d5bbba2e9bdce14b5a";
    public static final String TWILIO_NUMBER = "+13312561975";
    public static final String MSG_PRESET = "Thank you for dropping your car at CHLA - Valet, To get your car back from the Valet. ";

    @Autowired
    private CarService cs;


    private final static Logger log =
            (Logger) Logger.getLogger(String.valueOf(Logger.class));



    public void sendSMS(String msg,String number) {
        try {
            TwilioRestClient client = new TwilioRestClient(ACCOUNT_SID, AUTH_TOKEN);

            // Build a filter for the MessageList
            List<NameValuePair> params = new ArrayList<NameValuePair>();
            params.add(new BasicNameValuePair("Body", msg));
            params.add(new BasicNameValuePair("To", "+1"+number)); //Add real number here
            params.add(new BasicNameValuePair("From", TWILIO_NUMBER));

            MessageFactory messageFactory = client.getAccount().getMessageFactory();
            Message message = messageFactory.create(params);
            System.out.println(message.getSid());
        }
        catch (TwilioRestException e) {
            System.out.println(e.getErrorMessage());
        }
    }


    @PostMapping("/cars/addCar")
    public @ResponseBody String addNewCar(@RequestParam String Name,
                                          @RequestParam String phone,
                                          @RequestParam String license,
                                          @RequestParam String color,
                                          @RequestParam String type,
                                          @RequestParam String make,
                                          @RequestParam String im1,
                                          @RequestParam String im2,
                                          @RequestParam String im3,
                                          @RequestParam String im4,
                                          @RequestParam String location,
                                          @RequestParam String customerType
    ){

        Car c = cs.addCar(Name,phone, license, color, type, make,im1,im2,im3,im4,location,customerType);
        if(c!= null){
            log.log(Level.INFO,"Adding Car to the Database");
            String msg = "";
            if(c.getCustomerType().compareToIgnoreCase("patient") == 0){
                String url = "https://chlaserver.azurewebsites.net/request.html?id=" + c.getTicketNumber();
                String sp_msg = "You can request your car back by using the link provided below. ";
                msg = MSG_PRESET + sp_msg + url;
            }else{
                String url = "https://chlaserver.azurewebsites.net/employee.html?id=" + c.getTicketNumber();
                String sp_msg = "You can find your cars parking location by the link provided below. ";
                msg = MSG_PRESET + sp_msg + url;
            }
            sendSMS(msg, phone);
            return "OK";
        }
        log.log(Level.WARNING,"Car Already Exsits in the Database");
        return "ALREADY_EXSITS";
    }

    @GetMapping("/cars/getAllCars")
    public @ResponseBody Iterable<Car> getAll(){
        return cs.getAll();
    }

    @GetMapping("/cars/{ticket}")
    public @ResponseBody Car getCar(@PathVariable String ticket){
        return cs.getCar(ticket);
    }

    //TODO: Update the function based on the next Database Structure
    @GetMapping("/cars/updateInfo")
    public @ResponseBody String editCarInfo(@RequestParam String phone,
                                                   @RequestParam String ticket,
                                                   @RequestParam String license,
                                                   @RequestParam String color,
                                                   @RequestParam String type,
                                                   @RequestParam String make){
        cs.editCarInfo(phone, ticket, license, color, type, make);
        return "Completed";
    }



    public @ResponseBody Iterable<Car> getAllRequested(){
        return null;
    }


    @PostMapping("/images")
    @ResponseStatus(OK)
    public @ResponseBody String uploadImage(@RequestParam MultipartFile[] fileup) throws IOException {
        for(int i=0;i<fileup.length;i++){
            byte[] bytes = fileup[i].getBytes();
            InputStream inputStream = new ByteArrayInputStream(bytes);
            String encode = new String(Base64.getEncoder().encode(bytes), "UTF-8");
            System.out.println(encode + "\n----------------------------------------------------------------------") ;
        }
        return "OK";
    }

    @GetMapping("/getPage")
    public String getPage(){
        return "temp.html";
       // return "<!DOCTYPE html><html><head> <meta chesarset=\"UTF-8\"><title>Uploading Files Example with Spring Boot, Freemarker</title> </head> <form action=\"http://localhost:8080/chla/images\" enctype=\"multipart/form-data\" method=\"post\"><input id=\"fileInput\" type=\"file\" name=\"fileup\" multiple><input type=\"submit\" value=\"Upload files\"></form></body></html>";

    }

    @GetMapping("/request/{id}")
    @ResponseStatus(HttpStatus.OK)
    public @ResponseBody Car requestCar(@PathVariable String id){
        System.out.print(id);
        Car c = cs.request(id);

        if(c !=null){
            return c;
        }else{
            return RequestError();
        }
    }

    @ResponseStatus(BAD_REQUEST)
    public Car RequestError(){
        return null;
    }

    @GetMapping("/request/getAllRequested")
    public @ResponseBody Iterable<Car> getRequestedCars(){
        return cs.getRequested();
    }


    //TODO
    @PostMapping("cars/delete/{ticket}")
    public void deleteCar(@PathVariable String ticket){

    }


}
