package com.example.CHLAserver.Repositories;

import com.example.CHLAserver.Model.Car;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

public interface CarRepository extends CrudRepository<Car,Long> {

    @Query(value = "SELECT * FROM car WHERE ticket_number = ?1",nativeQuery = true)
    Car findCarByTicket(String ticketNumber);
}
