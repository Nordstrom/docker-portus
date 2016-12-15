image_repo := quay.io/nordstrom
image_name := portus
portus_version := 2.1.1
image_version := $(portus_version)-4

build_args := --build-arg=PORTUS_VERSION=$(portus_version)

ifdef http_proxy
build_args += --build-arg=http_proxy=$(http_proxy)
build_args += --build-arg=https_proxy=$(http_proxy)
build_args += --build-arg=HTTP_PROXY=$(http_proxy)
build_args += --build-arg=HTTPS_PROXY=$(http_proxy)
endif

push/image: tag/image
	docker push $(image_repo)/$(image_name):$(image_version)

tag/image: build/image
	docker tag $(image_name) $(image_repo)/$(image_name):$(image_version)

build/image:
	docker build $(build_args) -t $(image_name) .
