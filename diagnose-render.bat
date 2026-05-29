@echo off
chcp 65001 >nul
echo ========================================
echo   Render部署问题诊断工具
echo ========================================
echo.

echo [提示] 本工具将帮助你诊断 "Not Found" 问题
echo.

echo ========================================
echo   诊断步骤
echo ========================================
echo.

echo 请按顺序检查以下内容：
echo.

echo [1/5] 检查Render服务状态
echo ----------------------------------------
echo 请访问: https://dashboard.render.com
echo 确认你的Web Service状态是 "Live" (绿色)
echo.
set /p status_check="服务状态是否正常？(y/n): "
if /i not "%status_check%"=="y" (
    echo [问题] 服务未正常运行
    echo [解决] 查看Logs找出错误原因
    pause
    exit /b 1
)
echo.

echo [2/5] 检查环境变量
echo ----------------------------------------
echo 在Render控制台确认以下变量已设置：
echo.
echo DB_HOST = tyl-mysql-xxx.aivencloud.com
echo DB_PORT = 19068
echo DB_USERNAME = avnadmin
echo DB_PASSWORD = ********
echo DB_NAME = defaultdb
echo SPRING_PROFILES_ACTIVE = prod
echo DB_DRIVER = com.mysql.cj.jdbc.Driver
echo JWT_SECRET = min_32_chars...
echo.
set /p env_check="环境变量是否已正确配置？(y/n): "
if /i not "%env_check%"=="y" (
    echo [问题] 环境变量配置不完整
    echo [解决] 在Render Environment页面添加缺失的变量
    pause
    exit /b 1
)
echo.

echo [3/5] 检查Aiven数据库
echo ----------------------------------------
echo 请访问: https://console.aiven.io
echo 确认：
echo 1. MySQL服务状态正常
echo 2. 已执行schema.sql和data.sql
echo 3. 可以连接到数据库
echo.
set /p db_check="数据库是否正常？(y/n): "
if /i not "%db_check%"=="y" (
    echo [问题] 数据库未初始化或连接失败
    echo [解决] 在Aiven Console执行SQL脚本
    pause
    exit /b 1
)
echo.

echo [4/5] 测试API端点
echo ----------------------------------------
echo 请在浏览器或Postman中测试：
echo.
echo 测试1: https://tyl-backend.onrender.com/
echo 测试2: https://tyl-backend.onrender.com/api/auth/login
echo.
echo 记录每个URL的响应状态码和内容
echo.
pause

echo.
echo [5/5] 查看Render日志
echo ----------------------------------------
echo 请访问: https://dashboard.render.com
echo 点击你的Web Service → Logs
echo.
echo 查找以下关键信息：
echo ✅ Started TylSystemApplication in X seconds
echo ✅ Tomcat started on port(s): 8080
echo ❌ Exception或Error信息
echo.
echo 请将日志内容复制出来分析
echo.
pause

echo.
echo ========================================
echo   常见问题和解决方案
echo ========================================
echo.

echo 问题1: 502 Bad Gateway
echo 原因: 应用启动失败
echo 解决: 查看Logs，检查数据库连接和环境变量
echo.

echo 问题2: 404 Not Found (所有路径)
echo 原因: 应用未启动或端口错误
echo 解决: 确认应用正常运行在8080端口
echo.

echo 问题3: 404 Not Found (仅/api路径)
echo 原因: 路径映射问题
echo 解决: 检查Controller的@RequestMapping配置
echo.

echo 问题4: Connection refused
echo 原因: 数据库连接失败
echo 解决: 检查Aiven连接信息和SSL配置
echo.

echo ========================================
echo   下一步操作
echo ========================================
echo.
echo 如果以上检查都通过但仍有问题：
echo.
echo 1. 复制Render的完整日志
echo 2. 记录测试URL的响应内容
echo 3. 联系技术支持或查阅文档
echo.
echo 📖 参考文档:
echo    - AIVEN_MYSQL_DEPLOY.md
echo    - NETLIFY_RENDER_DEPLOY.md
echo.

pause
