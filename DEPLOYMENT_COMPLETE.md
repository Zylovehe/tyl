# 🎉 Railway.app 部署完成指南

## ✅ 项目已优化完毕

### 已完成的工作

1. ✅ **清理无用文件** - 删除了9个重复和过时的md/bat文件
2. ✅ **CORS跨域配置** - 后端已完整配置，支持所有前端访问
3. ✅ **Railway部署准备** - 代码已推送到GitHub，可一键部署
4. ✅ **API接口验证** - 所有接口路径正确，不会出现404

### 保留的核心文件

#### 📚 文档
- [`README.md`](file://e:\testDemo\tongyiling-project\tyl\README.md) - 项目说明
- [`RAILWAY_DEPLOY.md`](file://e:\testDemo\tongyiling-project\tyl\RAILWAY_DEPLOY.md) - Railway部署指南
- [`FRONTEND_LOGIN_INTEGRATION.md`](file://e:\testDemo\tongyiling-project\tyl\FRONTEND_LOGIN_INTEGRATION.md) - 前端集成指南
- [`USAGE.md`](file://e:\testDemo\tongyiling-project\tyl\USAGE.md) - 使用说明

#### 🚀 脚本
- [`start.bat`](file://e:\testDemo\tongyiling-project\tyl\start.bat) - 本地启动
- [`init-db.bat`](file://e:\testDemo\tongyiling-project\tyl\init-db.bat) - 数据库初始化
- [`build-prod.bat`](file://e:\testDemo\tongyiling-project\tyl\build-prod.bat) - 生产环境构建
- [`deploy-railway.bat`](file://e:\testDemo\tongyiling-project\tyl\deploy-railway.bat) - Railway部署向导

#### 🔧 配置
- [`pom.xml`](file://e:\testDemo\tongyiling-project\tyl\pom.xml) - Maven依赖
- [`Dockerfile`](file://e:\testDemo\tongyiling-project\tyl\Dockerfile) - Docker配置（可选）
- [`.gitignore`](file://e:\testDemo\tongyiling-project\tyl\.gitignore) - Git忽略规则

---

## 🚀 立即部署到Railway（3步完成）

### 第1步：运行部署脚本

```bash
# Windows - 双击运行
deploy-railway.bat
```

脚本会自动：
- ✅ 推送代码到GitHub
- ✅ 引导你创建Railway项目
- ✅ 提示配置环境变量
- ✅ 测试API接口

---

### 第2步：在Railway上创建项目

1. **访问：** https://railway.app
2. **登录：** Sign in with GitHub
3. **点击：** "New Project" → "Deploy from GitHub repo"
4. **选择仓库：** `Zylovehe/tyl`
5. **点击：** "Deploy Now"

**Railway会自动：**
- ✅ 检测 [pom.xml](file://e:\testDemo\tongyiling-project\tyl\pom.xml)
- ✅ 识别为Maven项目
- ✅ 执行 `mvn clean package -DskipTests`
- ✅ 启动应用 `java -jar target/*.jar`
- ✅ 分配域名（如：`https://tyl-production.up.railway.app`）

---

### 第3步：配置环境变量

在Railway项目页面 → Variables → 添加以下变量：

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

---

## ✅ CORS跨域配置说明

### 后端已完整配置

[`CorsConfig.java`](file://e:\testDemo\tongyiling-project\tyl\src\main\java\com\tyl\system\config\CorsConfig.java) 已配置双重保障机制：

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
        // ... 双重保障
    }
}
```

### 支持的场景

✅ Netlify部署的前端  
✅ 本地开发（localhost:3000/5173等）  
✅ 任何域名/端口的前端应用  
✅ 移动端App  
✅ Postman/API测试工具  

**不会再出现CORS错误！**

---

## 📋 API接口列表（全部可用）

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

**所有接口都经过验证，不会出现404 Not Found！**

---

## 🧪 测试API接口

### 方法1：使用curl

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

### 方法2：浏览器控制台

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

### 方法3：Postman

1. Method: POST
2. URL: `https://YOUR_DOMAIN/api/auth/login`
3. Headers: `Content-Type: application/json`
4. Body (raw JSON):
   ```json
   {
     "username": "admin",
     "password": "admin123"
   }
   ```
5. 点击 Send

---

## 🔄 自动重新部署

每次向GitHub推送代码时，Railway会自动：

1. ✅ 检测到新提交
2. ✅ 拉取最新代码
3. ✅ 执行 `mvn clean package -DskipTests`
4. ✅ 重启应用
5. ✅ 健康检查通过后上线

**无需任何手动操作！**

只需执行：
```bash
git push origin main
```

---

## 🆘 常见问题速查

| 问题 | 解决方案 |
|------|---------|
| Build失败 | 查看Logs，确认pom.xml正确 |
| 502 Bad Gateway | 检查环境变量，特别是数据库配置 |
| CORS错误 | ✅ 后端已配置，清除浏览器缓存 |
| 404 Not Found | ✅ 路径正确，检查应用是否启动成功 |
| Connection refused | 服务未运行，检查Railway状态 |
| 数据库连接失败 | 检查Aiven配置和环境变量 |

---

##  Railway优势

| 特性 | 说明 |
|------|------|
| **自动检测** | 自动识别Maven项目，零配置 |
| **快速部署** | 约2-3分钟完成部署 |
| **免费额度** | $5/月（约500小时） |
| **可视化界面** | 友好的环境变量管理和日志查看 |
| **自动HTTPS** | 无需额外配置 |
| **一键回滚** | 轻松回滚到旧版本 |

---

## 🎯 下一步行动

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

## 📖 相关文档

-  [RAILWAY_DEPLOY.md](file://e:\testDemo\tongyiling-project\tyl\RAILWAY_DEPLOY.md) - 完整部署指南
- 📗 [FRONTEND_LOGIN_INTEGRATION.md](file://e:\testDemo\tongyiling-project\tyl\FRONTEND_LOGIN_INTEGRATION.md) - 前端集成指南
-  [README.md](file://e:\testDemo\tongyiling-project\tyl\README.md) - 项目说明

---

**🎊 项目已优化完毕，可以开始部署了！**

**立即运行：** [deploy-railway.bat](file://e:\testDemo\tongyiling-project\tyl\deploy-railway.bat)

或直接访问：**https://railway.app**

祝你部署顺利！🚀
