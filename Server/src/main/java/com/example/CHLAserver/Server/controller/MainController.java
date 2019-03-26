package com.example.CHLAserver.Server.controller;

import com.example.CHLAserver.Server.Model.Car;
import com.example.CHLAserver.Server.Model.Twillio;
import com.example.CHLAserver.Server.Service.CarService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Base64;
import java.util.Map;

import static org.springframework.http.HttpStatus.*;

//TODO: New local storage for employee parked cars and patient parked cars
//TODO: New endpoints for /getPatientParkedCars and /getEmployeeParkedCars
//TODO: New endpoint for getAllParkedCars (Leave for now)


@Controller
@RequestMapping("/chla")
public class MainController {

    public static String uploadDirectory = System.getProperty("user.dir")+"/src/main/resources/static/images";
    public static final String MSG_PRESET = "Thank you for dropping your car at CHLA - Valet, To get your car back from the Valet. ";

    @Autowired
    private CarService cs;

    private static Logger log = LoggerFactory.getLogger(MainController.class);

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
            log.info("Adding Car to DB");
            //log.log(Level.INFO,"Adding Car to the Database");
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
    @PostMapping("/cars/delete/{ticket}")
    public void deleteCar(@PathVariable String ticket){

    }

    @PostMapping("/twillio/recieveSMS")
    @ResponseStatus(HttpStatus.OK)
    public void recieveText(@RequestParam Map<String,String> allReqParam){
        System.out.println(allReqParam.toString());
    }

    @PostMapping("/test/mpf")
    @ResponseStatus(HttpStatus.OK)
    public void test(@RequestParam MultipartFile[] images, HttpServletRequest req) throws IOException {
        //byte[] bytes = image0.getBytes();

        for(MultipartFile image:images){
            System.out.println(image.getOriginalFilename());
            Path path = Paths.get(uploadDirectory,image.getOriginalFilename());
            Files.write(path,image.getBytes());
        }




//        System.out.println(req.getServletContext().getRealPath("/static"));
//        inputStream = image0.getInputStream();
//
//        File newFile = new File("classpath:static/" + image0.getOriginalFilename());
//        if (!newFile.exists()) {
//            newFile.createNewFile();
//        }
//        outputStream = new FileOutputStream(newFile);
//        int read = 0;
//        byte[] bytes = new byte[1024];
//
//        while ((read = inputStream.read(bytes)) != -1) {
//            outputStream.write(bytes, 0, read);
//        }
//        Files.write(Paths.get("/" + image0.getOriginalFilename()),bytes);
        //FileUtils.writeByteArrayToFile(new File("/"+image0.getOriginalFilename()), bytes);
    }

}
