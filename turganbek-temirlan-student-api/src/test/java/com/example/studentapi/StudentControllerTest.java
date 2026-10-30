package com.example.studentapi;

import static org.hamcrest.Matchers.containsString;
import static org.hamcrest.Matchers.hasSize;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.example.studentapi.repository.StudentRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class StudentControllerTest {

    private static final String STUDENT_JSON =
            "{\"firstName\":\"Temirlan\",\"lastName\":\"Turganbek\","
                    + "\"email\":\"turganbek.temirlan@example.com\",\"studentCode\":\"TURGANBEK-TEMIRLAN-001\"}";

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private StudentRepository repository;

    @BeforeEach
    void cleanDatabase() {
        repository.deleteAll();
    }

    @Test
    void homeShowsStudentNameAndTestData() throws Exception {
        mockMvc.perform(get("/"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.student").value("Turganbek Temirlan"))
                .andExpect(jsonPath("$.testData.studentCode").value("TURGANBEK-TEMIRLAN-001"));
    }

    @Test
    void createStudentReturns201AndBody() throws Exception {
        mockMvc.perform(post("/api/students")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(STUDENT_JSON))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").isNumber())
                .andExpect(jsonPath("$.lastName").value("Turganbek"));
    }

    @Test
    void getAllReturnsCreatedStudents() throws Exception {
        mockMvc.perform(post("/api/students")
                .contentType(MediaType.APPLICATION_JSON)
                .content(STUDENT_JSON)).andExpect(status().isCreated());

        mockMvc.perform(get("/api/students"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)))
                .andExpect(jsonPath("$[0].firstName").value("Temirlan"));
    }

    @Test
    void getByIdReturnsStudent() throws Exception {
        long id = createStudentAndReturnId();

        mockMvc.perform(get("/api/students/" + id))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(id))
                .andExpect(jsonPath("$.email").value("turganbek.temirlan@example.com"));
    }

    @Test
    void updateStudentChangesFields() throws Exception {
        long id = createStudentAndReturnId();
        String updated = "{\"firstName\":\"Temirlan\",\"lastName\":\"Turganbek\","
                + "\"email\":\"turganbek.temirlan.updated@example.com\",\"studentCode\":\"TURGANBEK-TEMIRLAN-001\"}";

        mockMvc.perform(put("/api/students/" + id)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(updated))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.email").value("turganbek.temirlan.updated@example.com"));
    }

    @Test
    void deleteStudentThenGetReturns404() throws Exception {
        long id = createStudentAndReturnId();

        mockMvc.perform(delete("/api/students/" + id)).andExpect(status().isNoContent());
        mockMvc.perform(get("/api/students/" + id)).andExpect(status().isNotFound());
    }

    @Test
    void nonexistentStudentReturns404WithMessage() throws Exception {
        mockMvc.perform(get("/api/students/999999"))
                .andExpect(status().isNotFound())
                .andExpect(content().string(containsString("was not found")))
                .andExpect(jsonPath("$.status").value(404));
    }

    private long createStudentAndReturnId() throws Exception {
        MvcResult result = mockMvc.perform(post("/api/students")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(STUDENT_JSON))
                .andExpect(status().isCreated())
                .andReturn();
        String body = result.getResponse().getContentAsString();
        return com.jayway.jsonpath.JsonPath.parse(body).read("$.id", Long.class);
    }
}
