package controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import model.Employee;
import service.EmployeeService;

import java.util.Hashtable;


@RestController
@RequestMapping("/emp")
public class EmployeeController {

    @Autowired
    EmployeeService es;

    @RequestMapping("{id}")
    public Employee getEmp(@PathVariable String id){
        return es.getEmployee(id);
    }

    @GetMapping("/all")
    public ResponseEntity<?> getAll(){
        return new ResponseEntity<>(es.getAllEmployees(),HttpStatus.OK);
    }


}
