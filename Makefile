run:
	docker-compose up --build

start:
	docker-compose up -d --build

stop:
	docker-compose stop

status:
	docker-compose ps

restart:
	docker-compose stop
	docker-compose up -d --build

clean:
	docker-compose stop
	docker-compose down

.PHONY: run start stop status restart clean
