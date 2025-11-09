IMAGE_NAME=pg_backup_ubuntu_app

build:
	docker build -t $(IMAGE_NAME) .

run:
	docker run --env-file .env -it $(IMAGE_NAME)

# Остановить все запущенные контейнеры с этим образом
stop:
	docker ps -q --filter ancestor=$(IMAGE_NAME) | xargs -r docker stop

prod:
	docker build -t pg_backup .

	docker run --rm \
	-e PGHOST=your_pg_host \
	-e PGPORT=5432 \
	-e PGUSER=your_pg_user \
	-e PGPASSWORD=your_pg_password \
	-e DBNAME=your_db_name \
	-e S3_BUCKET=your_s3_bucket \
	-e S3_PATH=your/s3/path \
	pg_backup

compose:
	docker compose up -d