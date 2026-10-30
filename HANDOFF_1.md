# HANDOFF_1 - этап 1 из 3 (подготовка проекта)

Источник: `DevOps_midterm_task.docx` (DevOps midterm: Linux, Git/GitHub, Docker/Compose, Jenkins).
Этап 1 = разбор задания + структура проекта + исходные файлы + документы передачи. **Ни один этап задания не выполнялся «по-настоящему»**: нет ни реальных логов, ни скриншотов, ни GitHub-репозитория, ни сборки Docker/Gradle/Jenkins.

## 1. Что требует задание (кратко; полная матрица - `handoff/REQUIREMENTS_MATRIX.md`)

- **Часть 1 Linux**: дерево `asan-abai-student-api/{scripts,logs,backups,src,Dockerfile,docker-compose.yml,Jenkinsfile,build.gradle,README.md}`; скрипт `Asan_Abai_system_report.sh` (ФИО, дата, пользователь, ОС/ядро, CPU/RAM, диск, свободное место -> персональный лог); `chmod 755`; бэкап README с именем в файле; `ps` + поиск Java; `tail -n 5`; `grep` фамилии -> `Asan_Abai_log_analysis.txt`; объяснить `>` и `>>`.
- **Часть 2 Git/GitHub**: `git init`, user.name/email, `.gitignore`, первый коммит `Initial commit: Asan Abai Student API`; ветка `feature/asan-abai-crud` (улучшить одну CRUD-операцию, обновить README, >= 2 коммита, merge в main); ветка `feature/asan-abai-documentation` и конфликт в одной строке README, ручное разрешение; GitHub-репозиторий `asan-abai-student-api`, push main и feature-веток, тег `v1.0-asan-abai`; объяснить, почему нельзя коммитить `.env`/пароли.
- **Часть 3 Docker**: multi-stage Dockerfile (JDK-образ + Gradle -> JRE), `EXPOSE`, образ `asan-abai-student-api:v1.0-asan-abai`, размер/дата; Compose (app + PostgreSQL, env, именованный volume, отдельная сеть, healthcheck, имя проекта); БД по имени сервиса, не `localhost`; управление контейнерами (ps, logs, inspect, exec, stop/start, пересборка после смены версии, сохранность данных PostgreSQL); curl/Postman: create, list, get by id, update, delete, 404.
- **Часть 4 Jenkins**: job `Asan_Abai_Student_API`, свой репозиторий, JDK + Gradle wrapper + Docker-agent, Credentials; `Jenkinsfile` со стадиями Checkout, Build, Test, Docker Build, Verify (остановка при ошибке, имя студента в логе); успешный прогон -> контролируемая ошибка в своей test-ветке -> падение -> исправление -> успех; webhook или polling; CI vs CD. Автодеплой не обязателен.
- **Индивидуализация (п. 6)**: имена скрипта, логов, бэкапа, репозитория, веток, >= 3 персональных коммита, образ/тег, Compose-проект, Jenkins job, имя в консоли Jenkins, имя и тестовые данные в Spring Boot-приложении.
- Раздел «вопросы на защиту» (~100 вопросов) в этапе 1 **не отвечался**.

## 2. Важное допущение: имя студента

В задании имя - пример («replacing the example name with your own»). Реальное имя мне неизвестно, поэтому весь проект сделан на примере **Asan Abai** (`Asan` = первое слово, `Abai` = второе, порядок как в примере). Замена одной командой: `./personalize.sh <Слово1> <Слово2>` (до `git init`). Нужно также решить, какое из двух слов является фамилией (для `grep` в Task 1.4) и подставить реальный student ID вместо `ASAN-ABAI-001` в `application.properties` и тесте.

## 3. Что создано

```
devops-midterm-stage1/
├── HANDOFF_1.md
├── personalize.sh                       замена имени-примера на реальное
├── handoff/
│   ├── REQUIREMENTS_MATRIX.md           все требования -> статус -> где
│   ├── COMMANDS_RUNBOOK.md              точные команды для частей 1-4 (+ шаг 0)
│   ├── EVIDENCE_CHECKLIST.md            28 пунктов скриншотов/файлов
│   ├── EXPLANATIONS.md                  черновики: > vs >>, секреты в Git, CI vs CD
│   └── feature_patches/                 2 патча для ветки feature/asan-abai-crud
└── asan-abai-student-api/               проект (будущий Git-репозиторий)
    ├── scripts/Asan_Abai_system_report.sh      (права 644 намеренно)
    ├── logs/Asan_Abai_system_report.log        (0 байт, намеренно)
    ├── backups/.gitkeep                        (пусто, бэкап делается на этапе выполнения)
    ├── src/main/java/com/example/studentapi/   Application, model, repository, service, controller (CRUD + GET /), exception (404)
    ├── src/main/resources/application.properties
    ├── src/test/...                            StudentControllerTest, StudentApiApplicationTests, application-test.properties (H2)
    ├── Dockerfile, docker-compose.yml, Jenkinsfile, build.gradle, settings.gradle, README.md
    └── .gitignore, .dockerignore, .env.example
```

Ключевые решения: Java 17, Spring Boot 3.3.5, Gradle 8.10.2; Dockerfile: `gradle:8.10.2-jdk17` -> `eclipse-temurin:17-jre`, порт 8080, jar `app.jar`; Compose: `name: asan-abai-student-api`, сервис БД называется `postgres`, volume `asan-abai-student-pgdata`, сеть `asan-abai-student-net`, healthcheck `pg_isready`, пароль берётся из `.env` (не коммитится); тесты используют H2 (профиль `test`), Docker/PostgreSQL для них не нужны; Jenkinsfile использует `pollSCM('H/2 * * * *')`; приложение показывает имя студента на `GET /` и в стартовом логе; версия приложения берётся из `build.gradle` (`version = '1.0'`).

## 4. Что реально проверено (и как)

| Проверка | Результат |
|---|---|
| `bash -n` для `Asan_Abai_system_report.sh` и `personalize.sh` | синтаксис корректен |
| Скрипт отчёта запущен **во временной копии в песочнице** (Ubuntu 24.04) | работает, пишет в лог через `tee -a`; этот вывод **не** является доказательством для сдачи; боевой лог в ZIP остался 0 байт |
| `docker-compose.yml` разобран Python-YAML | валидный YAML, сервисы `postgres`, `app`. **`docker compose config` не запускался** |
| Java-исходники прогнаны через `jdk.compiler` без Spring-зависимостей | синтаксических ошибок нет (ошибки только «нет пакета/символа» из-за отсутствия библиотек). **Это не компиляция проекта** |
| Патчи `feature_patches/*.patch` | `git apply --check` и применение на чистой копии проходят, в т.ч. после `personalize.sh` |
| Git-сценарий из runbook 2.1-2.3 на временной копии | отрабатывает: `.env` игнорируется, 3 коммита в feature-ветке, merge, конфликт в README возникает как задумано |
| `personalize.sh` на временной копии (имя «Aigerim Nurlanova») | остатков `asan/abai` нет, файлы и каталог переименованы |

## 5. Что НЕ сделано / не проверено

- Gradle wrapper (`gradlew`, `gradle/wrapper/*`) **не создан**: в песочнице нет Gradle и сети. Без него Jenkinsfile не заработает.
- Проект ни разу не собирался и не тестировался (`./gradlew build/test` не запускался): версии зависимостей, тесты и код могут потребовать правок.
- Docker-образ не собирался, Compose не запускался, curl-запросы к API не выполнялись.
- Jenkins не настраивался и не запускался; GitHub-репозиторий, push, тег не создавались (по условию этапа).
- Нет `.git` (намеренно), нет бэкапа README (намеренно), скрипт без `+x` (намеренно, чтобы показать `chmod 755`).
- Нет ни одного скриншота и ни одного реального лога.
- Часть 2.2: улучшение CRUD подготовлено как патчи (валидация для POST/PUT), но не применялось в реальном репозитории.

## 6. Оставшиеся задачи

1. Получить от пользователя: имя (латиницей), какое слово - фамилия, e-mail для Git, GitHub-логин, student ID.
2. Шаг 0 runbook: `personalize.sh`, генерация Gradle wrapper, `./gradlew clean build` (исправить ошибки, если будут).
3. Части 1-2: выполнить команды в реальном терминале, снять скриншоты (`EVIDENCE_CHECKLIST.md`).
4. Часть 3: нужен хост с Docker Engine + Compose v2.
5. Часть 4: нужен Jenkins с JDK 17 и Docker-capable агентом.
6. Финальная публикация на GitHub (2.4) и привязка Jenkins job к репозиторию.
7. Заполнить объяснение к Task 4.3 по реальному логу; при желании подготовить ответы на вопросы защиты.

## 7. Точная инструкция для следующего аккаунта

1. Распаковать ZIP, прочитать этот файл и `handoff/REQUIREMENTS_MATRIX.md`.
2. Если реальное имя ещё не известно - спросить пользователя (пункт 6.1). Не придумывать имя, e-mail, student ID.
3. Из корня распакованного архива: `./personalize.sh Слово1 Слово2` -> затем `cd <слово1>-<слово2>-student-api`.
4. Выполнить «Step 0» из `handoff/COMMANDS_RUNBOOK.md` (wrapper, `./gradlew clean build`). Если сборка падает - показать пользователю точную ошибку, исправить код, зафиксировать исправление в отчёте.
5. Идти по runbook строго по порядку: Часть 1 -> 2.1-2.3 -> (2.4 только по команде пользователя) -> Часть 3 -> Часть 4. Папки `handoff/` и репозиторий должны лежать рядом (патчи берутся из `../handoff/feature_patches`).
6. Если окружение без терминала/Docker/Jenkins, выдать пользователю готовые команды и список скриншотов, а результаты и логи принимать только от пользователя - **не выдумывать вывод команд, логи, статусы сборок и скриншоты**.
7. `.env` не коммитить, токены и пароли не писать в файлы репозитория.
8. Создать `HANDOFF_2.md`: что выполнено реально (с фактическими выводами), что упало и почему, что осталось.
