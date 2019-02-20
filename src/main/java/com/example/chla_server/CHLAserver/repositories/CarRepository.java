package com.example.chla_server.CHLAserver.repositories;

import com.example.chla_server.CHLAserver.model.Car;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CarRepository extends CrudRepository<Car,Long> {
}
