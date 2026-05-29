# 🔍 "Not Found" 问题深度排查指南

## 🎯 问题现象

访问 `https://tyl-backend.onrender.com/api/auth/login` 返回 **404 Not Found**

---

## ✅ 立即执行的诊断步骤

### 运行诊断脚本

```bash
# Windows
diagnose-render.bat
```

脚本会引导你完成5个关键检查点。

---

## 🔍 详细排查清单

### 检查1: Render服务状态

**访问：** https://dashboard.render.com

**确认：**
- ✅ 服务状态是 🟢 **Live**（绿色）
- ❌ 如果是 🟡 Building - 等待部署完成
- ❌ 如果是 🔴 Failed - 查看错误日志

---

### 检查2: 应用启动日志

**在Render控制台查看Logs，寻找：**

#### ✅ 成功标志
```
Started TylSystemApplication in X.XXX seconds
Tomcat started on port(s): 8080 (http) with context path ''
```

#### ❌ 常见错误

**错误1: 数据库连接失败**
```
Caused by: com.mysql.cj.jdbc.exceptions.CommunicationsException
Communications link failure
```
**解决：** 检查Aiven连接信息和环境变量

**错误2: JWT密钥未配置**
```
java.lang.IllegalArgumentException: jwt.secret cannot be null or empty
```
**解决：** 设置JWT_SECRET环境变量

**错误3: Bean创建失败**
```
org.springframework.beans.factory.BeanCreationException
```
**解决：** 查看详细错误堆栈，通常是依赖注入问题

**错误4: 端口占用**
```
Web server failed to start. Port 8080 was already in use.
```
**解决：** Render会自动处理，通常不是问题

---

### 检查3: 环境变量验证

**在Render → Environment确认以下变量：**

```bash
# Aiven数据库配置
DB_HOST = tyl-mysql-xxxxx.aivencloud.com
DB_PORT = 19068
DB_USERNAME = avnadmin
DB_PASSWORD = your_actual_password_here
DB_NAME = defaultdb

# Spring Boot配置
SPRING_PROFILES_ACTIVE = prod
DB_DRIVER = com.mysql.cj.jdbc.Driver

# JWT配置（必须≥32字符）
JWT_SECRET = tylSystemSecretKey2024ProductionStronger!!!
```

**⚠️ 常见错误：**
1. DB_PASSWORD 包含特殊字符未转义
2. JWT_SECRET 长度不足32字符
3. 变量名拼写错误（区分大小写）
4. 前后有空格

---

### 检查4: Aiven数据库状态

**访问：** https://console.aiven.io

**确认：**
1. ✅ MySQL服务状态是 "Running"
2. ✅ 已执行 `schema.sql` 建表
3. ✅ 已执行 `data.sql` 初始化数据
4. ✅ 可以连接到数据库

**测试连接：**
```bash
# 使用本地MySQL客户端测试
mysql -h tyl-mysql-xxxxx.aivencloud.com \
      -P 19068 \
      -u avnadmin \
      -p \
      --ssl-mode=REQUIRED \
      defaultdb

# 登录后执行
SHOW TABLES;
SELECT * FROM sys_user;
```

**应该看到：**
```
+---------------------+
| Tables_in_defaultdb |
+---------------------+
| sys_menu            |
| sys_role            |
| sys_role_menu       |
| sys_user            |
| sys_user_role       |
+---------------------+

+----+----------+----------+-----------+
| id | username | password | real_name |
+----+----------+----------+-----------+
|  1 | admin    | 0192...  | 超级管理员 |
|  2 | user     | ee11...  | 普通用户   |
+----+----------+----------+-----------+
```

---

### 检查5: URL路径测试

**依次测试以下URL：**

```bash
# 测试1: 根路径
curl -I https://tyl-backend.onrender.com/
# 预期: 404 (正常，没有根路径映射)

# 测试2: Actuator健康检查（如果启用）
curl https://tyl-backend.onrender.com/actuator/health
# 预期: 404 或 {"status":"UP"}

# 测试3: 登录接口（完整路径）
curl -X POST https://tyl-backend.onrender.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
# 预期: 200 + JSON响应

# 测试4: 不带/api前缀
curl -X POST https://tyl-backend.onrender.com/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
# 预期: 404 (正常，路径必须有/api)
```

**记录每个URL的：**
- HTTP状态码（200/404/502/503）
- 响应内容
- 响应头

---

## 🛠️ 常见问题及解决方案

### 问题1: 502 Bad Gateway

**原因：** 应用启动失败

**排查步骤：**
1. 查看Render Logs
2. 找到第一个Exception
3. 根据错误信息修复

**常见原因：**
- 数据库连接失败 → 检查Aiven配置
- JWT密钥缺失 → 设置JWT_SECRET
- 端口冲突 → Restart服务

---

### 问题2: 404 Not Found（所有路径）

**原因：** 应用未启动或路径配置错误

**解决：**
1. 确认Logs中有 "Started TylSystemApplication"
2. 检查Controller的 `@RequestMapping`
3. 确认没有Context Path配置

**验证路径配置：**
```java
// AuthController.java
@RestController
@RequestMapping("/api/auth")  // ✅ 正确
public class AuthController {
    
    @PostMapping("/login")    // ✅ 正确
    public Result login(...) {
        ...
    }
}
```

完整路径：`/api/auth/login` ✅

---

### 问题3: 404 Not Found（仅/api路径）

**原因：** 可能是Spring MVC配置问题

**检查：**
1. 确认 `@RestController` 注解存在
2. 确认包扫描路径正确
3. 确认没有其他配置覆盖路径

---

### 问题4: Connection Refused / Timeout

**原因：** 数据库无法连接

**解决：**
1. 检查Aiven服务状态
2. 验证DB_HOST、DB_PORT、DB_PASSWORD
3. 确认URL包含SSL参数：
   ```
   useSSL=true&serverTimezone=UTC&allowPublicKeyRetrieval=true
   ```

---

### 问题5: Access Denied

**原因：** 数据库用户名或密码错误

**解决：**
1. 在Aiven控制台重置密码
2. 更新Render环境变量
3. Restart服务

---

## 📋 完整的验证流程

### 第1步：本地测试（可选）

```bash
# 1. 本地启动应用
start.bat

# 2. 测试本地API
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'

# 预期: 200 + Token
```

如果本地正常，说明代码没问题，是部署配置问题。

---

### 第2步：检查Render部署

```bash
# 1. 查看服务状态
# 访问: https://dashboard.render.com

# 2. 查看日志
# 点击 Web Service → Logs

# 3. 查找关键信息
grep "Started TylSystemApplication"
grep "Tomcat started"
grep "Exception"
grep "Error"
```

---

### 第3步：验证数据库

```bash
# 1. 连接Aiven MySQL
mysql -h HOST -P PORT -u USER -p --ssl-mode=REQUIRED DB_NAME

# 2. 检查表是否存在
SHOW TABLES;

# 3. 检查数据
SELECT COUNT(*) FROM sys_user;
```

---

### 第4步：测试API

```bash
# 使用curl测试
curl -v -X POST https://tyl-backend.onrender.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'

# 或使用Postman
# Method: POST
# URL: https://tyl-backend.onrender.com/api/auth/login
# Headers: Content-Type: application/json
# Body: {"username":"admin","password":"admin123"}
```

---

## 🎯 快速修复方案

### 方案A：重新部署

```bash
# 1. 提交最新代码
git add .
git commit -m "Fix deployment configuration"
git push origin main

# 2. 在Render控制台手动触发部署
# Dashboard → Web Service → Manual Deploy

# 3. 等待部署完成并查看日志
```

---

### 方案B：重启服务

```
在Render控制台：
1. 点击 Web Service
2. 点击右上角 "..." 菜单
3. 选择 "Restart"
4. 等待重启完成
```

---

### 方案C：重建服务（最后手段）

```
在Render控制台：
1. 删除当前Web Service
2. 重新创建：
   - New + → Web Service
   - 连接GitHub仓库
   - 配置环境变量
   - 部署
```

---

## 📞 获取帮助

### 需要提供的信息

如果问题仍未解决，请提供：

1. **Render日志**（最后50行）
   ```
   访问: https://dashboard.render.com → Logs
   复制最近的日志内容
   ```

2. **环境变量截图**
   ```
   Render → Environment → 截图（隐藏敏感信息）
   ```

3. **API测试结果**
   ```bash
   curl -v -X POST https://tyl-backend.onrender.com/api/auth/login \
     -H "Content-Type: application/json" \
     -d '{"username":"admin","password":"admin123"}'
   ```
   复制完整输出（包括请求头和响应头）

4. **Aiven数据库状态**
   ```sql
   SHOW TABLES;
   SELECT COUNT(*) FROM sys_user;
   ```

---

## ✨ 总结

### 最可能的原因（按概率排序）

1. **数据库连接失败** (60%)
   - 检查Aiven配置和环境变量
   
2. **应用启动失败** (25%)
   - 查看Logs找出具体错误
   
3. **环境变量配置错误** (10%)
   - 确认所有必需变量已设置
   
4. **路径配置问题** (5%)
   - 代码中路径配置正确，不太可能

---

**🎯 立即行动：**

1. 运行 `diagnose-render.bat`
2. 查看Render Logs
3. 复制日志内容进行分析
4. 根据错误信息修复

祝你顺利解决问题！🚀
