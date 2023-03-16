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
# COPY 宿主机目录 镜像目录
COPY . .

# 编译go项目
RUN go build -o app .

FROM scratch

WORKDIR /dist

# 从阶段镜像builder中拷贝文件
# builder镜像中的 /build/app 拷贝到 /dist 中
COPY --from=builder /build/app .

# 把 /build/public 文件夹中的内容拷贝到 ./public 中
# Note: The directory itself is not copied, just its contents.
COPY --from=builder /build/public ./public

# 最终 /dist目录 下有：app文件和public目录。

EXPOSE 8088

# CMD [ "/dist/app" ]

ENTRYPOINT [ "/dist/app" ]


# 参考
# https://www.liwenzhou.com/posts/Go/deploy-in-docker/
# https://blog.csdn.net/inthat/article/details/124060033