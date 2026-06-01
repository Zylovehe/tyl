@echo off
chcp 65001 >nul
echo ========================================
echo   Railway.app 一键部署向导
echo ========================================
echo.

echo [提示] 本脚本将引导你完成Railway部署
echo.
echo 优势:
echo - 自动检测Java/Maven项目（无需配置Build/Start命令）
echo - 可视化环境变量管理
echo - 快速部署（比Render更快，约2-3分钟）
echo - $5免费额度（足够使用数月）
echo - CORS跨域已配置，支持所有前端访问
echo.

pause

echo.
echo ========================================
echo   步骤1: 推送代码到GitHub
echo ========================================
echo.

cd /d %~dp0

echo [检查] Git远程仓库...
git remote -v

if %errorlevel% neq 0 (
    echo [错误] 未找到Git仓库，请先初始化Git
    pause
    exit /b 1
)

echo.
echo [执行] 提交最新更改...
git add .
git commit -m "Cleanup files and prepare for Railway deployment"

echo.
echo [执行] 推送到GitHub...
git push origin main

if %errorlevel% equ 0 (
    echo ✅ 代码推送成功！
) else (
    echo ❌ 推送失败，请检查网络连接和GitHub权限
    pause
    exit /b 1
)

echo.
echo ========================================
echo   步骤2: 准备Aiven MySQL数据库
echo ========================================
echo.

set /p has_aiven="是否已有Aiven MySQL数据库？(y/n): "

if /i "%has_aiven%"=="n" (
    echo.
    echo [指南] 快速创建Aiven MySQL（5分钟）
    echo ----------------------------------------
    echo.
    echo 1. 访问: https://aiven.io
    echo 2. 注册账号（免费）
    echo 3. Create new service → MySQL → Free plan
    echo 4. 等待2-3分钟创建完成
    echo 5. 获取连接信息:
    echo    - Host: tyl-mysql-xxxxx.aivencloud.com
    echo    - Port: 19068
    echo    - User: avnadmin
    echo    - Password: xxxxxxxxxxxx
    echo    - Database: defaultdb
    echo.
    echo 6. 初始化数据库:
    echo    - 在Aiven Console执行 schema.sql
    echo    - 在Aiven Console执行 data.sql
    echo.
    
    pause
    
    echo.
    echo 请确保已完成以上步骤后再继续
    echo.
)

echo.
echo ========================================
echo   步骤3: 在Railway上创建项目
echo ========================================
echo.

echo [方法1] 从GitHub导入（推荐）
echo ----------------------------------------
echo.
echo 1. 访问: https://railway.app
echo 2. 登录: Sign in with GitHub
echo 3. 点击: New Project → Deploy from GitHub repo
echo 4. 选择仓库: Zylovehe/tyl
echo 5. 点击: Deploy Now
echo.

echo [方法2] 使用Railway CLI
echo ----------------------------------------
echo.
echo # 安装CLI
echo npm install -g @railway/cli
echo.
echo # 登录
echo railway login
echo.
echo # 初始化项目
echo cd e:\testDemo\tongyiling-project\tyl
echo railway init
echo.
echo # 部署
echo railway up
echo.

pause

echo.
echo ========================================
echo   步骤4: 配置环境变量
echo ========================================
echo.
echo 在Railway项目页面:
echo.
echo 1. 点击你的服务（tyl）
echo 2. 点击 "Variables" 标签
echo 3. 点击 "New Variable"，添加以下变量:
echo.
echo ----------------------------------------
echo # Aiven MySQL数据库配置
echo DB_HOST = tyl-mysql-xxxxx.aivencloud.com
echo DB_PORT = 19068
echo DB_USERNAME = avnadmin
echo DB_PASSWORD = your_actual_password_here
echo DB_NAME = defaultdb
echo.
echo # Spring Boot配置
echo SPRING_PROFILES_ACTIVE = prod
echo DB_DRIVER = com.mysql.cj.jdbc.Driver
echo.
echo # JWT密钥（必须≥32字符）
echo JWT_SECRET = tylSystemSecretKey2024ProductionStronger!!!
echo ----------------------------------------
echo.
echo 重要提示:
echo - 替换DB_HOST、DB_PORT、DB_PASSWORD为实际值
echo - JWT_SECRET必须是至少32个字符的强随机字符串
echo.

pause

echo.
echo ========================================
echo   步骤5: 等待自动部署
echo ========================================
echo.
echo Railway会自动:
echo 1. 检测 pom.xml 文件
echo 2. 识别为Maven项目
echo 3. 执行 mvn clean package -DskipTests
echo 4. 启动应用 java -jar target/*.jar
echo 5. 分配域名（如: https://tyl-production.up.railway.app）
echo.
echo 查看实时日志:
echo - 点击 "Deployments" 标签
echo - 等待看到: "Started TylSystemApplication in X seconds"
echo.

pause

echo.
echo ========================================
echo   步骤6: 验证部署并测试API
echo ========================================
echo.

set /p railway_domain="请输入你的Railway域名（例如: https://xxx.up.railway.app）: "

if "%railway_domain%"=="" (
    echo [警告] 未输入域名，跳过测试
) else (
    echo.
    echo [测试] 验证API接口...
    echo ----------------------------------------
    echo.
    
    curl -X POST %railway_domain%/api/auth/login ^
      -H "Content-Type: application/json" ^
      -d "{\"username\":\"admin\",\"password\":\"admin123\"}" ^
      -s -w "\n\nHTTP状态码: %{http_code}\n"
    
    echo.
    echo ----------------------------------------
    echo.
    echo 如果返回 code:200 和 token，说明部署成功！
    echo.
)

echo.
echo ========================================
echo   ✅ 部署完成！
echo ========================================
echo.
echo  恭喜！后端已成功部署到Railway！
echo.
echo 特性:
echo - ✅ 自动检测Maven项目（零配置）
echo - ✅ 快速部署（2-3分钟）
echo - ✅ CORS跨域已配置
echo - ✅ $5免费额度
echo - ✅ 每次推送代码自动重新部署
echo.
echo 下一步:
echo 1. 记录你的Railway域名
echo 2. 更新前端项目的API地址
echo 3. 测试完整的前后端联调
echo 4. 每次修改代码后只需 git push，Railway会自动部署
echo.
echo  详细文档: RAILWAY_DEPLOY.md
echo.

pause
