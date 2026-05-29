@echo off
chcp 65001 >nul
echo ========================================
echo   TongYiLing System - 一键部署脚本
echo ========================================
echo.

echo 请选择部署方式：
echo.
echo [1] 本地打包部署（JAR文件）
echo [2] Docker部署
echo [3] Linux服务器部署
echo [4] 仅编译不部署
echo [0] 退出
echo.

set /p choice="请输入选项 (0-4): "

if "%choice%"=="1" goto jar-deploy
if "%choice%"=="2" goto docker-deploy
if "%choice%"=="3" goto linux-deploy
if "%choice%"=="4" goto compile-only
if "%choice%"=="0" exit /b 0

echo [错误] 无效的选项
pause
exit /b 1

:jar-deploy
echo.
echo ========================================
echo   JAR包部署
echo ========================================
echo.
call build-prod.bat
goto end

:docker-deploy
echo.
echo ========================================
echo   Docker部署
echo ========================================
echo.
call docker-deploy.bat
goto end

:linux-deploy
echo.
echo ========================================
echo   Linux服务器部署
echo ========================================
echo.
echo 请在Linux服务器上执行以下命令：
echo.
echo chmod +x build-linux.sh
echo ./build-linux.sh
echo.
echo 然后按照DEPLOYMENT.md文档继续操作
echo.
pause
goto end

:compile-only
echo.
echo ========================================
echo   仅编译项目
echo ========================================
echo.
call mvn clean package -DskipTests
if errorlevel 1 (
    echo [错误] 编译失败
    pause
    exit /b 1
)
echo.
echo [成功] 编译完成
echo JAR文件位置: target\tyl-system-1.0.0.jar
echo.
goto end

:end
echo.
echo ========================================
echo   操作完成
echo ========================================
echo.
pause
