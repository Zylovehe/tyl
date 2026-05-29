# 🚀 快速使用指南

## 📋 前置条件

在开始之前，请确保您的系统已安装：

- ✅ JDK 1.8 或更高版本
- ✅ Maven 3.6 或更高版本
- ✅ MySQL 5.7 或更高版本

## 🎯 三步快速启动

### 第一步：初始化数据库

双击运行 `init-db.bat` 文件，按提示输入MySQL用户名和密码。

或者手动执行：
```bash
mysql -u root -p < src/main/resources/sql/schema.sql
mysql -u root -p < src/main/resources/sql/data.sql
```

### 第二步：修改配置

打开 `src/main/resources/application.yml`，修改数据库连接信息：

```yaml
spring:
  datasource:
    username: root      # 改为你的MySQL用户名
    password: root      # 改为你的MySQL密码
```

### 第三步：启动项目

双击运行 `start.bat` 文件，等待项目启动成功。

或者使用命令行：
```bash
mvn spring-boot:run
```

## ✨ 测试登录

项目启动成功后，使用以下信息登录：

**默认账号：**
- 用户名：`admin`
- 密码：`admin123`

**测试接口：**
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"admin\",\"password\":\"admin123\"}"
```

## 📚 主要功能

### 1️⃣ 认证功能
- ✅ 用户登录
- ✅ JWT Token认证
- ✅ 用户退出

### 2️⃣ 用户管理
- ✅ 查询用户列表
- ✅ 新增用户
- ✅ 修改用户
- ✅ 删除用户

### 3️⃣ 角色管理
- ✅ 查询角色列表
- ✅ 新增角色
- ✅ 修改角色
- ✅ 删除角色

### 4️⃣ 菜单管理
- ✅ 查询菜单列表（按排序）
- ✅ 新增菜单
- ✅ 修改菜单
- ✅ 删除菜单

## 🔗 API接口一览

| 模块 | 方法 | 路径 | 说明 |
|------|------|------|------|
| 认证 | POST | /api/auth/login | 用户登录 |
| 认证 | POST | /api/auth/logout | 用户退出 |
| 用户 | GET | /api/user/list | 查询所有用户 |
| 用户 | GET | /api/user/{id} | 查询单个用户 |
| 用户 | POST | /api/user | 新增用户 |
| 用户 | PUT | /api/user | 更新用户 |
| 用户 | DELETE | /api/user/{id} | 删除用户 |
| 角色 | GET | /api/role/list | 查询所有角色 |
| 角色 | GET | /api/role/{id} | 查询单个角色 |
| 角色 | POST | /api/role | 新增角色 |
| 角色 | PUT | /api/role | 更新角色 |
| 角色 | DELETE | /api/role/{id} | 删除角色 |
| 菜单 | GET | /api/menu/list | 查询所有菜单 |
| 菜单 | GET | /api/menu/{id} | 查询单个菜单 |
| 菜单 | POST | /api/menu | 新增菜单 |
| 菜单 | PUT | /api/menu | 更新菜单 |
| 菜单 | DELETE | /api/menu/{id} | 删除菜单 |

## 🛠️ 技术栈

- **核心框架**: Spring Boot 2.7.14
- **持久层框架**: MyBatis Plus 3.5.3.1
- **数据库**: MySQL
- **安全认证**: JWT (JSON Web Token)
- **JSON处理**: FastJSON
- **代码简化**: Lombok

## 📖 文档导航

- 📘 [README.md](README.md) - 完整的项目说明和API文档
- 📗 [QUICK_START.md](QUICK_START.md) - 详细的启动教程
- 📙 [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - 项目完成清单
- 📝 [API_TEST.http](API_TEST.http) - API接口测试文件

## ❓ 常见问题

### Q1: 端口被占用怎么办？
修改 `application.yml` 中的端口号：
```yaml
server:
  port: 8081  # 改为其他可用端口
```

### Q2: 数据库连接失败？
检查以下几点：
- MySQL服务是否启动
- 数据库 `tyl_system` 是否已创建
- 用户名和密码是否正确

### Q3: Maven下载依赖很慢？
可以配置国内镜像源，在 `pom.xml` 中添加阿里云镜像。

### Q4: 如何重置admin密码？
在数据库中执行：
```sql
UPDATE sys_user 
SET password = '0192023a7bbd73250516f069df18b500' 
WHERE username = 'admin';
```
这会将密码重置为 `admin123`

## 🎁 项目特色

1. **开箱即用** - 完整的CRUD功能，无需额外开发
2. **标准规范** - 遵循RESTful规范，接口清晰统一
3. **安全可靠** - JWT认证 + MD5密码加密
4. **易于扩展** - 清晰的分层架构，便于二次开发
5. **文档完善** - 详细的使用文档和API说明

## 💡 下一步建议

1. ⭐ 集成Swagger生成在线API文档
2. ⭐ 添加JWT拦截器实现权限验证
3. ⭐ 使用Redis缓存提升性能
4. ⭐ 实现更细粒度的权限控制
5. ⭐ 添加操作日志记录

---

**🎉 现在就开始使用吧！如有问题请查看其他文档。**
