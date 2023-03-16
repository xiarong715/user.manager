image_name=user.manager:v1.0

up: dev-env
down: docker-stop

dev-env:
	@ $(MAKE) .image-build
	@ docker-compose up -d --build mysql
	@ docker-compose up -d web

.ONESHELL:  # 没起作用
.image-build:
	@ echo "Docker Build"  # @ 不显示命令本身，只显示命令的结果
	@ docker build --file Dockerfile --tag $(image_name) .
	@ touch .image-build

docker-stop:
	@ docker-compose down

clean:

clean-all:
	@ $(MAKE) down
	docker image rm -f $(image_name)
	rm -rf .image-build