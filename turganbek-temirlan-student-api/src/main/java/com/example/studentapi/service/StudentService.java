package com.example.studentapi.service;

import com.example.studentapi.exception.StudentNotFoundException;
import com.example.studentapi.model.Student;
import com.example.studentapi.repository.StudentRepository;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class StudentService {

    private final StudentRepository repository;

    public StudentService(StudentRepository repository) {
        this.repository = repository;
    }

    public List<Student> findAll() {
        return repository.findAll();
    }

    public Student findById(Long id) {
        return repository.findById(id).orElseThrow(() -> new StudentNotFoundException(id));
    }

    public Student create(Student student) {
        student.setId(null); // the database generates the id
        return repository.save(student);
    }

    public Student update(Long id, Student update) {
        Student existing = findById(id);
        existing.setFirstName(update.getFirstName());
        existing.setLastName(update.getLastName());
        existing.setEmail(update.getEmail());
        existing.setStudentCode(update.getStudentCode());
        return repository.save(existing);
    }

    public void delete(Long id) {
        Student existing = findById(id);
        repository.delete(existing);
    }
}
