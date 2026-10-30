# turganbek-temirlan-student-api

Student: **Turganbek Temirlan**

Spring Boot CRUD REST API for managing students, backed by PostgreSQL.
Built and delivered with Gradle, Docker, Docker Compose, Git/GitHub and Jenkins (DevOps midterm project).

Status: baseline version, all five CRUD operations implemented.

## Project structure

```
turganbek-temirlan-student-api/
├── scripts/            Bash scripts (Turganbek_Temirlan_system_report.sh)
├── logs/               Log files (Turganbek_Temirlan_system_report.log)
├── backups/            Backups of project files
├── src/                Spring Boot application and tests
├── Dockerfile          Multi-stage image build (Gradle + JDK 17 -> JRE 17)
├── docker-compose.yml  Application + PostgreSQL, volume, network, health check
├── Jenkinsfile         Declarative pipeline: Checkout, Build, Test, Docker Build, Verify
├── build.gradle        Gradle build
└── README.md
```

## REST API

| Method | URL                  | Description              | Success | Error |
|--------|----------------------|--------------------------|---------|-------|
| GET    | `/`                  | Student name, version, test data | 200 | |
| GET    | `/api/students`      | List all students        | 200     | |
| GET    | `/api/students/{id}` | Get one student          | 200     | 404 |
| POST   | `/api/students`      | Create a student         | 201     | |
| PUT    | `/api/students/{id}` | Update a student         | 200     | 404 |
| DELETE | `/api/students/{id}` | Delete a student         | 204     | 404 |

Example student JSON:

```json
{
  "firstName": "Temirlan",
  "lastName": "Turganbek",
  "email": "turganbek.temirlan@example.com",
  "studentCode": "TURGANBEK-TEMIRLAN-001"
}
```

## Run with Docker Compose

```bash
cp .env.example .env          # then set your own POSTGRES_PASSWORD in .env
docker compose up -d --build
curl http://localhost:8080/
```

The application reaches PostgreSQL through the Compose service name `postgres`
(`jdbc:postgresql://postgres:5432/...`), never through `localhost`.
PostgreSQL data lives in the named volume `turganbek-temirlan-student-pgdata`.

## Build and test without Docker

```bash
./gradlew clean build      # compiles and runs the tests (H2 in-memory database)
```

## Security

`.env` files, passwords and database credentials are never committed.
Only `.env.example` (placeholder values) is stored in Git.

## Quick start (from zero)

Requirements: Git, Docker Engine + Compose v2 (for Parts 3-4), JDK 17 (only for local Gradle runs).

```bash
# 1. Run the application with PostgreSQL
cp .env.example .env                 # set your own POSTGRES_PASSWORD
docker compose up -d --build
docker compose ps                    # postgres must be "healthy"
curl http://localhost:8080/          # student name and test data

# 2. API test (Task 3.4)
curl -i -X POST http://localhost:8080/api/students -H 'Content-Type: application/json' \
     -d '{"firstName":"Temirlan","lastName":"Turganbek","email":"turganbek.temirlan@example.com","studentCode":"TURGANBEK-TEMIRLAN-001"}'
curl http://localhost:8080/api/students
curl http://localhost:8080/api/students/1
curl -X PUT http://localhost:8080/api/students/1 -H 'Content-Type: application/json' \
     -d '{"firstName":"Temirlan","lastName":"Turganbek","email":"turganbek.temirlan.new@example.com","studentCode":"TURGANBEK-TEMIRLAN-001"}'
curl -i -X DELETE http://localhost:8080/api/students/1
curl -i http://localhost:8080/api/students/999999     # 404

# 3. Stop (data stays in the named volume) / remove everything including data
docker compose down
docker compose down -v
```

## Tests and Jenkins

```bash
./gradlew clean build        # build + tests (H2, no Docker needed)
```

Jenkins: create a Pipeline job `Turganbek_Temirlan_Student_API` -> "Pipeline script from SCM" -> this GitHub repository,
script path `Jenkinsfile`. The agent needs JDK 17 and Docker. The pipeline polls SCM every ~2 minutes
(or configure a GitHub webhook). Credentials (for a private repo) go to Jenkins Credentials, never into the repository.

## Publish to GitHub

```bash
gh auth login
gh repo create turganbek-temirlan-student-api --public --source=. --remote=origin
git push -u origin main --follow-tags
git push origin --all
```
