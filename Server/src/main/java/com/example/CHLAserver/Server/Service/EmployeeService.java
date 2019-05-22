package com.example.CHLAserver.Server.Service;

import com.example.CHLAserver.Server.Model.Employee;
import com.example.CHLAserver.Server.Repositories.EmployeeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.ResultSet;
import java.sql.SQLException;

@Service
public class EmployeeService {

    @Autowired
    private EmployeeRepository er;

    public boolean login(String userName, String password) throws SQLException {
        Employee e = er.findEmployeeByUsername(userName);

        if(e == null){
            Employee en = new Employee(userName,password,true);
            //Employee  en = er.save(e);
            er.save(en);
            return true;
        }else{
            //rs.next();
            String pass = e.getPassword();
            return pass.compareTo(password) == 0;
        }
    }


}
