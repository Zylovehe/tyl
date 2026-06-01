# 阶段1：构建项目（使用国内镜像加速，避免拉取失败）
FROM maven:3.8-openjdk-11-slim AS builder

# 设置工作目录
WORKDIR /app

# 先复制 pom.xml，利用 Docker 缓存依赖
COPY pom.xml .

# 下载依赖（缓存层，pom不变就不会重复执行）
RUN mvn dependency:go-offline -B

# 复制源代码
COPY src ./src

# 打包项目（跳过测试，加快构建）
RUN mvn clean package -DskipTests

# 阶段2：运行时（只保留 JRE 和 Jar 包，镜像体积更小）
FROM openjdk:11-jre-slim

WORKDIR /app

# 从构建阶段复制打包好的 Jar 包
COPY --from=builder /app/target/*.jar app.jar

# 暴露端口（Railway 会自动分配，这里仅声明）
EXPOSE 8080

# 启动命令，读取 Railway 分配的 PORT 环境变量
ENTRYPOINT ["java", "-jar", "app.jar", "--server.port=${PORT}"]