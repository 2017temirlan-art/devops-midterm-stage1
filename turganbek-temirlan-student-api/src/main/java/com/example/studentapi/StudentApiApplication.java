package com.example.studentapi;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class StudentApiApplication {

    private static final Logger log = LoggerFactory.getLogger(StudentApiApplication.class);

    public static void main(String[] args) {
        SpringApplication.run(StudentApiApplication.class, args);
    }

    /** Prints the student's name in the application log at startup. */
    @Bean
    ApplicationRunner studentBanner(@Value("${app.student.full-name}") String studentName) {
        return args -> log.info("Student API started for student: {}", studentName);
    }
}
