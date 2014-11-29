NAME="example"
PUBLIC_PORT=3000
PORT=${PUBLIC_PORT}
IMAGE_NAME = "grengojbo/${NAME}"
SITE="site.uatv.me"

# Program version
VERSION := $(shell grep "const Version " version.go | sed -E 's/.*"(.+)"$$/\1/')

# Binary name for bintray
BIN_NAME=$(shell basename $(abspath ./))

# Project owner for bintray
OWNER=grengojbo

# Project name for bintray
PROJECT_NAME=$(shell basename $(abspath ./))

# Project url used for builds
# examples: github.com, bitbucket.org
REPO_HOST_URL=bitbucket.org

# Grab the current commit
GIT_COMMIT="$(shell git rev-parse HEAD)"

# Check if there are uncommited changes
GIT_DIRTY="$(shell test -n "`git status --porcelain`" && echo "+CHANGES" || true)"

# Add the godep path to the GOPATH
#GOPATH=$(shell godep path):$(shell echo $$GOPATH)

push:
	git push deis master

destroy:
	deis apps:destroy --app=${NAME} --confirm=${NAME}

create:
	deis create ${NAME}
	deis domains:add ${SITE} -a ${NAME}
	deis limits:set -m cmd=64M -a ${NAME}
	deis tags:set cluster=yes -a ${NAME}
	deis config:set NAME_APP=${NAME} -a ${NAME}
	# deis config:set NEW_RELIC_LICENSE_KEY=<key> -a ${NAME}
	# deis config:set NEW_RELIC_APP_NAME=${NAME} -a ${NAME}
	# deis config:set NEW_RELIC_APDEX=<0.010>

install:
	# go get -v github.com/astaxie/beego
	# go get -v github.com/beego/bee
	go get -v -u github.com/astaxie/beego/orm
	go get -v -u github.com/beego/i18n
	go get -v -u github.com/go-sql-driver/mysql
	# go get -v -u
	# go get -v -u
	# go get -v -u
	# go get -v -u

release:
	@echo "building ${OWNER} ${BIN_NAME} ${VERSION}"
	@echo "GOPATH=${GOPATH}"
	#godep get && \
	# CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -tags netgo -ldflags '-w' -o /app/run main.go
	go build -ldflags "-X main.GitCommit ${GIT_COMMIT}${GIT_DIRTY}" -o dist/run
	# go build -ldflags "-X main.GitCommit ${GIT_COMMIT}${GIT_DIRTY}" -o bin/${BIN_NAME}

build: clean
	@echo "building ${OWNER} ${BIN_NAME} ${VERSION}"
	@go build -o ./${BIN_NAME}

clean:
	@test ! -e ./${BIN_NAME} || rm ./${BIN_NAME}

test:
	go test -v ./...

run: swagger docs
	@echo "...............................................................\n"
	@echo $(PROJECT_NAME)
	@echo documentation API open in browser:
	@echo	"	 http://localhost:8080/swagger/\n"
	@echo ...............................................................
	@bee run watchall true -downdoc=true -gendoc=true

docs:
	@bee generate docs

swagger:
	@test -d ./swagger || (wget https://github.com/beego/swagger/archive/v1.tar.gz && tar -xzf v1.tar.gz && mv swagger-1 swagger && rm v1.tar.gz)


.PHONY: build dist clean test release run install docs swagger create push destroy
