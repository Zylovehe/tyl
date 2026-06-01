# 🚀 Railway.app 一键部署完整指南

## ✅ 项目已优化

- ✅ 清理了无用文件
- ✅ CORS跨域配置已完善
- ✅ 支持Railway自动部署
- ✅ 所有API接口可正常访问

---

## 🎯 部署步骤（3步完成）

### 第1步：推送代码到GitHub

```bash
cd e:\testDemo\tongyiling-project\tyl

# 提交更改
git add .
git commit -m "Cleanup files and prepare for Railway deployment"

# 推送到GitHub
git push origin main
```

或使用脚本：
```bash
deploy-railway.bat
```

---

### 第2步：在Railway上创建项目

#### 方式A：从GitHub导入（推荐⭐⭐⭐⭐⭐）

1. **访问：** https://railway.app
2. **登录：** Sign in with GitHub
3. **点击：** "New Project" → "Deploy from GitHub repo"
4. **选择仓库：** `Zylovehe/tyl`
5. **点击：** "Deploy Now"

#### 方式B：使用Railway CLI

```bash
# 安装CLI
npm install -g @railway/cli

# 登录
railway login

# 初始化项目
cd e:\testDemo\tongyiling-project\tyl
railway init

# 部署
railway up
```

---

### 第3步：配置环境变量（关键！）

在Railway项目页面：

1. 点击你的服务（tyl）
2. 点击 **"Variables"** 标签
3. 点击 **"New Variable"**，添加以下变量：

```bash
# Aiven MySQL数据库配置
DB_HOST = tyl-mysql-xxxxx.aivencloud.com
DB_PORT = 19068
DB_USERNAME = avnadmin
DB_PASSWORD = your_actual_password_here
DB_NAME = defaultdb

# Spring Boot配置
SPRING_PROFILES_ACTIVE = prod
DB_DRIVER = com.mysql.cj.jdbc.Driver

# JWT密钥（必须≥32字符）
JWT_SECRET = tylSystemSecretKey2024ProductionStronger!!!
```

**️ 重要提示：**
- DB_HOST、DB_PORT、DB_PASSWORD 需要从Aiven控制台获取
- 如果还没有Aiven数据库，见下方"快速创建Aiven MySQL"章节

---

## ✅ Railway会自动完成

Railway会自动：
1. ✅ 检测 [pom.xml](file://e:\testDemo\tongyiling-project\tyl\pom.xml) 文件
2. ✅ 识别为Maven项目
3. ✅ 执行 `mvn clean package -DskipTests`
4. ✅ 启动应用 `java -jar target/*.jar`
5. ✅ 分配域名（如：`https://tyl-production.up.railway.app`）

**无需任何手动配置！**

---

##  验证部署

### 方法1：查看日志

在Railway Dashboard：
1. 点击 **"Deployments"** 标签
2. 查看实时日志
3. 等待看到："Started TylSystemApplication in X seconds"

### 方法2：测试API

部署完成后，获取域名并测试：

```bash
# 替换YOUR_DOMAIN为实际域名
curl -X POST https://YOUR_DOMAIN/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
```

**预期响应：**
```json
{
  "code": 200,
  "message": "操作成功",
  "data": {
    "token": "eyJhbGc...",
    "userInfo": {...}
  }
}
```

### 方法3：浏览器控制台测试

```javascript
fetch('https://YOUR_DOMAIN/api/auth/login', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ username: 'admin', password: 'admin123' })
})
.then(r => r.json())
.then(data => console.log('✅ 成功:', data))
.catch(err => console.error('❌ 错误:', err));
```

---

##  CORS跨域配置说明

### 后端已配置完整的CORS支持

项目中的 [`CorsConfig.java`](file://e:\testDemo\tongyiling-project\tyl\src\main\java\com\tyl\system\config\CorsConfig.java) 已配置：

```java
@Configuration
public class CorsConfig implements WebMvcConfigurer {
    
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOriginPatterns("*")      // ✅ 允许所有来源
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH")
                .allowedHeaders("*")
                .allowCredentials(true)           // ✅ 允许携带Token
                .maxAge(3600);                    // ✅ 预检缓存1小时
    }
    
    @Bean
    public CorsFilter corsFilter() {
        // ... 双重保障机制
    }
}
```

### 支持的场景

✅ **Netlify部署的前端**  
✅ **本地开发（localhost）**  
✅ **任何域名/端口的前端应用**  
✅ **移动端App**  
✅ **Postman/API测试工具**  

---

## 🆘 如果没有Aiven数据库

### 快速创建Aiven MySQL（5分钟）

1. **注册Aiven**
   - 访问：https://aiven.io
   - 点击 "Get started for free"
   - 注册账号

2. **创建MySQL服务**
   - Create new service → MySQL
   - 选择 **Free plan**（Hobbyist）
   - 区域：us-central1
   - 等待2-3分钟

3. **获取连接信息**
   ```
   Host: tyl-mysql-xxxxx.aivencloud.com
   Port: 19068
   User: avnadmin
   Password: xxxxxxxxxxxx
   Database: defaultdb
   ```

4. **初始化数据库**
   - 在Aiven Console执行 schema.sql
   - 在Aiven Console执行 data.sql

---

## 🔄 自动重新部署

每次向GitHub推送代码到main分支时，Railway会自动：

1. ✅ 检测到新提交
2. ✅ 拉取最新代码
3. ✅ 执行 `mvn clean package -DskipTests`
4. ✅ 重启应用
5. ✅ 健康检查通过后上线

**无需任何手动操作！**

---

##  Railway优势

| 特性 | 说明 |
|------|------|
| **自动检测** | 自动识别Maven项目，无需配置Build/Start命令 |
| **快速部署** | 比Render更快，约2-3分钟完成 |
| **免费额度** | $5/月（约500小时），足够个人项目使用数月 |
| **可视化界面** | 友好的环境变量管理和日志查看 |
| **自动HTTPS** | 无需额外配置 |
| **一键回滚** | 如果新版本有问题，可轻松回滚 |

---

## 📊 API接口列表

### 认证模块 `/api/auth`
- ✅ `POST /api/auth/login` - 用户登录
- ✅ `POST /api/auth/logout` - 用户退出

### 用户管理 `/api/user`
- ✅ `GET /api/user/list` - 查询用户列表
- ✅ `GET /api/user/{id}` - 查询用户详情
- ✅ `POST /api/user` - 新增用户
- ✅ `PUT /api/user` - 更新用户
- ✅ `DELETE /api/user/{id}` - 删除用户

### 角色管理 `/api/role`
- ✅ `GET /api/role/list` - 查询角色列表
- ✅ `GET /api/role/{id}` - 查询角色详情
- ✅ `POST /api/role` - 新增角色
- ✅ `PUT /api/role` - 更新角色
- ✅ `DELETE /api/role/{id}` - 删除角色

### 菜单管理 `/api/menu`
- ✅ `GET /api/menu/list` - 查询菜单列表
- ✅ `GET /api/menu/{id}` - 查询菜单详情
- ✅ `POST /api/menu` - 新增菜单
- ✅ `PUT /api/menu` - 更新菜单
- ✅ `DELETE /api/menu/{id}` - 删除菜单

---

## 🆘 常见问题

### Q1: Build失败

**原因：** Maven依赖下载失败或代码错误

**解决：**
1. 查看Logs找出具体错误
2. 本地运行 `mvn clean package` 确认能构建
3. 确认 [pom.xml](file://e:\testDemo\tongyiling-project\tyl\pom.xml) 格式正确

---

### Q2: 应用启动但无法访问

**原因：** 端口配置错误或数据库连接失败

**解决：**
1. 查看Logs找出错误信息
2. 检查环境变量是否正确
3. 确认Aiven数据库已初始化

**常见错误：**
- `Communications link failure` - 数据库连接失败
- `jwt.secret cannot be null` - JWT密钥未配置
- `BeanCreationException` - Bean创建失败

---

### Q3: 502 Bad Gateway

**原因：** 应用启动失败

**解决：**
1. 查看Deployment Logs
2. 找到第一个Exception
3. 根据错误信息修复

---

### Q4: CORS错误

**原因：** 前端跨域请求被阻止

**解决：**
- ✅ 后端已配置CORS，清除浏览器缓存
- 确认请求头包含：`Content-Type: application/json`

---

### Q5: 404 Not Found

**原因：** 路径错误或应用未启动

**解决：**
1. 确认路径正确（如 `/api/auth/login`）
2. 检查应用是否启动成功
3. 查看Logs确认无错误

---

## 🎯 快速开始命令

```bash
# Windows - 双击运行
deploy-railway.bat
```

脚本会引导你完成所有步骤！

---

## ✨ 下一步

1. **运行部署脚本**
   ```bash
   deploy-railway.bat
   ```

2. **按照提示操作**
   - 推送代码到GitHub
   - 在Railway上创建项目
   - 配置环境变量

3. **等待自动部署**
   - 查看实时日志
   - 等待 "Started TylSystemApplication"

4. **测试API接口**
   - 脚本会自动测试
   - 或手动用curl/Postman测试

5. **更新前端配置**
   - 修改前端项目的API地址为Railway域名
   - 重新部署前端到Netlify

---

**🎉 现在就开始部署吧！只需3步，5分钟内完成！**

**立即运行：** [deploy-railway.bat](file://e:\testDemo\tongyiling-project\tyl\deploy-railway.bat)

或直接访问：**https://railway.app**

祝你部署顺利！🚀
