#  Render 一键自动部署完整指南

## ✅ 优势

- **一键部署** - 点击链接即可开始部署
- **自动检测** - Render自动识别Java/Maven项目
- **自动构建** - 每次推送代码自动重新部署
- **零配置** - 使用render.yaml配置文件
- **免费额度** - 750小时/月（约31天连续运行）

---

##  部署步骤（2步完成）

### 第1步：推送代码到GitHub

确保最新代码已推送（包含render.yaml）：

```bash
cd e:\testDemo\tongyiling-project\tyl

# 添加并提交render.yaml
git add render.yaml
git commit -m "Add render.yaml for one-click deployment"

# 推送到GitHub
git push origin main
```

或使用脚本：

```bash
# Windows
deploy-render.bat
```

---

### 第2步：一键部署到Render

#### 方式A：使用一键部署按钮（推荐⭐⭐⭐⭐⭐）

1. **访问一键部署页面：**
   ```
   https://render.com/deploy?repo=https://github.com/Zylovehe/tyl.git
   ```

2. **登录Render**（如果未登录）
   - 使用GitHub账号登录
   - 授权Render访问

3. **配置服务**
   - **Service Name**: `tyl-backend`（或自定义）
   - **Branch**: [main](file://e:\testDemo\tongyiling-project\tyl\src\main\java\com\tyl\system\TylSystemApplication.java#L11-L13)
   - **Region**: Ohio (US East)

4. **填写环境变量**（关键！）

   在"Environment Variables"部分，点击 **"Add Environment Variable"**，添加：

   ```bash
   # Aiven MySQL数据库配置
   DB_HOST = tyl-mysql-xxxxx.aivencloud.com
   DB_PORT = 19068
   DB_USERNAME = avnadmin
   DB_PASSWORD = your_actual_password_here
   DB_NAME = defaultdb

   # JWT密钥（必须≥32字符）
   JWT_SECRET = tylSystemSecretKey2024ProductionStronger!!!
   ```

   **️ 注意：**
   - SPRING_PROFILES_ACTIVE、DB_DRIVER 已在render.yaml中预设
   - 只需手动填写数据库信息和JWT密钥

5. **点击 "Apply"**

6. **等待自动部署**
   - Render会自动构建和部署
   - 查看实时日志
   - 等待看到："Started TylSystemApplication in X seconds"

---

#### 方式B：从Dashboard创建

1. **访问：** https://dashboard.render.com
2. **点击：** "New +" → "Web Service"
3. **选择：** "Connect a repository"
4. **搜索：** `Zylovehe/tyl`
5. **点击：** "Connect"
6. **Render会自动检测到render.yaml并加载配置**
7. **填写环境变量**（同方式A）
8. **点击：** "Create Web Service"

---

## 🔍 如果没有Aiven数据库

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

## ✅ 验证部署

### 方法1：自动测试

部署完成后，Render会显示域名（如：`https://tyl-backend.onrender.com`）

**测试API：**

```bash
curl -X POST https://tyl-backend.onrender.com/api/auth/login \
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
fetch('https://tyl-backend.onrender.com/api/auth/login', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ username: 'admin', password: 'admin123' })
})
.then(r => r.json())
.then(data => console.log('✅ 成功:', data))
.catch(err => console.error('❌ 错误:', err));
```

---

## 🔄 自动重新部署

### 触发条件

每次向GitHub推送代码到main分支时，Render会自动：

1. 检测到新提交
2. 拉取最新代码
3. 执行 `mvn clean package -DskipTests`
4. 重启应用
5. 健康检查通过后上线

### 查看部署历史

1. 访问：https://dashboard.render.com
2. 点击你的Web Service
3. 点击 **"Deployments"** 标签
4. 查看所有部署记录和日志

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

### Q5: 环境变量未生效

**原因：** 变量名拼写错误或值不正确

**解决：**
1. 检查变量名是否完全匹配（区分大小写）
2. 确认DB_PASSWORD没有前后空格
3. 确认JWT_SECRET长度≥32字符
4. 重启服务使新变量生效

---

## ✨ render.yaml 配置说明

```yaml
services:
  - type: web                    # 服务类型：Web应用
    name: tyl-backend            # 服务名称
    env: java                    # 运行环境：Java
    repo: https://github.com/Zylovehe/tyl.git  # GitHub仓库
    branch: main                 # 部署分支
    buildCommand: mvn clean package -DskipTests  # 构建命令
    startCommand: java -jar target/*.jar         # 启动命令
    envVars:                     # 环境变量
      - key: DB_HOST             # 数据库主机
        sync: false              # 需要手动填写
      - key: DB_PORT             # 数据库端口
        sync: false
      - key: DB_USERNAME         # 数据库用户名
        sync: false
      - key: DB_PASSWORD         # 数据库密码
        sync: false
      - key: DB_NAME             # 数据库名称
        sync: false
      - key: SPRING_PROFILES_ACTIVE
        value: prod              # 预设值：生产环境
      - key: DB_DRIVER
        value: com.mysql.cj.jdbc.Driver  # 预设值：MySQL驱动
      - key: JWT_SECRET          # JWT密钥
        sync: false              # 需要手动填写
    healthCheckPath: /api/auth/login  # 健康检查路径
    autoDeploy: true             # 启用自动部署
```

---

## 📋 部署检查清单

- [ ] 代码已推送到GitHub (`git push origin main`)
- [ ] [render.yaml](file://e:\testDemo\tongyiling-project\tyl\render.yaml) 文件已提交
- [ ] Railway/Railway账号已注册
- [ ] 通过一键部署链接或Dashboard创建服务
- [ ] 所有环境变量已配置（特别是数据库和JWT）
- [ ] Aiven数据库已创建并初始化
- [ ] 部署成功，看到 "Started TylSystemApplication"
- [ ] API测试通过，返回Token

---

## 🎯 快速开始命令

### 一键部署链接

直接访问以下链接开始部署：

```
https://render.com/deploy?repo=https://github.com/Zylovehe/tyl.git
```

### 本地推送代码

```bash
cd e:\testDemo\tongyiling-project\tyl

# 提交render.yaml
git add render.yaml
git commit -m "Add render.yaml for automatic deployment"

# 推送到GitHub
git push origin main
```

---

## 🆘 需要帮助？

如果遇到问题：

1. **查看Render Logs**
   - Dashboard → Web Service → Deployments
   - 查看最新部署日志
   - 找出错误信息

2. **检查环境变量**
   - Dashboard → Web Service → Environment
   - 确认所有变量已设置
   - 特别检查DB_PASSWORD和JWT_SECRET

3. **本地测试**
   ```bash
   start.bat
   # 本地测试正常后再排查云端问题
   ```

4. **联系支持**
   - Render Discord: https://discord.gg/render
   - 提供完整的错误日志

---

**🎉 现在就开始一键部署吧！**

1. 推送代码到GitHub
2. 访问一键部署链接
3. 填写环境变量
4. 等待自动部署完成

祝你部署顺利！🚀
