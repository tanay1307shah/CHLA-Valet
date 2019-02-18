package service;

import org.springframework.stereotype.Service;

import java.util.Hashtable;

import model.Employee;


@Service
public class EmployeeService {
    private Hashtable<String,Employee> employees =  new Hashtable<>();
    //private List<allEmployee\\s> allEmployee = new ArrayList<>();
    private Hashtable<String,String> emplyeeInfo = new Hashtable<>();

    public EmployeeService(){
        Employee p1 = new Employee("1","Nathan","lol","lol");
        Employee p2 = new Employee("2","Tanay","lol","lol");
        employees.put("1",p1);
        employees.put("2",p2);
//        allEmployee.add(new allEmployees(p1.getEmployeeId(),p1.getName()));
//        allEmployee.add(new allEmployees(p2.getEmployeeId(),p2.getName()));
    }

    public Employee getEmployee(String id){
        return employees.get(id);
    }

    public Hashtable<String, Employee> getAllEmployees(){
        return employees;
    }


}
