# 使用官方的Maven镜像构建
FROM maven:3.8-openjdk-11 AS build

WORKDIR /app

# 复制pom.xml并下载依赖
COPY pom.xml .
RUN mvn dependency:go-offline -B

# 复制源代码并构建
COPY src ./src
RUN mvn clean package -DskipTests

# 使用OpenJDK运行时
FROM openjdk:11-jre-slim

WORKDIR /app

# 从构建阶段复制jar包
COPY --from=build /app/target/*.jar app.jar

# 暴露端口
EXPOSE 8080

# 启动应用
ENTRYPOINT ["java", "-jar", "app.jar"]
