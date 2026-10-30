# Commands runbook

All commands are NOT yet executed (except where HANDOFF_1.md says otherwise). Run them in a real terminal and take the screenshots listed in EVIDENCE_CHECKLIST.md. Never paste invented output.

Layout after unpacking the ZIP:

```
<zip-root>/
├── HANDOFF_1.md
├── personalize.sh
├── handoff/                      (docs + feature_patches/, NOT part of the Git repo)
└── turganbek-temirlan-student-api/        (the Git repo / project)
```

## Step 0 - Preparation (before anything else)

```bash
# 0.1 Replace the example name with the real one (before git init)
./personalize.sh Word1 Word2          # e.g. ./personalize.sh Aigerim Nurlanova

# 0.2 Generate the Gradle wrapper (Jenkinsfile needs ./gradlew). Choose ONE:
cd turganbek-temirlan-student-api
gradle wrapper --gradle-version 8.10.2                       # if Gradle is installed
# or, with Docker only:
docker run --rm -v "$PWD":/w -w /w gradle:8.10.2-jdk17 gradle wrapper --gradle-version 8.10.2
sudo chown -R "$USER":"$USER" .                              # only if Docker created root-owned files
ls gradlew gradlew.bat gradle/wrapper/                       # expect gradle-wrapper.jar + .properties

# 0.3 First local check (needs JDK 17 and network for dependencies)
chmod +x gradlew && ./gradlew clean build
```

If `./gradlew clean build` fails, copy the exact error and fix the code before continuing (the Java code was never compiled in stage 1).

## Part 1 - Linux (run inside `turganbek-temirlan-student-api/`)

### 1.1 Structure
```bash
pwd
mkdir -p scripts logs backups src
touch Dockerfile docker-compose.yml Jenkinsfile build.gradle README.md   # touch does not erase existing content
touch logs/Turganbek_Temirlan_system_report.log
ls -la
tree -a -L 2 -I '.git|build|.gradle'        # install: sudo apt install tree  (macOS: brew install tree)
for f in scripts logs backups src Dockerfile docker-compose.yml Jenkinsfile build.gradle README.md \
         scripts/Turganbek_Temirlan_system_report.sh logs/Turganbek_Temirlan_system_report.log; do
  [ -e "$f" ] && echo "OK      $f" || echo "MISSING $f"
done
```

### 1.2 Script
```bash
bash -n scripts/Turganbek_Temirlan_system_report.sh          # syntax check
bash scripts/Turganbek_Temirlan_system_report.sh             # run once (appends to the log)
bash scripts/Turganbek_Temirlan_system_report.sh             # run twice, so the log has several lines/reports
cat logs/Turganbek_Temirlan_system_report.log
```

### 1.3 Permissions and backup
```bash
ls -l scripts/Turganbek_Temirlan_system_report.sh            # before: expected -rw-r--r-- (if already executable: chmod 644 first)
chmod +x scripts/Turganbek_Temirlan_system_report.sh         # step 1: executable
chmod 755 scripts/Turganbek_Temirlan_system_report.sh        # step 2: owner rwx, group/others r-x
ls -l scripts/Turganbek_Temirlan_system_report.sh            # expected -rwxr-xr-x
./scripts/Turganbek_Temirlan_system_report.sh | head -5      # runs directly now

BACKUP="backups/README_Turganbek_Temirlan_backup_$(date +%Y%m%d_%H%M%S).md"
cp README.md "$BACKUP"
ls -l backups/
diff README.md "$BACKUP" && echo "backup identical to README.md"
head -10 "$BACKUP"
```

### 1.4 Processes and log analysis
```bash
ps aux | head -15
ps aux | grep -i '[j]ava' || echo "no Java process is running"     # Jenkins/Gradle will show up here if running
tail -n 5 logs/Turganbek_Temirlan_system_report.log
grep -n "Temirlan" logs/Turganbek_Temirlan_system_report.log                    # use the real SURNAME
grep -n "Temirlan" logs/Turganbek_Temirlan_system_report.log > logs/Turganbek_Temirlan_log_analysis.txt
cat logs/Turganbek_Temirlan_log_analysis.txt
```
Explanation of `>` vs `>>`: see EXPLANATIONS.md.

## Part 2 - Git and GitHub (inside `turganbek-temirlan-student-api/`)

### 2.1 Initialization
```bash
git init -b main
git config user.name  "Turganbek Temirlan"
git config user.email "YOUR_EMAIL"                  # real e-mail (GitHub noreply address is fine)
git config --local --list | grep -E "user\.(name|email)"
cat .gitignore
cp .env.example .env                                # local secret file; edit the password
git add .
git status                                          # .env must NOT be listed
git check-ignore -v .env                            # proves .env is ignored
git commit -m "Initial commit: Turganbek Temirlan Student API"
git log --oneline
```

### 2.2 Feature branch `feature/turganbek-temirlan-crud` (improves create + update with validation)
```bash
PATCHES=../handoff/feature_patches
git switch -c feature/turganbek-temirlan-crud

git apply --check $PATCHES/0001-add-validation-to-create-and-update.patch
git apply $PATCHES/0001-add-validation-to-create-and-update.patch
git add -A
git commit -m "Add input validation to create and update student operations (Turganbek Temirlan)"

git apply --check $PATCHES/0002-add-validation-tests.patch
git apply $PATCHES/0002-add-validation-tests.patch
git add -A
git commit -m "Add validation tests for student create operation (Turganbek Temirlan)"

cat >> README.md <<'EOT'

## Change log

- Turganbek Temirlan: added Bean Validation (`@NotBlank`, `@Email`) to the create (POST) and update (PUT) operations. Invalid requests now return HTTP 400 with a JSON error message.
EOT
sed -i 's/^Status: .*/Status: validation added to create and update operations./' README.md
git add README.md
git commit -m "Update README with Turganbek Temirlan and description of the validation change"

./gradlew test                                      # run before merging
git switch main
git merge --no-ff feature/turganbek-temirlan-crud -m "Merge feature/turganbek-temirlan-crud into main (Turganbek Temirlan)"
git log --oneline --graph --decorate
```

### 2.3 Conflict resolution
```bash
# Branch A: documentation
git switch -c feature/turganbek-temirlan-documentation main
sed -i 's/^Status: .*/Status: documentation branch - API documentation extended by Turganbek Temirlan./' README.md
git commit -am "docs: change README status line on documentation branch (Turganbek Temirlan)"

# Branch B: second branch, same line, different text (created from the same main commit)
git switch main
git switch -c feature/turganbek-temirlan-readme-status
sed -i 's/^Status: .*/Status: ready for Docker and Jenkins stages - updated by Turganbek Temirlan./' README.md
git commit -am "docs: change README status line on readme-status branch (Turganbek Temirlan)"

# Merge both into main
git switch main
git merge feature/turganbek-temirlan-documentation           # fast-forward, no conflict
git merge feature/turganbek-temirlan-readme-status           # EXPECTED: CONFLICT in README.md
git status
git diff                                            # shows <<<<<<< ======= >>>>>>> markers
```
Resolve manually: open `README.md` in an editor, delete the three marker lines and leave ONE final `Status:` line (for example `Status: documentation and readme status merged by Turganbek Temirlan.`), then:
```bash
grep -n '<<<<<<<\|=======\|>>>>>>>' README.md || echo "no conflict markers left"
git add README.md
git commit -m "Resolve README.md merge conflict between documentation and readme-status branches (Turganbek Temirlan)"
git log --oneline --graph --decorate --all
```

### 2.4 Remote and tag (final publication - NOT done in stage 1)
```bash
# Create the empty GitHub repository turganbek-temirlan-student-api in the web UI first (no README, no .gitignore).
git remote add origin https://github.com/GITHUB_USER/turganbek-temirlan-student-api.git
git push -u origin main
git push origin feature/turganbek-temirlan-crud feature/turganbek-temirlan-documentation feature/turganbek-temirlan-readme-status
git tag -a v1.0-turganbek-temirlan -m "Release v1.0 - Turganbek Temirlan Student API"
git push origin v1.0-turganbek-temirlan
git remote -v
git log --oneline --graph --decorate --all
git branch -a
git tag
```
Authentication: GitHub personal access token or SSH key. Never put tokens in files inside the repo.

## Part 3 - Docker (Docker Engine + Compose v2 required)

### 3.1 Image
```bash
docker build --build-arg APP_VERSION=v1.0-turganbek-temirlan -t turganbek-temirlan-student-api:v1.0-turganbek-temirlan .
docker images turganbek-temirlan-student-api
docker image inspect turganbek-temirlan-student-api:v1.0-turganbek-temirlan --format 'Created: {{.Created}}  Size: {{.Size}} bytes'
docker history turganbek-temirlan-student-api:v1.0-turganbek-temirlan
```

### 3.2 Compose
```bash
cp -n .env.example .env && nano .env                # set POSTGRES_PASSWORD (do not commit .env)
docker compose config > /dev/null && echo "compose file valid"
docker compose up -d --build
docker compose ps
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
docker compose exec app env | grep SPRING_DATASOURCE_URL     # must contain "postgres:5432", not localhost
curl -s http://localhost:8080/                      # shows student name + test data
docker compose logs app | grep -i "Student API started"
```

### 3.3 Container management
```bash
docker ps
docker logs turganbek-temirlan-student-api-app --tail 50
docker inspect turganbek-temirlan-student-api-app | head -60
docker exec turganbek-temirlan-student-api-app whoami        # or: docker exec turganbek-temirlan-student-api-app java -version
docker compose stop app && docker compose ps
docker compose start app && docker compose ps       # or: docker compose restart app

# Rebuild after changing the application version
sed -i "s/^version = '1.0'/version = '1.1'/" build.gradle
sed -i 's/^APP_VERSION=.*/APP_VERSION=v1.1-turganbek-temirlan/' .env
docker compose up -d --build app
curl -s http://localhost:8080/                      # "version" should now be 1.1
docker images turganbek-temirlan-student-api

# Persistence of PostgreSQL data (see 3.4 for the create call)
curl -s -X POST http://localhost:8080/api/students -H 'Content-Type: application/json' \
  -d '{"firstName":"Turganbek","lastName":"Temirlan","email":"turganbek.temirlan@example.com","studentCode":"TURGANBEK-TEMIRLAN-001"}'
docker compose down                                 # do NOT add -v (it would delete the volume)
docker volume ls | grep turganbek-temirlan
docker compose up -d
sleep 20
curl -s http://localhost:8080/api/students          # the record is still there
```

### 3.4 API tests with curl
```bash
BASE=http://localhost:8080
curl -i -X POST $BASE/api/students -H 'Content-Type: application/json' \
  -d '{"firstName":"Turganbek","lastName":"Temirlan","email":"turganbek.temirlan@example.com","studentCode":"TURGANBEK-TEMIRLAN-001"}'   # 201, note the id
curl -i $BASE/api/students                                    # 200 list
curl -i $BASE/api/students/1                                  # 200 (use the real id)
curl -i -X PUT $BASE/api/students/1 -H 'Content-Type: application/json' \
  -d '{"firstName":"Turganbek","lastName":"Temirlan","email":"turganbek.temirlan.updated@example.com","studentCode":"TURGANBEK-TEMIRLAN-001"}'   # 200
curl -i -X DELETE $BASE/api/students/1                        # 204
curl -i $BASE/api/students/999999                             # 404 JSON error
```
After the feature branch is merged, also show a validation error: POST with `"firstName":""` returns 400.

## Part 4 - Jenkins

### 4.1 Setup (web UI)
1. Jenkins needs: JDK 17, Git, a Docker-capable agent (docker CLI + permission to use the Docker daemon, e.g. user `jenkins` in group `docker`), plugins: Pipeline, Git, GitHub (optional), JUnit.
2. New Item -> name `Turganbek_Temirlan_Student_API` -> Pipeline.
3. Pipeline -> Definition: "Pipeline script from SCM" -> SCM: Git -> Repository URL: the student's GitHub repo -> Branch: `*/main` -> Script Path: `Jenkinsfile`.
4. Private repo: Manage Jenkins -> Credentials -> add "Username with password" (GitHub user + personal access token) and select it in the job. No token in the repo or Jenkinsfile.
5. Run once; the console must show the checkout (`git log -1 --oneline`).

### 4.3 Success, controlled failure, fix
```bash
# 1) Successful run on main (Build Now) - screenshot stage view + console
# 2) Controlled error on a separate test branch
git switch -c test/turganbek-temirlan-ci-failure
sed -i 's/value("Turganbek Temirlan")/value("Wrong Name")/' src/test/java/com/example/studentapi/StudentControllerTest.java
git commit -am "test: introduce controlled failing test (Turganbek Temirlan)"
git push -u origin test/turganbek-temirlan-ci-failure
# In the Jenkins job set Branch Specifier to */test/turganbek-temirlan-ci-failure -> Build Now -> Test stage FAILS, Docker Build/Verify are skipped
# 3) Fix
git revert --no-edit HEAD
git push
# Build Now again -> SUCCESS. Afterwards set Branch Specifier back to */main. Do NOT merge this test branch into main.
```

### 4.4 Automation
- Polling: `triggers { pollSCM('H/2 * * * *') }` is already in the Jenkinsfile (it becomes active after the first run).
- Webhook (needs a publicly reachable Jenkins URL, e.g. a tunnel): GitHub repo -> Settings -> Webhooks -> `http://JENKINS_URL/github-webhook/` (push events) and enable "GitHub hook trigger for GITScm polling" in the job.
```bash
git switch main
echo "" >> README.md && echo "CI trigger check by Turganbek Temirlan" >> README.md
git commit -am "docs: trigger Jenkins pipeline automatically (Turganbek Temirlan)"
git push
# Show: build starts without clicking, Build History, Console Output
```
CI vs CD: see EXPLANATIONS.md.
