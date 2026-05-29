@echo off
echo ========================================
echo   TongYiLing System - 启动脚本
echo ========================================
echo.

echo [1] 正在检查Maven环境...
mvn -version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未找到Maven，请先安装Maven并配置环境变量
    pause
    exit /b 1
)
echo [成功] Maven环境正常
echo.

echo [2] 正在编译项目...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo [错误] 项目编译失败
    pause
    exit /b 1
)
echo [成功] 项目编译完成
echo.

echo [3] 正在启动应用...
echo 提示: 请确保MySQL数据库已启动，并已执行初始化SQL脚本
echo 初始化SQL脚本位置: src\main\resources\sql\schema.sql
echo 初始化数据脚本位置: src\main\resources\sql\data.sql
echo.

java -jar target\tyl-system-1.0.0.jar

pause
