# 第一阶段：构建（使用阿里云镜像加速拉取 Maven+JDK）
FROM registry.aliyuncs.com/library/maven:3.8-openjdk-11 AS builder

WORKDIR /app

# 先复制 pom.xml，利用 Docker 缓存依赖
COPY pom.xml .
RUN mvn dependency:go-offline -B

# 复制源代码并打包
COPY src ./src
RUN mvn clean package -DskipTests

# 第二阶段：运行（使用轻量的 JRE 镜像）
FROM registry.aliyuncs.com/library/openjdk:11-jre-slim

WORKDIR /app

# 从构建阶段复制打包好的 Jar 包
COPY --from=builder /app/target/*.jar app.jar

# 暴露端口（仅声明）
EXPOSE 8080

# 启动命令，读取 Railway 分配的 PORT 环境变量
ENTRYPOINT ["java", "-jar", "app.jar", "--server.port=${PORT}"]