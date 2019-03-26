package com.example.CHLAserver.Server;

import java.io.File;
import com.example.CHLAserver.Server.controller.MainController;;


import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;


@Configuration
@ComponentScan({"com.example.CHLAserver.Server.controller", "com.example.CHLAserver.Server.Model","com.example.CHLAserver.Server.Repositories","com.example.CHLAserver.Server.Service"})
@SpringBootApplication
public class ChlaServerApplication {

	public static void main(String[] args) {
		new File(MainController.uploadDirectory).mkdir();
		SpringApplication.run(ChlaServerApplication.class, args);
	}

}
