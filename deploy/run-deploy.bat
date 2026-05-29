@echo off
chcp 65001 >nul
echo ========================================
echo   TongYiLing System - 服务器运行脚本
echo ========================================
echo.

echo [提示] 正在启动应用（生产环境）...
echo [提示] 使用配置文件: application-prod.yml
echo [提示] 日志文件位置: logs/tyl-system.log
echo.

java -jar tyl-system.jar --spring.profiles.active=prod

pause
