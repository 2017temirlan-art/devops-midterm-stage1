# syntax=docker/dockerfile:1

# ---------- Stage 1: build the Spring Boot JAR with Gradle (official Gradle image with JDK 17) ----------
FROM gradle:8.10.2-jdk17 AS build
WORKDIR /workspace
COPY build.gradle settings.gradle ./
COPY src ./src
# Tests are executed in the Jenkins "Test" stage, so they are skipped here.
RUN gradle bootJar --no-daemon -x test

# ---------- Stage 2: minimal Java runtime (official Temurin JRE 17) ----------
FROM eclipse-temurin:17-jre
ARG APP_VERSION=v1.0-turganbek-temirlan
LABEL org.opencontainers.image.title="turganbek-temirlan-student-api" \
      org.opencontainers.image.version="${APP_VERSION}" \
      org.opencontainers.image.authors="Turganbek Temirlan"

WORKDIR /app
RUN groupadd --system spring && useradd --system --gid spring spring
COPY --from=build /workspace/build/libs/app.jar app.jar
USER spring:spring

# Port configured in application.properties (server.port=8080)
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
