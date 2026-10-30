# Evidence checklist (screenshots and files)

Keep evidence OUTSIDE the Git repo, e.g. `<zip-root>/evidence/`. Only real terminal/UI output: no edited or invented screenshots. Every screenshot should show the student's name (terminal prompt, command, or file) where possible.

| # | Task | What must be visible | Suggested file name |
|---|------|----------------------|---------------------|
| 1 | 1.1 | mkdir/touch commands, `ls -la`, `tree`, verification loop (all OK) | `p1_1_structure.png` |
| 2 | 1.2 | script source (`cat scripts/Turganbek_Temirlan_system_report.sh`) | `p1_2_script_source.png` |
| 3 | 1.2 | script run: name, date, user, OS/kernel, CPU, memory, disk | `p1_2_script_run.png` |
| 4 | 1.2 | `cat logs/Turganbek_Temirlan_system_report.log` | `p1_2_log.png` |
| 5 | 1.3 | `ls -l` before and after `chmod 755` | `p1_3_permissions.png` |
| 6 | 1.3 | backup created, `ls -l backups/`, `diff` and `head` | `p1_3_backup.png` |
| 7 | 1.4 | `ps aux` + Java process search result | `p1_4_processes.png` |
| 8 | 1.4 | `tail -n 5`, `grep` for surname, `cat Turganbek_Temirlan_log_analysis.txt` | `p1_4_log_analysis.png` |
| 9 | 2.1 | git config, `.gitignore`, `git status`, first commit message with the real name | `p2_1_init_commit.png` |
| 10 | 2.2 | branch `feature/turganbek-temirlan-crud`, 3 commits, README diff | `p2_2_feature_commits.png` |
| 11 | 2.2 | merge into main, `git log --graph` | `p2_2_merge.png` |
| 12 | 2.3 | conflict message, markers in README, resolved README, resolution commit | `p2_3_conflict.png` |
| 13 | 2.3 | final `git log --oneline --graph --decorate --all` | `p2_3_history.png` |
| 14 | 2.4 | GitHub repo page (name, branches) | `p2_4_github_repo.png` |
| 15 | 2.4 | `git remote -v`, `git branch -a`, `git tag`, tag on GitHub | `p2_4_remote_tag.png` |
| 16 | 3.1 | `docker build` end of output, `docker images`, `docker image inspect` (size, created) | `p3_1_image.png` |
| 17 | 3.2 | `docker compose up -d`, `docker compose ps` (both containers up, postgres healthy) | `p3_2_compose_up.png` |
| 18 | 3.2 | `SPRING_DATASOURCE_URL` contains `postgres:5432`; `curl /` with student name | `p3_2_service_name.png` |
| 19 | 3.3 | `docker ps`, logs, inspect (excerpt), exec | `p3_3_management.png` |
| 20 | 3.3 | stop/start of app, rebuild with new version, `curl /` shows version 1.1 | `p3_3_restart_rebuild.png` |
| 21 | 3.3 | persistence: record before `down`/`up`, record after | `p3_3_persistence.png` |
| 22 | 3.4 | curl: POST 201, GET all, GET by id, PUT, DELETE 204, 404 case (with `-i` headers) | `p3_4_api_*.png` |
| 23 | 4.1 | Jenkins job `Turganbek_Temirlan_Student_API` config (repo URL, credentials selected, no secrets shown) | `p4_1_job_config.png` |
| 24 | 4.1 | console: successful checkout | `p4_1_checkout.png` |
| 25 | 4.2/4.3 | successful run: stage view with 5 green stages, console with student name | `p4_3_success.png` |
| 26 | 4.3 | failed run on test branch: Test stage red, later stages skipped | `p4_3_failed.png` |
| 27 | 4.3 | fixed run: green again | `p4_3_fixed.png` |
| 28 | 4.4 | trigger configuration (webhook or polling), build started automatically after a commit, build history, console output | `p4_4_trigger_*.png` |

Files to submit besides screenshots: `Turganbek_Temirlan_system_report.sh`, `Turganbek_Temirlan_system_report.log`, `Turganbek_Temirlan_log_analysis.txt`, the backup file, link to the GitHub repository, text answers from EXPLANATIONS.md.
