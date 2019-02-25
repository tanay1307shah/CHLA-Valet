package com.example.CHLAserver.Server.controller;

import com.example.CHLAserver.Server.Model.Car;
import com.example.CHLAserver.Server.Repositories.CarRepository;
import com.example.CHLAserver.Server.Model.Car;
import com.example.CHLAserver.Server.Service.CarService;
import com.example.CHLAserver.Server.Service.CarService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

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

}
