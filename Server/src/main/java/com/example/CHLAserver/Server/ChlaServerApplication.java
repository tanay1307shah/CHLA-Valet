package com.example.CHLAserver.Server;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@EnableAutoConfiguration
@ComponentScan({"com.example.CHLAserver.Server.controller", "com.example.CHLAserver.Server.Model","com.example.CHLAserver.Server.Repositories","com.example.CHLAserver.Server.Service"})
@SpringBootApplication
public class ChlaServerApplication {

	public static void main(String[] args) {
		SpringApplication.run(ChlaServerApplication.class, args);
	}

}
