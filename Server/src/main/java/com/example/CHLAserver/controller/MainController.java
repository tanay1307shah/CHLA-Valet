package com.example.CHLAserver.controller;

import com.example.CHLAserver.Model.Car;
import com.example.CHLAserver.Repositories.CarRepository;
import com.example.CHLAserver.Service.CarService;
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

    @GetMapping("/cars/editCar")
    public @ResponseBody Car editCar(@PathVariable Long ID){
        return null;
    }
}
