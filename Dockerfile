# 使用 Railway 构建环境自带的 OpenJDK 镜像
FROM eclipse-temurin:11-jre

WORKDIR /app

# 复制你本地打好的 Jar 包
COPY app/app.jar app.jar

# 暴露端口
EXPOSE 8080

# 启动命令，读取 Railway 分配的 PORT
ENTRYPOINT ["java", "-jar", "app.jar", "--server.port=${PORT}"]