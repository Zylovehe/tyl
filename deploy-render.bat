@echo off
chcp 65001 >nul
echo ========================================
echo   Render 一键自动部署向导
echo ========================================
echo.

echo [提示] 本脚本将帮助你完成Render一键部署
echo.
echo 优势:
echo - render.yaml配置文件实现零手动配置
echo - 一键部署链接快速开始
echo - 自动检测Java/Maven项目
echo - 每次推送代码自动重新部署
echo - 750小时/月免费额度
echo.

pause

echo.
echo ========================================
echo   步骤1: 确认代码已推送到GitHub
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
echo [检查] 最新提交...
git log --oneline -3

echo.
set /p push_confirm="是否立即推送最新代码到GitHub？(y/n): "
if /i "%push_confirm%"=="y" (
    echo.
    echo [执行] 添加render.yaml...
    git add render.yaml
    
    echo [执行] 提交更改...
    git commit -m "Add render.yaml for one-click deployment"
    
    echo [执行] 推送到GitHub...
    git push origin main
    
    if %errorlevel% equ 0 (
        echo ✅ 代码推送成功！
    ) else (
        echo ❌ 推送失败，请检查网络连接和GitHub权限
        pause
        exit /b 1
    )
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
echo   步骤3: 一键部署到Render
echo ========================================
echo.

echo [方法1] 使用一键部署链接（推荐）
echo ----------------------------------------
echo.
echo 请访问以下链接开始部署:
echo.
echo https://render.com/deploy?repo=https://github.com/Zylovehe/tyl.git
echo.
echo 操作:
echo 1. 点击上面的链接
echo 2. 登录Render（使用GitHub账号）
echo 3. 填写环境变量（见下方说明）
echo 4. 点击 "Apply"
echo 5. 等待自动部署完成
echo.

echo [方法2] 从Dashboard创建
echo ----------------------------------------
echo.
echo 1. 访问: https://dashboard.render.com
echo 2. 点击 "New +" → "Web Service"
echo 3. 选择 "Connect a repository"
echo 4. 搜索: Zylovehe/tyl
echo 5. 点击 "Connect"
echo 6. Render会自动加载render.yaml配置
echo 7. 填写环境变量
echo 8. 点击 "Create Web Service"
echo.

echo ========================================
echo   环境变量配置说明
echo ========================================
echo.
echo 在Render部署页面，需要手动填写以下变量:
echo.
echo ----------------------------------------
echo # Aiven MySQL数据库配置（从Aiven控制台获取）
echo DB_HOST = tyl-mysql-xxxxx.aivencloud.com
echo DB_PORT = 19068
echo DB_USERNAME = avnadmin
echo DB_PASSWORD = your_actual_password_here
echo DB_NAME = defaultdb
echo.
echo # JWT密钥（必须≥32字符的强随机字符串）
echo JWT_SECRET = tylSystemSecretKey2024ProductionStronger!!!
echo ----------------------------------------
echo.
echo 注意:
echo - SPRING_PROFILES_ACTIVE、DB_DRIVER 已在render.yaml中预设
echo - 只需手动填写数据库信息和JWT密钥
echo.

pause

echo.
echo ========================================
echo   步骤4: 等待自动部署
echo ========================================
echo.
echo Render会自动:
echo 1. 检测到 render.yaml 配置文件
echo 2. 识别为Java/Maven项目
echo 3. 执行 mvn clean package -DskipTests
echo 4. 启动应用 java -jar target/*.jar
echo 5. 进行健康检查
echo.
echo 查看实时日志:
echo - 在Render Dashboard查看部署进度
echo - 等待看到: "Started TylSystemApplication in X seconds"
echo.

pause

echo.
echo ========================================
echo   步骤5: 验证部署并测试API
echo ========================================
echo.

set /p render_domain="请输入你的Render域名（例如: https://xxx.onrender.com）: "

if "%render_domain%"=="" (
    echo [警告] 未输入域名，跳过测试
) else (
    echo.
    echo [测试] 验证API接口...
    echo ----------------------------------------
    echo.
    
    curl -X POST %render_domain%/api/auth/login ^
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
echo 🎉 恭喜！后端已成功部署到Render！
echo.
echo 特性:
echo - ✅ 一键部署（使用render.yaml）
echo - ✅ 自动构建和启动
echo - ✅ 每次推送代码自动重新部署
echo - ✅ 750小时/月免费额度
echo.
echo 下一步:
echo 1. 记录你的Render域名
echo 2. 更新前端项目的API地址
echo 3. 测试完整的前后端联调
echo 4. 每次修改代码后只需 git push，Render会自动部署
echo.
echo 📖 详细文档: RENDER_ONE_CLICK_DEPLOY.md
echo.

pause
