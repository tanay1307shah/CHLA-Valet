package com.example.CHLAserver.Server.controller;

import com.example.CHLAserver.Server.Model.Car;
import com.example.CHLAserver.Server.Model.Twillio;
import com.example.CHLAserver.Server.Service.CarService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.*;

import static org.springframework.http.HttpStatus.*;

//TODO: New local storage for employee parked cars and patient parked cars
//TODO: New endpoints for /getPatientParkedCars and /getEmployeeParkedCars
//TODO: New endpoint for getAllParkedCars (Leave for now)


@Controller
@RequestMapping("/chla")
public class MainController {

    public static String uploadDirectory = System.getProperty("user.dir")+"/src/main/resources/static/images";
    public static final String MSG_PRESET = "Thank you for dropping your car at CHLA - Valet, To get your car back from the Valet. ";
    public static final String DATE_PATTERN = "yyyy-MM-dd";

    @Autowired
    private CarService cs;

    private static Logger log = LoggerFactory.getLogger(MainController.class);

    @PostMapping("/cars/addCar")
    public @ResponseBody String addNewCar(@RequestParam Map<String,String> allData,@RequestParam MultipartFile[] images,HttpServletRequest req) throws IOException {

        String Name = allData.get("Name");
        String phone = allData.get("phone");
        String type = allData.get("type");
        String license = allData.get("license");
        String color = allData.get("color");
        String make = allData.get("location");
        String location = allData.get("location");
        String customerType = allData.get("customerType");

        StringBuilder sb = new StringBuilder();


        for(int i=0;i<images.length;i++){
//            SimpleDateFormat sdf = new SimpleDateFormat(DATE_PATTERN);
//            String date = sdf.format(new Date());
            new File(uploadDirectory + "/"+license).mkdir();
            Path path = Paths.get(uploadDirectory+"/"+license,images[i].getOriginalFilename());
            log.info("Add Car: Writing image " + images[i].getOriginalFilename() + " at location " + path.toString());
            Files.write(path,images[i].getBytes());

            String imLoc = "https://chlaserver.azurewebsites.net/images/" +license + "/"+ images[i].getOriginalFilename();
            if(i!=images.length-1){
                sb.append(imLoc+",");
            }else{
                sb.append(imLoc);
            }

        }


        Car c = cs.addCar(Name,phone, license, color, type, make,sb.toString(),location,customerType);
        if(c!= null){
            log.info("Adding Car " + c.getTicketNumber() +" to DB");
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
            Twillio.sendSMS(msg, phone);
            return "OK";
        }
        log.error("Car Already Exsits in the Database");
        return "ALREADY EXSITS";
    }

    @GetMapping("/cars/getAllCarsParked")
    public @ResponseBody Iterable<Car> getAll(){
        return cs.getAll();
    }

    @GetMapping("/cars/{ticket}")
    public @ResponseBody Car getCar(@PathVariable String ticket){
        return cs.getCar(ticket);
    }

    //TODO: Update the function based on the next Database Structure
    //UPDATED FOR EDITING NAME
    @GetMapping("/cars/updateInfo/{ticket}")
    public @ResponseBody String editCarInfo(@PathVariable String ticket,
                                            @RequestParam String name,
                                            @RequestParam String phone,
                                            @RequestParam String license,
                                            @RequestParam String color,
                                            @RequestParam String type,
                                            @RequestParam String make,
                                            @RequestParam String images,
                                            @RequestParam String parkingLocation,
                                            @RequestParam String customerType){
        cs.editCarInfo(ticket, name, phone, license, color, type, make, images, parkingLocation, customerType);
        return "Completed";
    }



    public @ResponseBody Iterable<Car> getAllRequested(){
        return null;
    }


    @GetMapping("/static/images")
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
    @PostMapping("/cars/paid/{ticket}")
    @ResponseStatus(OK)
    public void paidCar(@PathVariable String ticket){
        if(cs.payExistingCar(ticket)){
            log.info("Car : " + ticket + " Paid" );
        }else{
            RequestError();
        }
    }

    @PostMapping("/twillio/recieveSMS")
    @ResponseStatus(HttpStatus.OK)
    public void recieveText(@RequestParam Map<String,String> allReqParam){
        System.out.println(allReqParam.toString());
    }

}
