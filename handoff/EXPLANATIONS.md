# Required written explanations (draft text, review and put in your own words before submitting)

## Task 1.4 - difference between `>` and `>>`

`>` redirects standard output to a file and **overwrites** it: if the file already exists, its old content is lost (the file is truncated first). `>>` **appends** the output to the end of the file and keeps the existing content. Example: `grep "Temirlan" report.log > analysis.txt` always leaves only the latest search result, while `echo "line" >> analysis.txt` adds a line each time. The report script uses `tee -a` (append) so that every run adds a new report to the log instead of erasing the previous one.

## Task 2.4 - why `.env` files, passwords and database credentials must not be committed

Git stores the full history, so a committed secret stays in the repository history even after the file is deleted. Anyone with access to the repository (or to a public GitHub repository, anybody on the internet, including automated scanners) can read the password and connect to the database, API or cloud account. Secrets in a repository also get copied to every clone and fork and cannot be reliably withdrawn; the only safe fix is to change the leaked credentials. Therefore `.env` is listed in `.gitignore`, only `.env.example` with placeholder values is committed, and real values are passed through environment variables, Docker/Compose environment settings or Jenkins Credentials.

## Task 4.4 - Continuous Integration vs Continuous Deployment

**Continuous Integration (CI)**: every change pushed to the repository is automatically built and tested (here: Jenkins runs Gradle build, unit tests and builds the Docker image), so integration problems and failing tests are found quickly. **Continuous Delivery** additionally keeps every successful build ready to release, with a manual approval before production. **Continuous Deployment (CD)** goes one step further: every change that passes the pipeline is deployed to the target environment automatically, without manual approval. In this project the pipeline stops at the Verify stage (CI only); automated deployment is not required unless the instructor enables it.

## Task 4.3 - explanation of the failure (fill in AFTER the real failed run)

To be written from the real console output: which stage failed, the actual error line, the cause (the intentionally wrong expected student name in `StudentControllerTest`), the fix (`git revert`), and the result of the rerun. Do not write this section before the run.
