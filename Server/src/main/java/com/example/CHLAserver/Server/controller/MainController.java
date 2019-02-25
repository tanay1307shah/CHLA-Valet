package com.example.CHLAserver.Server.controller;

import com.example.CHLAserver.Server.Model.Car;
import com.example.CHLAserver.Server.Repositories.CarRepository;
import com.example.CHLAserver.Server.Model.Car;
import com.example.CHLAserver.Server.Service.CarService;
import com.example.CHLAserver.Server.Service.CarService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.Base64;

@Controller
@RequestMapping("/chla")
public class MainController {

    @Autowired
    private CarService cs;

    @GetMapping("/cars/addCar")
    public @ResponseBody String addNewCar(@RequestParam String phone,
                                          @RequestParam String ticket,
                                          @RequestParam String license,
                                          @RequestParam String color,
                                          @RequestParam String type,
                                          @RequestParam String make){

        if(cs.addCar(phone, ticket, license, color, type, make)){
            return "OK";
        }
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

    @PostMapping("/images")
    @ResponseStatus(HttpStatus.OK)
    public @ResponseBody String uploadImage(@RequestParam MultipartFile[] fileup) throws IOException {
        for(int i=0;i<fileup.length;i++){
            byte[] bytes = fileup[i].getBytes();
            InputStream inputStream = new ByteArrayInputStream(bytes);
            String encode = new String(Base64.getEncoder().encode(bytes), "UTF-8");
            System.out.println(encode + "\n----------------------------------------------------------------------") ;
        }
        return "OK";
    }

}
