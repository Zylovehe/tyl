@echo off
chcp 65001 >nul
echo ========================================
echo   Railway.app 快速部署向导
echo ========================================
echo.

echo [提示] 本脚本将引导你完成Railway部署
echo.
echo 优势:
echo - 自动检测Java项目（无需配置Build/Start命令）
echo - 可视化环境变量管理
echo - 快速部署（比Render更快）
echo - $5免费额度（足够使用数月）
echo.

pause

echo.
echo ========================================
echo   步骤1: 注册Railway账号
echo ========================================
echo.
echo 请访问: https://railway.app
echo.
echo 操作:
echo 1. 点击 "Login" → "Sign in with GitHub"
echo 2. 授权Railway访问GitHub
echo 3. 完成注册
echo.

set /p step1_done="已完成注册？(y/n): "
if /i not "%step1_done%"=="y" (
    echo [提示] 请先完成注册，然后重新运行此脚本
    pause
    exit /b 0
)

echo.
echo ========================================
echo   步骤2: 创建新项目
echo ========================================
echo.
echo 在Railway Dashboard中:
echo.
echo 1. 点击 "New Project"
echo 2. 选择 "Deploy from GitHub repo"
echo 3. 搜索并选择: Zylovehe/tyl
echo 4. 点击 "Deploy Now"
echo.
echo 注意: Railway会自动检测pom.xml并构建项目
echo.

pause

echo.
echo ========================================
echo   步骤3: 准备Aiven MySQL数据库
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
echo 3. 执行 mvn clean package
echo 4. 启动应用 java -jar target/*.jar
echo.
echo 查看实时日志:
echo - 点击 "Deployments" 标签
echo - 等待看到: "Started TylSystemApplication in X seconds"
echo.

pause

echo.
echo ========================================
echo   步骤6: 获取域名并测试
echo ========================================
echo.
echo 部署成功后:
echo.
echo 1. 点击 "Settings" 标签
echo 2. 找到 "Domains" 部分
echo 3. 复制生成的域名（如: https://tyl-production.up.railway.app）
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
echo 下一步:
echo 1. 记录你的Railway域名
echo 2. 更新前端项目的API地址
echo 3. 测试完整的前后端联调
echo.
echo  详细文档: RAILWAY_DEPLOY.md
echo.
echo 🎉 恭喜！后端已成功部署到Railway！
echo.

pause
