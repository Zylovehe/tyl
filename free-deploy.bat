@echo off
chcp 65001 >nul
echo ========================================
echo   TongYiLing - 免费云端部署中心
echo ========================================
echo.
echo     ╔════════════════════════════════╗
echo     ║      免费部署平台选择          ║
echo     ╚════════════════════════════════╝
echo.
echo [1] 🎨 Render.com (推荐⭐⭐⭐⭐⭐)
echo     - 750小时/月完全免费
echo     - 自动HTTPS
echo     - 无需信用卡
echo.
echo [2] 🚂 Railway.app (备选⭐⭐⭐⭐)
echo     - $5信用额度
echo     - 简单易用
echo     - 支持数据库
echo.
echo [3] 📖 查看前端集成指南
echo [4] 🎯 快速测试页面
echo [0] ❌ 退出
echo.

set /p choice="请选择部署方案 (0-4): "

if "%choice%"=="1" goto render
if "%choice%"=="2" goto railway
if "%choice%"=="3" goto frontend-guide
if "%choice%"=="4" goto test-page
if "%choice%"=="0" exit /b 0

echo [错误] 无效的选项
pause
exit /b 1

:render
cls
call deploy-render.bat
goto end

:railway
cls
call deploy-railway.bat
goto end

:frontend-guide
cls
echo.
echo ========================================
echo   前端集成指南
echo ========================================
echo.
echo 请查看文档: FRONTEND_INTEGRATION.md
echo.
echo 主要内容包括：
echo - Vue.js/React配置方法
echo - Axios请求封装
echo - Token认证流程
echo - 跨域问题解决方案
echo - 完整的前后端交互示例
echo.
start "" "FRONTEND_INTEGRATION.md"
pause
goto end

:test-page
cls
echo.
echo ========================================
echo   生成前端测试页面
echo ========================================
echo.

if not exist "test-frontend.html" (
    echo [提示] 正在创建测试页面...
    
    echo ^<!DOCTYPE html^> > test-frontend.html
    echo ^<html lang="zh-CN"^> >> test-frontend.html
    echo ^<head^> >> test-frontend.html
    echo     ^<meta charset="UTF-8"^> >> test-frontend.html
    echo     ^<title^>后端API测试^</title^> >> test-frontend.html
    echo ^</head^> >> test-frontend.html
    echo ^<body^> >> test-frontend.html
    echo     ^<h1^>🚀 后端API测试页面^</h1^> >> test-frontend.html
    echo     ^<p^>请使用浏览器打开此文件进行测试^</p^> >> test-frontend.html
    echo     ^<p^>请在FRONTEND_INTEGRATION.md中获取完整代码^</p^> >> test-frontend.html
    echo ^</body^> >> test-frontend.html
    echo ^</html^> >> test-frontend.html
    
    echo [成功] 测试页面已创建
)

echo.
echo [提示] 请用浏览器打开 test-frontend.html
echo.
start "" "test-frontend.html"
pause
goto end

:end
echo.
echo ========================================
echo   感谢使用免费部署服务
echo ========================================
echo.
