# 🚀 Railway.app 后端部署完整指南

## ✅ 为什么选择Railway？

- **自动检测Java项目** - 无需配置Build/Start命令
- **可视化环境变量管理** - 界面友好
- **快速部署** - 比Render更快
- **$5免费额度** - 足够个人项目使用数月
- **自动HTTPS** - 无需额外配置

---

## 🎯 部署步骤（3步完成）

### 第1步：注册Railway账号

1. 访问：**https://railway.app**
2. 点击 **"Login"** → 选择 **"Sign in with GitHub"**
3. 授权Railway访问你的GitHub
4. 完成注册

---

### 第2步：创建新项目

#### 方式A：从GitHub模板创建（推荐⭐⭐⭐⭐⭐）

1. 登录后，点击 **"New Project"**
2. 选择 **"Deploy from GitHub repo"**
3. 搜索并选择：**`Zylovehe/tyl`**
4. 点击 **"Deploy Now"**

#### 方式B：手动创建

1. 点击 **"New Project"**
2. 选择 **"Empty project"**
3. 点击 **"Add service"** → **"GitHub Repo"**
4. 选择 **`Zylovehe/tyl`**

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

### 第4步：等待自动部署

Railway会自动：
1. 检测 [pom.xml](file://e:\testDemo\tongyiling-project\tyl\pom.xml) 文件
2. 识别为Maven项目
3. 执行 `mvn clean package`
4. 启动应用 `java -jar target/*.jar`

**查看实时日志：**
- 点击 **"Deployments"** 标签
- 查看构建和启动日志
- 等待看到："Started TylSystemApplication in X seconds"

---

### 第5步：获取域名并测试

部署成功后：

1. 点击 **"Settings"** 标签
2. 找到 **"Domains"** 部分
3. 复制生成的域名（如：`https://tyl-production.up.railway.app`）

**测试API：**

```bash
# 替换YOUR_DOMAIN为实际域名
curl -X POST https://YOUR_DOMAIN/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
```

**或使用浏览器控制台：**

```javascript
fetch('https://YOUR_DOMAIN/api/auth/login', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ username: 'admin', password: 'admin123' })
})
.then(r => r.json())
.then(data => console.log('✅ 成功:', data))
.catch(err => console.error(' 错误:', err));
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

---

## 📋 如果没有Aiven数据库

### 快速创建Aiven MySQL（5分钟）

#### 1. 注册Aiven
- 访问：https://aiven.io
- 点击 "Get started for free"
- 注册账号

#### 2. 创建MySQL服务
- Create new service → MySQL
- 选择 **Free plan**（Hobbyist）
- 区域：us-central1（推荐）
- 等待2-3分钟创建完成

#### 3. 获取连接信息
在Aiven控制台 → Overview：
```
Host: tyl-mysql-xxxxx.aivencloud.com
Port: 19068
User: avnadmin
Password: xxxxxxxxxxxx
Database: defaultdb
```

#### 4. 初始化数据库
在Aiven Console的SQL Editor中执行：

**先执行 schema.sql：**
打开本地文件 `src/main/resources/sql/schema.sql`，复制全部内容，在Aiven SQL Editor中执行。

**再执行 data.sql：**
打开本地文件 `src/main/resources/sql/data.sql`，复制全部内容，在Aiven SQL Editor中执行。

---

## 🔍 故障排查

### Q1: Build失败

**原因：** Maven依赖下载失败或代码错误

**解决：**
1. 查看Logs找出具体错误
2. 确认 [pom.xml](file://e:\testDemo\tongyiling-project\tyl\pom.xml) 格式正确
3. 本地运行 `mvn clean package` 确认能构建成功

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

## ✨ Railway优势功能

### 1. 自动SSL证书
- Railway自动为你的域名配置HTTPS
- 无需额外操作

### 2. 自定义域名
- 可以绑定自己的域名
- Settings → Domains → Add Custom Domain

### 3. 环境变量版本控制
- 所有环境变量变更都有历史记录
- 可以轻松回滚

### 4. 实时监控
- 查看CPU、内存使用情况
- 监控请求量和响应时间

### 5. 一键回滚
- 如果新版本有问题
- Deployments → 选择旧版本 → Rollback

---

## 📊 与其他平台对比

| 特性 | Railway | Render | Vercel | Heroku |
|------|---------|--------|--------|--------|
| Java支持 | ✅ 完美 | ✅ 良好 | ❌ 不支持 | ✅ 良好 |
| 自动检测 | ✅ 是 | ⚠️ 有时需要 | N/A | ✅ 是 |
| 免费额度 | $5/月 | 750小时 | ❌ 无免费层 | ❌ 已取消免费层 |
| 部署速度 | ✅ 快 | 中等 | 快 | 慢 |
| 易用性 | ✅ 极简 | 中等 | 简单 | 复杂 |
| 文档质量 | ✅ 优秀 | ✅ 优秀 | ✅ 优秀 | ✅ 优秀 |

**结论：Railway是部署Java后端的最简单选择！**

---

## 🎯 快速开始命令

### 使用Railway CLI（可选）

如果想用命令行部署：

```bash
# 安装Railway CLI
npm install -g @railway/cli

# 登录
railway login

# 初始化项目
cd e:\testDemo\tongyiling-project\tyl
railway init

# 设置环境变量
railway variables set DB_HOST=xxx DB_PORT=19068 ...

# 部署
railway up
```

---

## ✅ 部署检查清单

- [ ] 代码已推送到GitHub (`git push origin main`)
- [ ] Railway账号已注册并连接GitHub
- [ ] 新项目已创建并连接 `Zylovehe/tyl` 仓库
- [ ] 所有环境变量已配置
- [ ] Aiven数据库已创建并初始化
- [ ] 部署成功，看到 "Started TylSystemApplication"
- [ ] API测试通过，返回Token

---

## 🆘 需要帮助？

如果遇到问题：

1. **查看Railway Logs**
   - Deployments → 查看最新部署日志
   - 找出错误信息

2. **检查环境变量**
   - Variables → 确认所有变量已设置
   - 特别检查DB_PASSWORD和JWT_SECRET

3. **本地测试**
   ```bash
   start.bat
   # 本地测试正常后再排查云端问题
   ```

4. **联系支持**
   - Railway Discord: https://discord.gg/railway
   - 提供完整的错误日志

---

**🎉 现在就开始部署吧！只需3步，5分钟内完成！**

1. 注册Railway
2. 连接GitHub仓库
3. 配置环境变量

祝你部署顺利！🚀
