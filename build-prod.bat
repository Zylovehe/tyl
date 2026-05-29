@echo off
chcp 65001 >nul
echo ========================================
echo   TongYiLing System - 生产环境部署脚本
echo ========================================
echo.

echo [步骤1] 清理之前的构建...
call mvn clean
if errorlevel 1 (
    echo [错误] 清理失败
    pause
    exit /b 1
)
echo [成功] 清理完成
echo.

echo [步骤2] 编译项目（跳过测试）...
call mvn package -DskipTests
if errorlevel 1 (
    echo [错误] 编译失败
    pause
    exit /b 1
)
echo [成功] 编译完成
echo.

echo [步骤3] 检查target目录...
if not exist "target\tyl-system-1.0.0.jar" (
    echo [错误] 找不到生成的JAR文件: target\tyl-system-1.0.0.jar
    pause
    exit /b 1
)
echo [成功] JAR文件已生成
echo.

echo [步骤4] 创建部署目录...
if not exist "deploy" mkdir deploy
copy /Y "target\tyl-system-1.0.0.jar" "deploy\tyl-system.jar"
copy /Y "src\main\resources\application-prod.yml" "deploy\application-prod.yml"
echo [成功] 部署文件已复制到deploy目录
echo.

echo ========================================
echo   打包完成！
echo ========================================
echo.
echo 部署文件位置: deploy\
echo   - tyl-system.jar (应用主程序)
echo   - application-prod.yml (生产配置)
echo.
echo 下一步操作:
echo 1. 将deploy目录上传到服务器
echo 2. 在服务器上运行 run-deploy.bat
echo 3. 或使用命令: java -jar tyl-system.jar --spring.profiles.active=prod
echo.

pause
