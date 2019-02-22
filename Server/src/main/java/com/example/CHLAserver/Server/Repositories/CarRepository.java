package com.example.CHLAserver.Server.Repositories;

import com.example.CHLAserver.Server.Model.Car;
import com.example.CHLAserver.Server.Model.Car;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

public interface CarRepository extends CrudRepository<Car,Long> {

    @Query(value = "SELECT * FROM car WHERE ticket_number = ?1",nativeQuery = true)
    Car findCarByTicket(String ticketNumber);

    //uery(value =  "DELETE * FROM car WHERE ticket_number = ?1",nativeQuery = true)
//
}
