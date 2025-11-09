FROM ubuntu:22.04

# Установка временной зоны (например Europe/Moscow)
ENV TZ=Europe/Moscow

# Настраиваем локальную временную зону в системе
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Обновление и установка базовых утилит
RUN apt-get update && \
    apt-get install -y awscli gzip curl gpg postgresql-client && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y wget gnupg2 lsb-release awscli gzip && \
    echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y postgresql-client-17

# Копируем скрипт бэкапа в контейнер
COPY backup.sh /usr/local/bin/backup.sh

# Делаем скрипт исполняемым
RUN chmod +x /usr/local/bin/backup.sh

# Выполняем скрипт при запуске контейнера
ENTRYPOINT ["/usr/local/bin/backup.sh"]


# RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
# RUN curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg

# RUN apt-get update && \
#     apt-get install postgresql-17 -y