package controller;

import model.Car;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import service.CarServicce;

import java.util.List;

@RestController
@RequestMapping("/cars")
public class CarController {

    @Autowired
    CarServicce cs;

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

    @GetMapping("/allcars")
    public List<Car> getAllCars(){
        return cs.getAll();
    }

    @GetMapping("{ticket}")
    public Car getcar(@PathVariable String ticket){
        return cs.getCar(ticket);
    }
}
