@echo off
chcp 65001 >nul
echo ========================================
echo   推送代码到GitHub
echo ========================================
echo.

echo [提示] 本脚本将帮助你推送代码到GitHub
echo.

echo ========================================
echo   步骤1: 在GitHub上创建仓库
echo ========================================
echo.
echo 请访问: https://github.com/new
echo.
echo 填写信息:
echo - Repository name: tyl (或 tongyiling-system)
echo - Description: TongYiLing System Management Backend
echo - 选择 Public (公开仓库)
echo - 不要勾选 "Add a README file"
echo.
echo 点击 "Create repository"
echo.
pause

echo.
echo ========================================
echo   步骤2: 输入你的GitHub用户名
echo ========================================
echo.

set /p github_username="Zylovehe"

if "%github_username%"=="" (
    echo [错误] 用户名不能为空
    pause
    exit /b 1
)

echo.
echo ========================================
echo   步骤3: 配置远程仓库并推送
echo ========================================
echo.

echo [信息] 远程仓库地址: https://github.com/%github_username%/tyl.git
echo.

set /p confirm="确认推送？(y/n): "
if /i not "%confirm%"=="y" (
    echo [取消] 已取消推送
    pause
    exit /b 0
)

echo.
echo [执行] 删除旧的远程仓库配置...
git remote remove origin 2>nul

echo [执行] 添加新的远程仓库...
git remote add origin https://github.com/%github_username%/tyl.git

echo [执行] 确保使用main分支...
git branch -M main

echo [执行] 推送代码到GitHub...
git push -u origin main

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo   ✅ 推送成功！
    echo ========================================
    echo.
    echo 你的代码已成功推送到:
    echo https://github.com/%github_username%/tyl
    echo.
    echo 下一步:
    echo 1. 访问 Render Dashboard
    echo 2. 点击 "New Web Service"
    echo 3. 连接GitHub并选择 "tyl" 仓库
    echo 4. 配置环境变量并部署
    echo.
) else (
    echo.
    echo ========================================
    echo   ❌ 推送失败
    echo ========================================
    echo.
    echo 可能的原因:
    echo 1. GitHub用户名错误
    echo 2. 仓库还未创建
    echo 3. 网络问题
    echo.
    echo 请检查后重试
    echo.
)

pause
