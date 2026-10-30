package com.example.studentapi.controller;

import java.util.LinkedHashMap;
import java.util.Map;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.info.BuildProperties;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/** Shows the student's name, application version and the individual test data. */
@RestController
public class HomeController {

    private final String fullName;
    private final String firstName;
    private final String lastName;
    private final String email;
    private final String studentCode;
    private final String version;

    public HomeController(
            @Value("${app.student.full-name}") String fullName,
            @Value("${app.student.first-name}") String firstName,
            @Value("${app.student.last-name}") String lastName,
            @Value("${app.student.email}") String email,
            @Value("${app.student.student-code}") String studentCode,
            ObjectProvider<BuildProperties> buildProperties) {
        this.fullName = fullName;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.studentCode = studentCode;
        BuildProperties props = buildProperties.getIfAvailable();
        this.version = props != null ? props.getVersion() : "unknown";
    }

    @GetMapping("/")
    public Map<String, Object> home() {
        Map<String, Object> testData = new LinkedHashMap<>();
        testData.put("firstName", firstName);
        testData.put("lastName", lastName);
        testData.put("email", email);
        testData.put("studentCode", studentCode);

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("student", fullName);
        body.put("application", "Student CRUD API");
        body.put("version", version);
        body.put("testData", testData);
        body.put("api", "/api/students");
        return body;
    }
}
