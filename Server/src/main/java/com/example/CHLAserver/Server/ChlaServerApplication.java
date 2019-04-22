package com.example.CHLAserver.Server;

import java.io.File;
import java.net.URISyntaxException;
import java.security.InvalidKeyException;

import com.example.CHLAserver.Server.controller.MainController;;


import com.microsoft.azure.storage.CloudStorageAccount;
import com.microsoft.azure.storage.StorageException;
import com.microsoft.azure.storage.blob.CloudBlobClient;
import com.microsoft.azure.storage.blob.CloudBlobContainer;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;


@Configuration
@EnableSwagger2
@EnableScheduling
@ComponentScan({"com.example.CHLAserver.Server.controller", "com.example.CHLAserver.Server.Model","com.example.CHLAserver.Server.Repositories","com.example.CHLAserver.Server.Service"})
@SpringBootApplication
public class ChlaServerApplication{

	private static  final String CONNECTION_STRING = "DefaultEndpointsProtocol=https;" +
			"AccountName=chlafilestorage;" +
			"AccountKey=dPuO/5hzU5q73N4wI0EFR7WGKxbQw1IzDTEAi/ONU64SPd1h55I64bQdhoSyUEFOJ+MEXyWLPbb556mnCNkBbA==;" +
			"EndpointSuffix=core.windows.net";

	static CloudStorageAccount storageAccount;
	static CloudBlobClient blobClient;
	public static CloudBlobContainer container;

	public static void main(String[] args) {
		try {
			storageAccount = CloudStorageAccount.parse(CONNECTION_STRING);
			blobClient = storageAccount.createCloudBlobClient();
			container = blobClient.getContainerReference("images");
		} catch (URISyntaxException e) {
			e.printStackTrace();
		} catch (InvalidKeyException e) {
			e.printStackTrace();
		} catch (StorageException e) {
			e.printStackTrace();
		}

		SpringApplication.run(ChlaServerApplication.class, args);
	}

	@Bean
	public Docket swaggerEmployeeApi() {
		System.out.println("Hello");
		return new Docket(DocumentationType.SWAGGER_2)
				.select()
				.apis(RequestHandlerSelectors.basePackage("com.example.CHLAserver.Server.controller"))
				.paths(PathSelectors.any())
				.build()
				.apiInfo(new ApiInfoBuilder().version("1.0").title("CHLA API").description("Documentation CHLA API v1.0").build());
	}

}
