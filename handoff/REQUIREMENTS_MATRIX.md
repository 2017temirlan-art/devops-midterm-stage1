# Requirements matrix (source: DevOps_midterm_task.docx)

Legend for "Stage 1 status":
- **Prepared** - the file/code exists in the ZIP. It was NOT executed unless stated in HANDOFF_1.md.
- **Run needed** - nothing to prepare; the command must be run in a real terminal and evidenced.
- **Manual** - done in a web UI (GitHub, Jenkins) or needs the student's personal data.

Example name used everywhere: Turganbek Temirlan (replace via `personalize.sh`).

## Part 1 - Linux administration

| ID | Requirement | Stage 1 status | Where |
|----|-------------|----------------|-------|
| 1.1.1 | Create directory tree `turganbek-temirlan-student-api/{scripts,logs,backups,src}` + Dockerfile, docker-compose.yml, Jenkinsfile, build.gradle, README.md using terminal commands | Prepared (structure exists) + Run needed (show the commands) | RUNBOOK 1.1 |
| 1.1.2 | Personal Bash script `Turganbek_Temirlan_system_report.sh` | Prepared | `scripts/` |
| 1.1.3 | Empty log file `Turganbek_Temirlan_system_report.log` | Prepared (0 bytes) | `logs/` |
| 1.1.4 | Display directory tree, verify all files exist | Run needed | RUNBOOK 1.1 |
| 1.2 | Script prints and saves: full name, date/time, user, OS + kernel, CPU + memory, disk usage, available space; output saved to personal log | Prepared (script written, syntax-checked, functionally tried in a throw-away sandbox copy) + Run needed for evidence | `scripts/Turganbek_Temirlan_system_report.sh` |
| 1.3.1-2 | Make script executable; owner rwx, group/others read-only (mode 755) | Run needed (script is shipped as 644 on purpose, so `chmod 755` can be demonstrated) | RUNBOOK 1.3 |
| 1.3.3 | Backup README.md into `backups/` with the student's name in the file name | Run needed (do it after README is final enough; `backups/` is empty on purpose) | RUNBOOK 1.3 |
| 1.3.4-5 | `ls -l` permissions; show backup exists with expected content | Run needed | RUNBOOK 1.3 |
| 1.4.1 | Show processes, find Java process if any | Run needed | RUNBOOK 1.4 |
| 1.4.2 | Last 5 lines of the log | Run needed | RUNBOOK 1.4 |
| 1.4.3-4 | Search log for surname, write result to `Turganbek_Temirlan_log_analysis.txt` | Run needed | RUNBOOK 1.4 |
| 1.4.5 | Explain `>` vs `>>` | Prepared (text) | EXPLANATIONS.md |
| Evidence | Terminal demonstration, script source, output log, permissions, backup file | Run needed (screenshots) | EVIDENCE_CHECKLIST.md |

## Part 2 - Git and GitHub

| ID | Requirement | Stage 1 status | Where |
|----|-------------|----------------|-------|
| 2.1.1 | `git init` | Run needed (no `.git` in ZIP on purpose) | RUNBOOK 2.1 |
| 2.1.2 | Configure Git user.name / user.email | Manual (needs real name + e-mail) | RUNBOOK 2.1 |
| 2.1.3 | `.gitignore` | Prepared | `.gitignore` |
| 2.1.4 | First commit `Initial commit: Turganbek Temirlan Student API` | Run needed | RUNBOOK 2.1 |
| 2.2.1 | Branch `feature/turganbek-temirlan-crud`; implement/improve ONE CRUD operation | Prepared as ready patches (validation for create/update) | `handoff/feature_patches/` |
| 2.2.2 | README updated with name + description of the change | Run needed (commands given) | RUNBOOK 2.2 |
| 2.2.3 | At least two meaningful commits | Run needed (3 commits planned) | RUNBOOK 2.2 |
| 2.2.4 | Merge into main | Run needed | RUNBOOK 2.2 |
| 2.3 | Branch `feature/turganbek-temirlan-documentation`; same README line changed on two branches; merge; resolve conflict manually; commit; show history | Run needed (README has a `Status:` line designed for this) | RUNBOOK 2.3 |
| 2.4.1-2 | Personal GitHub repo `turganbek-temirlan-student-api`; push main + feature branches | Manual (final publication is NOT stage 1) | RUNBOOK 2.4 |
| 2.4.3-4 | Tag `v1.0-turganbek-temirlan`; show remote URL, history, branches, tag | Run needed | RUNBOOK 2.4 |
| 2.4.5 | Explain why `.env`, passwords, DB credentials must not be committed | Prepared (text) | EXPLANATIONS.md |
| Evidence | GitHub repo, commit history, branch merge, conflict resolution, tag | Run needed | EVIDENCE_CHECKLIST.md |
| Individualization | At least three meaningful personalized commit messages | Planned in runbook | RUNBOOK 2.x |

## Part 3 - Docker and Docker Compose

| ID | Requirement | Stage 1 status | Where |
|----|-------------|----------------|-------|
| 3.1 | Multi-stage Dockerfile: official JDK/Gradle build image, Gradle build, JRE runtime image, copy JAR, EXPOSE configured port (8080), individual image name + tag `turganbek-temirlan-student-api:v1.0-turganbek-temirlan`; build and show size/creation details | Prepared (Dockerfile) / NOT built | `Dockerfile`; RUNBOOK 3.1 |
| 3.2 | Compose: app service, PostgreSQL service, env vars for DB, named volume, dedicated network, PostgreSQL health check, personalized project name; start; both containers running; app uses service name not localhost | Prepared (YAML parsed OK; NOT started) | `docker-compose.yml`, `.env.example`; RUNBOOK 3.2 |
| 3.3.1-6 | ps, logs, inspect, exec, stop/restart, rebuild after version change | Run needed | RUNBOOK 3.3 |
| 3.3.7 | PostgreSQL records persist after restart | Run needed | RUNBOOK 3.3 |
| 3.4 | curl/Postman: create (with own name), list, get by ID, update, delete, 404 case; personalized URL | Prepared (API code + curl commands) / NOT executed | RUNBOOK 3.4 |
| Individualization | Spring Boot app displays the student's name and individual test data | Prepared (`GET /`, startup log line) | `HomeController`, `application.properties` |

## Part 4 - Jenkins CI/CD

| ID | Requirement | Stage 1 status | Where |
|----|-------------|----------------|-------|
| 4.1 | Job `Turganbek_Temirlan_Student_API`, own GitHub repo, JDK + Gradle wrapper + Docker-capable agent, credentials in Jenkins Credentials, verify checkout | Manual (Jenkins UI) | RUNBOOK 4.1 |
| 4.2 | `Jenkinsfile` with stages Checkout, Build, Test, Docker Build, Verify; real image name; stops on failure; student name in build log | Prepared (NOT run in Jenkins) | `Jenkinsfile` |
| 4.3 | Successful run; controlled error on own test branch; failed run; fix; rerun; explain | Run needed | RUNBOOK 4.3 |
| 4.4 | Webhook or polling; new commit starts pipeline automatically; build history + console; CI vs CD explanation | Prepared (`pollSCM` in Jenkinsfile) + Run needed; explanation prepared | RUNBOOK 4.4, EXPLANATIONS.md |
| Note | Automated deployment is NOT required (only if the instructor enables it) | Not implemented, on purpose | - |

## Missing inputs / gaps

1. The student's real name (the example "Turganbek Temirlan" is used) - fixed by `personalize.sh`.
2. Git e-mail, GitHub user name, student identifier (the code uses `TURGANBEK-TEMIRLAN-001` as a placeholder).
3. Gradle wrapper (`gradlew`, `gradle/wrapper/*`) could not be generated here (no Gradle, no network). Jenkinsfile needs it; see RUNBOOK step 0.
4. Section "Example of questions on defense" (about 100 questions) is not answered in stage 1.
