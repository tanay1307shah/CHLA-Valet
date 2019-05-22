package com.example.CHLAserver.Server.Repositories;

import com.example.CHLAserver.Server.Model.Car;
import com.example.CHLAserver.Server.Model.Employee;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import javax.xml.transform.Result;
import java.sql.ResultSet;

public interface EmployeeRepository extends CrudRepository<Employee,Long> {

    @Query(value = "SELECT * FROM employee WHERE username = ?1 AND enabled = '1'",nativeQuery = true)
    Employee findEmployeeByUsername(String userName);


}
