# 选择内置go的基础镜像
FROM golang:alpine AS builder

# 为镜像设置必要的环境变量
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 \
    GOPROXY=https://goproxy.cn,direct

# 进入到工作目录
WORKDIR /build

# COPY source dest
# 文件和目录都拷贝到了目标目录中
# COPY 宿主机目录 镜像目录
COPY . .

# 编译go项目。编译过程放在Dockerfile中更清晰，而不是放在Makefile中，个人认为。
# 生成的 goapp 在 /build下，即 /build/goapp
# main包在./app中，编译时要指定main包所在的路径
RUN go build -o goapp ./app

FROM scratch

WORKDIR /dist

# 从阶段镜像builder中拷贝文件
# builder镜像中的 /build/goapp 拷贝到 /dist 中
COPY --from=builder /build/goapp .

# 把 /build/public 文件夹中的内容拷贝到 ./public 中
# Note: The directory itself is not copied, just its contents.
COPY --from=builder /build/public ./public

# 最终 /dist目录 下有：app文件和public目录。

EXPOSE 8088

# CMD [ "/dist/goapp" ]

ENTRYPOINT [ "/dist/goapp" ]


# 参考
# https://www.liwenzhou.com/posts/Go/deploy-in-docker/
# https://blog.csdn.net/inthat/article/details/124060033