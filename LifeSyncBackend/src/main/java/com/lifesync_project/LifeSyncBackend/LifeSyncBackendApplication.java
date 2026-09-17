package com.lifesync_project.LifeSyncBackend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;

@SpringBootApplication
@EnableCaching
public class LifeSyncBackendApplication {

	public static void main(String[] args) {
		SpringApplication.run(LifeSyncBackendApplication.class, args);
	}

}
