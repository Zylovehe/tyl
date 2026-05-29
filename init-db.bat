@echo off
chcp 65001 >nul
echo ========================================
echo   数据库初始化脚本
echo ========================================
echo.
echo 此脚本将执行以下操作：
echo 1. 创建数据库 tyl_system
echo 2. 创建数据表
echo 3. 插入初始化数据
echo.
echo 请确保MySQL服务正在运行！
echo.

set /p MYSQL_USER="请输入MySQL用户名 (默认root): "
if "%MYSQL_USER%"=="" set MYSQL_USER=root

set /p MYSQL_PASSWORD="请输入MySQL密码 (默认root): "
if "%MYSQL_PASSWORD%"=="" set MYSQL_PASSWORD=root

echo.
echo [提示] 正在连接MySQL并执行SQL脚本...
echo.

echo -- 执行建表脚本 > temp_schema.sql
type src\main\resources\sql\schema.sql >> temp_schema.sql

echo -- 执行初始化数据脚本 > temp_data.sql
type src\main\resources\sql\data.sql >> temp_data.sql

mysql -u%MYSQL_USER% -p%MYSQL_PASSWORD% < temp_schema.sql
if errorlevel 1 (
    echo [错误] 建表脚本执行失败
    del temp_schema.sql
    del temp_data.sql
    pause
    exit /b 1
)

mysql -u%MYSQL_USER% -p%MYSQL_PASSWORD% < temp_data.sql
if errorlevel 1 (
    echo [错误] 初始化数据脚本执行失败
    del temp_schema.sql
    del temp_data.sql
    pause
    exit /b 1
)

del temp_schema.sql
del temp_data.sql

echo.
echo ========================================
echo   数据库初始化成功！
echo ========================================
echo.
echo 默认账号信息：
echo 用户名：admin
echo 密码：admin123
echo.

pause
