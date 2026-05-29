# 🔗 前后端登录联调完整指南

## 📋 目录

1. [后端API接口说明](#后端api接口说明)
2. [前端调用示例](#前端调用示例)
3. [联调步骤](#联调步骤)
4. [常见问题](#常见问题)

---

## 🎯 后端API接口说明

### 登录接口

**请求地址：**
```
POST https://tyl-backend.onrender.com/api/auth/login
```

**请求头：**
```json
{
  "Content-Type": "application/json"
}
```

**请求体：**
```json
{
  "username": "admin",
  "password": "admin123"
}
```

**成功响应（200）：**
```json
{
  "code": 200,
  "message": "操作成功",
  "data": {
    "token": "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsImlkIjoxLCJleHAiOjE3MTY5ODg4MDB9.xxx",
    "userInfo": {
      "id": 1,
      "username": "admin",
      "realName": "超级管理员",
      "phone": null,
      "email": null,
      "roles": ["超级管理员"],
      "menus": [
        {
          "id": 1,
          "parentId": 0,
          "menuName": "系统管理",
          "path": "/system",
          "component": "Layout",
          "icon": "Setting",
          "type": 1,
          "perms": "system"
        },
        {
          "id": 2,
          "parentId": 1,
          "menuName": "用户管理",
          "path": "/system/user",
          "component": "system/user/index",
          "icon": "User",
          "type": 2,
          "perms": "system:user:list"
        }
      ]
    }
  }
}
```

**失败响应（200，但code不为200）：**
```json
{
  "code": 500,
  "message": "用户名或密码错误",
  "data": null
}
```

---

## 💻 前端调用示例

### Vue 3 + Axios

#### 1. 安装依赖

```bash
npm install axios
```

#### 2. 创建API配置文件 `src/api/auth.js`

```javascript
import axios from 'axios'

// 创建axios实例
const api = axios.create({
  baseURL: 'https://tyl-backend.onrender.com', // Render后端地址
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
})

// 请求拦截器
api.interceptors.request.use(
  config => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  error => {
    return Promise.reject(error)
  }
)

// 响应拦截器
api.interceptors.response.use(
  response => {
    const res = response.data
    if (res.code !== 200) {
      ElMessage.error(res.message || '请求失败')
      return Promise.reject(new Error(res.message || '请求失败'))
    }
    return res
  },
  error => {
    ElMessage.error(error.message || '网络错误')
    return Promise.reject(error)
  }
)

export default api
```

#### 3. 创建登录API `src/api/login.js`

```javascript
import api from './auth'

/**
 * 用户登录
 */
export function login(data) {
  return api.post('/api/auth/login', data)
}

/**
 * 用户退出
 */
export function logout() {
  return api.post('/api/auth/logout')
}
```

#### 4. 登录页面组件 `src/views/Login.vue`

```vue
<template>
  <div class="login-container">
    <el-card class="login-card">
      <h2 class="login-title">统艺灵管理系统</h2>
      
      <el-form :model="loginForm" :rules="rules" ref="loginFormRef">
        <el-form-item prop="username">
          <el-input 
            v-model="loginForm.username" 
            placeholder="请输入用户名"
            prefix-icon="User"
          />
        </el-form-item>
        
        <el-form-item prop="password">
          <el-input 
            v-model="loginForm.password" 
            type="password"
            placeholder="请输入密码"
            prefix-icon="Lock"
            @keyup.enter="handleLogin"
          />
        </el-form-item>
        
        <el-form-item>
          <el-button 
            type="primary" 
            :loading="loading"
            @click="handleLogin"
            style="width: 100%"
          >
            {{ loading ? '登录中...' : '登 录' }}
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { login } from '@/api/login'

const router = useRouter()
const loginFormRef = ref(null)
const loading = ref(false)

const loginForm = reactive({
  username: 'admin',
  password: 'admin123'
})

const rules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少6位', trigger: 'blur' }
  ]
}

const handleLogin = async () => {
  try {
    await loginFormRef.value.validate()
    
    loading.value = true
    
    const res = await login(loginForm)
    
    // 保存token和用户信息
    localStorage.setItem('token', res.data.token)
    localStorage.setItem('userInfo', JSON.stringify(res.data.userInfo))
    
    ElMessage.success('登录成功')
    
    // 跳转到首页
    router.push('/')
    
  } catch (error) {
    console.error('登录失败:', error)
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.login-card {
  width: 400px;
  padding: 20px;
}

.login-title {
  text-align: center;
  margin-bottom: 30px;
  color: #333;
}
</style>
```

---

### React + Axios

#### 1. 安装依赖

```bash
npm install axios react-router-dom
```

#### 2. 创建API配置 `src/api/auth.js`

```javascript
import axios from 'axios'

const api = axios.create({
  baseURL: 'https://tyl-backend.onrender.com',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
})

// 请求拦截器
api.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// 响应拦截器
api.interceptors.response.use(
  response => {
    const res = response.data
    if (res.code !== 200) {
      message.error(res.message || '请求失败')
      return Promise.reject(new Error(res.message))
    }
    return res
  },
  error => {
    message.error(error.message || '网络错误')
    return Promise.reject(error)
  }
)

export default api
```

#### 3. 登录API `src/api/login.js`

```javascript
import api from './auth'

export const login = (data) => {
  return api.post('/api/auth/login', data)
}

export const logout = () => {
  return api.post('/api/auth/logout')
}
```

#### 4. 登录页面 `src/pages/Login.jsx`

```jsx
import React, { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { Form, Input, Button, Card, message } from 'antd'
import { UserOutlined, LockOutlined } from '@ant-design/icons'
import { login } from '../api/login'

const Login = () => {
  const navigate = useNavigate()
  const [loading, setLoading] = useState(false)

  const onFinish = async (values) => {
    try {
      setLoading(true)
      const res = await login(values)
      
      // 保存token和用户信息
      localStorage.setItem('token', res.data.token)
      localStorage.setItem('userInfo', JSON.stringify(res.data.userInfo))
      
      message.success('登录成功')
      navigate('/')
    } catch (error) {
      console.error('登录失败:', error)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div style={{ 
      display: 'flex', 
      justifyContent: 'center', 
      alignItems: 'center', 
      height: '100vh',
      background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)'
    }}>
      <Card style={{ width: 400 }} title="统艺灵管理系统">
        <Form
          name="login"
          initialValues={{ username: 'admin', password: 'admin123' }}
          onFinish={onFinish}
        >
          <Form.Item
            name="username"
            rules={[{ required: true, message: '请输入用户名' }]}
          >
            <Input 
              prefix={<UserOutlined />} 
              placeholder="用户名" 
            />
          </Form.Item>

          <Form.Item
            name="password"
            rules={[{ required: true, message: '请输入密码' }]}
          >
            <Input.Password 
              prefix={<LockOutlined />} 
              placeholder="密码" 
            />
          </Form.Item>

          <Form.Item>
            <Button 
              type="primary" 
              htmlType="submit" 
              loading={loading}
              block
            >
              登录
            </Button>
          </Form.Item>
        </Form>
      </Card>
    </div>
  )
}

export default Login
```

---

### 原生JavaScript（无框架）

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <title>登录</title>
  <style>
    body {
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      margin: 0;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    }
    .login-box {
      background: white;
      padding: 40px;
      border-radius: 10px;
      box-shadow: 0 10px 25px rgba(0,0,0,0.1);
    }
    input {
      display: block;
      width: 300px;
      padding: 10px;
      margin: 10px 0;
      border: 1px solid #ddd;
      border-radius: 5px;
    }
    button {
      width: 100%;
      padding: 10px;
      background: #667eea;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
    }
    button:hover {
      background: #5568d3;
    }
  </style>
</head>
<body>
  <div class="login-box">
    <h2>统艺灵管理系统</h2>
    <input type="text" id="username" placeholder="用户名" value="admin">
    <input type="password" id="password" placeholder="密码" value="admin123">
    <button onclick="handleLogin()">登录</button>
  </div>

  <script>
    async function handleLogin() {
      const username = document.getElementById('username').value
      const password = document.getElementById('password').value

      try {
        const response = await fetch('https://tyl-backend.onrender.com/api/auth/login', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({ username, password })
        })

        const result = await response.json()

        if (result.code === 200) {
          // 保存token
          localStorage.setItem('token', result.data.token)
          localStorage.setItem('userInfo', JSON.stringify(result.data.userInfo))
          
          alert('登录成功！')
          console.log('Token:', result.data.token)
          console.log('用户信息:', result.data.userInfo)
          
          // 跳转到首页
          window.location.href = '/index.html'
        } else {
          alert('登录失败：' + result.message)
        }
      } catch (error) {
        console.error('登录错误:', error)
        alert('网络错误，请稍后重试')
      }
    }
  </script>
</body>
</html>
```

---

## 🚀 联调步骤

### 第1步：确认后端服务运行

#### 本地测试
```bash
# 启动后端服务
start.bat

# 或使用Maven
mvn spring-boot:run
```

访问：http://localhost:8080/api/auth/login

#### 云端测试
访问：https://tyl-backend.onrender.com/api/auth/login

---

### 第2步：测试登录接口

使用Postman或curl测试：

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

---

### 第3步：前端配置API地址

根据你的前端项目类型，修改API基础URL：

**Vue/React:**
```javascript
// src/api/auth.js
const api = axios.create({
  baseURL: 'https://tyl-backend.onrender.com', // 生产环境
  // baseURL: 'http://localhost:8080', // 本地开发
  timeout: 10000
})
```

**环境变量配置（推荐）：**

`.env.development`
```
VITE_API_BASE_URL=http://localhost:8080
```

`.env.production`
```
VITE_API_BASE_URL=https://tyl-backend.onrender.com
```

代码中使用：
```javascript
const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL
})
```

---

### 第4步：处理CORS跨域

后端已配置CORS，允许所有来源访问。如果仍有问题：

**检查后端配置：**
```java
// CorsConfig.java
@Configuration
public class CorsConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOriginPatterns("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowCredentials(true)
                .maxAge(3600);
    }
}
```

---

### 第5步：前端保存Token

登录成功后，将Token保存到localStorage：

```javascript
// 保存
localStorage.setItem('token', res.data.token)
localStorage.setItem('userInfo', JSON.stringify(res.data.userInfo))

// 读取
const token = localStorage.getItem('token')
const userInfo = JSON.parse(localStorage.getItem('userInfo'))
```

---

### 第6步：配置请求拦截器

在后续请求中自动携带Token：

```javascript
// Axios请求拦截器
api.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})
```

---

### 第7步：路由守卫（可选）

保护需要登录的路由：

**Vue Router:**
```javascript
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token')
  
  if (to.meta.requiresAuth && !token) {
    next('/login')
  } else {
    next()
  }
})
```

**React Router:**
```jsx
const ProtectedRoute = ({ children }) => {
  const token = localStorage.getItem('token')
  
  if (!token) {
    return <Navigate to="/login" />
  }
  
  return children
}
```

---

## 🧪 测试用例

### 测试1：正常登录

**请求：**
```json
{
  "username": "admin",
  "password": "admin123"
}
```

**预期：** 返回200和Token

---

### 测试2：密码错误

**请求：**
```json
{
  "username": "admin",
  "password": "wrong_password"
}
```

**预期：**
```json
{
  "code": 500,
  "message": "用户名或密码错误",
  "data": null
}
```

---

### 测试3：用户不存在

**请求：**
```json
{
  "username": "nonexistent",
  "password": "admin123"
}
```

**预期：**
```json
{
  "code": 500,
  "message": "用户名或密码错误",
  "data": null
}
```

---

### 测试4：参数缺失

**请求：**
```json
{
  "username": "admin"
}
```

**预期：** 400 Bad Request（验证失败）

---

## 🆘 常见问题

### Q1: CORS错误

**现象：**
```
Access to XMLHttpRequest at 'https://tyl-backend.onrender.com/api/auth/login' 
from origin 'http://localhost:3000' has been blocked by CORS policy
```

**解决：**
1. 确认后端CORS配置正确
2. 清除浏览器缓存
3. 重启后端服务

---

### Q2: Token无效

**现象：** 后续请求返回401

**解决：**
1. 检查Token是否正确保存
2. 检查请求头格式：`Authorization: Bearer {token}`
3. 确认Token未过期（默认24小时）

---

### Q3: 网络错误

**现象：** Connection refused / Timeout

**解决：**
1. 确认后端服务正在运行
2. 检查API地址是否正确
3. 检查网络连接

---

### Q4: 中文乱码

**现象：** 返回的用户名是乱码

**解决：**
确保数据库连接URL包含：
```
characterEncoding=utf8&useUnicode=true
```

---

### Q5: 密码加密不一致

**现象：** 数据库中密码与前端输入的MD5不匹配

**解决：**
后端使用MD5加密：
```java
String encryptPassword = DigestUtils.md5DigestAsHex(
  request.getPassword().getBytes(StandardCharsets.UTF_8)
);
```

前端测试时直接使用明文密码 `admin123`。

---

## 📊 完整的登录流程

```
┌──────────┐         ┌──────────┐         ┌──────────┐
│   前端    │         │   后端    │         │  数据库   │
└────┬─────┘         └────┬─────┘         └────┬─────┘
     │                     │                     │
     │  POST /api/auth/login                    │
     │  {username, password}                    │
     ├────────────────────►│                     │
     │                     │  SELECT * FROM     │
     │                     │  sys_user WHERE    │
     │                     │  username=?        │
     │                     ├────────────────────►│
     │                     │                     │
     │                     │  验证密码(MD5)      │
     │                     │  生成JWT Token      │
     │                     │  查询角色和菜单      │
     │                     │                     │
     │  {token, userInfo}  │                     │
     │◄────────────────────┤                     │
     │                     │                     │
     │  保存Token到         │                     │
     │  localStorage       │                     │
     │                     │                     │
     │  跳转到首页          │                     │
     │                     │                     │
```

---

## ✨ 总结

### 后端已完成 ✅

- ✅ 登录接口 `/api/auth/login`
- ✅ JWT Token生成
- ✅ 用户信息查询
- ✅ 角色和菜单查询
- ✅ CORS跨域配置
- ✅ 参数验证

### 前端需要实现

1. **登录表单** - 用户名和密码输入
2. **API调用** - 发送POST请求到后端
3. **Token存储** - 保存到localStorage
4. **路由跳转** - 登录成功后跳转
5. **请求拦截** - 后续请求携带Token
6. **路由守卫** - 保护需要登录的页面

---

**🎉 现在可以开始前后端联调了！**

先使用Postman或curl测试后端接口，确认返回正确后再集成到前端项目中。
