# Порядок запуска (ничего не пропускать)

```bash
unzip <архив>; cd devops-midterm-stage1
./run_part1.sh                                   # Часть 1 (вывод = доказательства)
./run_part2_git.sh you@example.com GITHUB_USER   # Часть 2: git, ветки, конфликт, тег; при `gh auth login` создаёт репозиторий и пушит
cd *-student-api && ./gradlew clean build        # нужна сеть/JDK 17
cp .env.example .env && docker compose up -d --build   # Часть 3 (см. README проекта)
```
Часть 4 (Jenkins) — см. handoff/COMMANDS_RUNBOOK.md. Без `gh`: создайте пустой репозиторий на GitHub и выполните `git remote add origin ...; git push -u origin main --follow-tags; git push origin --all`.
