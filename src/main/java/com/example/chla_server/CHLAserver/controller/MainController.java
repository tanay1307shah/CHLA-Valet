package com.example.chla_server.CHLAserver.controller;

import com.example.chla_server.CHLAserver.model.Car;
import com.example.chla_server.CHLAserver.service.CarService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/cars")
public class MainController {

    private CarService cs;


    @PutMapping("/addcar")
    public HttpStatus addCar(@RequestParam String phone,
                             @RequestParam String ticket,
                             @RequestParam String license,
                             @RequestParam String color,
                             @RequestParam String type,
                             @RequestParam String make){

        if(cs.addCar(phone, ticket, license, color, type, make)){
            return HttpStatus.OK;
        }else{
            return HttpStatus.NOT_ACCEPTABLE;
        }
    }

//    @GetMapping("/requestcar")
//    public HttpStatus requestCar(@RequestParam String ticket){
////        if(cs.addRequestedCar(ticket)){
////            return HttpStatus.OK;
////        }
////        return HttpStatus.NOT_ACCEPTABLE;
//        return null;
//    }
//
//    @GetMapping("/removecar")
//    public HttpStatus removecar(@RequestParam String ticket){
////        if(cs.removeCar(ticket)){
////            return HttpStatus.OK;
////        }
////        return HttpStatus.NOT_ACCEPTABLE;
//        return null;
//    }

//    @GetMapping("/allcars")
//    public List<Car> getAllCars(){
//        return cs.getAll();
//    }
//
//    @GetMapping("{ticket}")
//    public Car getcar(@PathVariable String ticket){
//        return cs.getCar(ticket);
//    }
}
