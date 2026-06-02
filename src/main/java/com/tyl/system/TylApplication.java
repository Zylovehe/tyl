package com.tyl.system;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.tyl.system.mapper")
public class TylApplication {

    public static void main(String[] args) {
        SpringApplication.run(TylApplication.class, args);
    }
}
