package com.example.CHLAserver.Server.controller;

import com.example.CHLAserver.Server.ChlaServerApplication;
import com.example.CHLAserver.Server.Model.Car;
import com.example.CHLAserver.Server.Model.Twillio;
import com.example.CHLAserver.Server.Service.CarService;
import com.example.CHLAserver.Server.Service.EmployeeService;
import com.microsoft.azure.storage.StorageException;
import com.microsoft.azure.storage.blob.CloudBlob;
import com.microsoft.azure.storage.blob.CloudBlockBlob;
import com.microsoft.azure.storage.blob.ListBlobItem;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Repository;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.SQLException;
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

    public static final String REQ_URL = " https://bcc44000.ngrok.io";
    public static final String AZURE_REQ_URL = "https://chlaserver.azurewebsites.net";

    @Autowired
    private CarService cs;

    @Autowired
    private EmployeeService es;

    private static Logger log = LoggerFactory.getLogger(MainController.class);


    @Scheduled(fixedDelay = 86400000, initialDelay = 86400000)
    public void clean(){
        log.info("Cleaning older cars");
        Iterable<Car> it = cs.getCarsToRemove();
        List<Car> removeList = new ArrayList<>();
        for (Car c: it) {
            //Removes all images related to that car from Azure file storage
            Iterable<ListBlobItem> blobList = ChlaServerApplication.container.listBlobs(c.getLicensePlate());
            for (ListBlobItem item: blobList) {
                try {
                    CloudBlockBlob cbb = (CloudBlockBlob) item;
                    cbb.deleteIfExists();
                } catch (StorageException e) {
                    e.printStackTrace();
                }
            }
            //Add car to be removed
            removeList.add(c);
        }
        cs.removeCars(removeList);
    }

    @GetMapping("/request")
    public String requestPage(){
        return "redirect:/request.html";
    }

    @PostMapping("/cars/addCar")
    public ResponseEntity<String> addNewCar(@RequestParam Map<String,String> allData, @RequestParam(required = false) MultipartFile[] images, HttpServletRequest req, Model m) throws IOException, StorageException, URISyntaxException {
        String Name = allData.get("name");
        String phone = allData.get("phone");
        String type = allData.get("type");
        String license = allData.get("license");
        String color = allData.get("color");
        String make = allData.get("make");
        String location = allData.get("location");
        String customerType = allData.get("customerType");
        StringBuilder sb = new StringBuilder();

        for(int i=0;i<images.length;i++){

            CloudBlockBlob blob = ChlaServerApplication.container.getBlockBlobReference(license +"_"+images[i].getOriginalFilename());
            log.info("Uploading the sample file ");
            blob.uploadFromByteArray(images[i].getBytes(),0,images[i].getBytes().length);
            String imLoc = blob.getUri().toString();
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
                String url = AZURE_REQ_URL+"/request.html?id=" + c.getTicketNumber();
                String sp_msg = "You can request your car back by using the link provided below. ";
                msg = MSG_PRESET + sp_msg + url;
            }else{
                String url = AZURE_REQ_URL+"/employee.html?id=" + c.getTicketNumber();
                String sp_msg = "You can find your cars parking location by the link provided below. ";
                msg = MSG_PRESET + sp_msg+ url;
            }
            Twillio.sendSMS(msg, phone);
            return ResponseEntity.ok("car_added");
        }
        log.error("Car Already Exsits in the Database");
        return ResponseEntity.status(ALREADY_REPORTED).body("car_already_added");
    }

    @GetMapping("/cars/getAllCarsParked")
    public ResponseEntity<Iterable<Car>> getAll()
    {
        Iterable<Car> it =  cs.getAll();
        if(it != null && it.iterator().hasNext()){
            return new ResponseEntity<>(it,OK);
        }else{
            it  = new ArrayList<>();
            return new ResponseEntity<>(it,NOT_FOUND);
        }
    }

    @GetMapping("/cars/{ticket}")
    public ResponseEntity<?> getCar(@PathVariable String ticket){
        Car c = cs.getCar(ticket);
        if(c!=null){
            return new ResponseEntity<>(c,OK);
        }else{
            return new ResponseEntity<>(null,NOT_FOUND);
        }
    }


    @PostMapping("/cars/updateInfo/{ticket}")
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

    @GetMapping("/request/{id}")
    public ResponseEntity<?> requestCar(@PathVariable String id){
        System.out.print(id);
        Car c = cs.request(id);
        if(c !=null){
            return new ResponseEntity<>(c,HttpStatus.OK);
        }else{
            return new ResponseEntity<>(c, NOT_FOUND);
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
    @GetMapping("/cars/paid/{ticket}")
    public ResponseEntity<String> paidCar(@PathVariable String ticket){
        if(cs.payExistingCar(ticket)){
            log.info("Car : " + ticket + " Paid" );
            return ResponseEntity.status(OK).body("car_" + ticket +"_requested");
        }else{
            return ResponseEntity.status(NOT_FOUND).body("no_car_with_that_ticket_exsits");
        }
    }

    @PostMapping("/login")
    public ResponseEntity<String> login(@RequestParam String username, @RequestParam String password){
        try {
            if(es.login(username,password)){
                return ResponseEntity.ok("success");
            }
        } catch (SQLException e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).body("user_not_found");
        }
        return ResponseEntity.status(NOT_ACCEPTABLE).body("password_incorrect");
    }

}
