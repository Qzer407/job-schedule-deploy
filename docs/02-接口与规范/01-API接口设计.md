# 分布式定时任务调度平台 - API接口设计文档

## 1. 接口概述

本系统采用 RESTful 风格设计 API，统一响应格式，支持 JSON 数据交互。

### 1.1 基础路径

所有接口基础路径：`/api/v1`

### 1.2 统一响应格式

```json
{
  "code": 200,
  "message": "success",
  "data": {},
  "timestamp": 1699999999999
}
```

| 字段 | 类型 | 说明 |
|-----|------|------|
| code | INT | 状态码，200表示成功，其他表示失败 |
| message | STRING | 响应消息 |
| data | OBJECT/ARRAY | 响应数据 |
| timestamp | LONG | 响应时间戳 |

### 1.3 状态码定义

| 状态码 | 含义 |
|-------|------|
| 200 | 成功 |
| 400 | 请求参数错误 |
| 401 | 未授权 |
| 403 | 禁止访问 |
| 404 | 资源不存在 |
| 500 | 服务器内部错误 |

---

## 2. 任务管理接口

### 2.1 创建任务

**路径**：`POST /api/v1/tasks`

**请求体**：
```json
{
  "taskName": "string",
  "taskGroup": "string",
  "cronExpression": "string",
  "executorHandler": "string",
  "executorParam": "string",
  "shardingTotal": 1,
  "shardingParam": "string",
  "retryCount": 3,
  "alarmStatus": 1,
  "description": "string"
}
```

| 字段 | 类型 | 必填 | 说明 |
|-----|------|------|------|
| taskName | String | 是 | 任务名称 |
| taskGroup | String | 是 | 任务分组 |
| cronExpression | String | 是 | Cron表达式 |
| executorHandler | String | 是 | 执行器处理器 |
| executorParam | String | 否 | 执行参数 |
| shardingTotal | Integer | 否 | 分片总数，默认1 |
| shardingParam | String | 否 | 分片参数 |
| retryCount | Integer | 否 | 重试次数，默认3 |
| alarmStatus | Integer | 否 | 告警状态，默认1 |
| description | String | 否 | 任务描述 |

**成功响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": 1,
    "taskName": "示例任务",
    "taskGroup": "DEFAULT_GROUP",
    "cronExpression": "0 0/5 * * * ?",
    "status": 0
  }
}
```

### 2.2 查询任务列表

**路径**：`GET /api/v1/tasks`

**请求参数**：
| 参数 | 类型 | 必填 | 说明 |
|-----|------|------|------|
| pageNum | Integer | 否 | 页码，默认1 |
| pageSize | Integer | 否 | 每页数量，默认20 |
| taskName | String | 否 | 任务名称（模糊查询） |
| taskGroup | String | 否 | 任务分组 |
| status | Integer | 否 | 任务状态 |

**成功响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "records": [
      {
        "id": 1,
        "taskName": "示例任务",
        "taskGroup": "DEFAULT_GROUP",
        "cronExpression": "0 0/5 * * * ?",
        "status": 1,
        "createTime": "2026-05-13T10:00:00"
      }
    ],
    "total": 100,
    "pageNum": 1,
    "pageSize": 20
  }
}
```

### 2.3 查询任务详情

**路径**：`GET /api/v1/tasks/{id}`

**路径参数**：
| 参数 | 类型 | 说明 |
|-----|------|------|
| id | Long | 任务ID |

**成功响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": 1,
    "taskName": "示例任务",
    "taskGroup": "DEFAULT_GROUP",
    "cronExpression": "0 0/5 * * * ?",
    "executorHandler": "demoJobHandler",
    "executorParam": "test",
    "shardingTotal": 1,
    "shardingParam": "0=A,1=B",
    "retryCount": 3,
    "alarmStatus": 1,
    "status": 1,
    "description": "示例任务描述",
    "createTime": "2026-05-13T10:00:00",
    "updateTime": "2026-05-13T10:00:00"
  }
}
```

### 2.4 更新任务

**路径**：`PUT /api/v1/tasks/{id}`

**路径参数**：
| 参数 | 类型 | 说明 |
|-----|------|------|
| id | Long | 任务ID |

**请求体**：同创建任务

### 2.5 删除任务

**路径**：`DELETE /api/v1/tasks/{id}`

**路径参数**：
| 参数 | 类型 | 说明 |
|-----|------|------|
| id | Long | 任务ID |

### 2.6 启动任务

**路径**：`POST /api/v1/tasks/{id}/start`

**路径参数**：
| 参数 | 类型 | 说明 |
|-----|------|------|
| id | Long | 任务ID |

### 2.7 停止任务

**路径**：`POST /api/v1/tasks/{id}/stop`

**路径参数**：
| 参数 | 类型 | 说明 |
|-----|------|------|
| id | Long | 任务ID |

### 2.8 手动触发任务

**路径**：`POST /api/v1/tasks/{id}/trigger`

**路径参数**：
| 参数 | 类型 | 说明 |
|-----|------|------|
| id | Long | 任务ID |

**请求体**：
```json
{
  "executorParam": "string"
}
```

---

## 3. 认证接口

### 3.1 用户登录

**路径**：`POST /api/v1/auth/login`

**请求体**：
```json
{
  "username": "string",
  "password": "string"
}
```

**成功响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": 1,
      "username": "admin",
      "email": "admin@example.com",
      "role": "ADMIN"
    }
  }
}
```

### 3.2 用户注册

**路径**：`POST /api/v1/auth/register`

**请求体**：
```json
{
  "username": "string",
  "password": "string",
  "email": "string",
  "role": "USER"
}
```

### 3.3 获取当前用户信息

**路径**：`GET /api/v1/auth/me`

**成功响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": 1,
    "username": "admin",
    "email": "admin@example.com",
    "role": "ADMIN"
  }
}
```

### 3.4 用户登出

**路径**：`POST /api/v1/auth/logout`

---

## 4. 告警配置接口

### 4.1 获取告警配置列表

**路径**：`GET /api/v1/alarms/config`

**成功响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "id": 1,
      "channelType": "EMAIL",
      "channelName": "邮件告警",
      "channelConfig": "{\"host\":\"smtp.example.com\",\"port\":465}",
      "enabled": true
    }
  ]
}
```

### 4.2 获取单个告警配置

**路径**：`GET /api/v1/alarms/config/{channelType}`

### 4.3 创建告警配置

**路径**：`POST /api/v1/alarms/config`

**请求体**：
```json
{
  "channelType": "EMAIL",
  "channelName": "邮件告警",
  "channelConfig": "{\"host\":\"smtp.example.com\",\"port\":465}",
  "enabled": true
}
```

### 4.4 更新告警配置

**路径**：`PUT /api/v1/alarms/config/{channelType}`

### 4.5 删除告警配置

**路径**：`DELETE /api/v1/alarms/config/{channelType}`

### 4.6 测试告警渠道

**路径**：`POST /api/v1/alarms/test/{channelType}`

### 4.7 获取告警记录

**路径**：`GET /api/v1/alarms/records`

**请求参数**：
| 参数 | 类型 | 必填 | 说明 |
|-----|------|------|------|
| pageNum | Integer | 否 | 页码，默认1 |
| pageSize | Integer | 否 | 每页数量，默认20 |
| taskId | Long | 否 | 任务ID |

---

## 5. 工作流接口

### 5.1 获取工作流列表

**路径**：`GET /api/v1/workflows`

**请求参数**：
| 参数 | 类型 | 必填 | 说明 |
|-----|------|------|------|
| pageNum | Integer | 否 | 页码，默认1 |
| pageSize | Integer | 否 | 每页数量，默认20 |

### 5.2 获取工作流详情

**路径**：`GET /api/v1/workflows/{id}`

### 5.3 创建工作流

**路径**：`POST /api/v1/workflows`

**请求体**：
```json
{
  "workflowName": "string",
  "workflowDesc": "string",
  "status": 0
}
```

### 5.4 更新工作流

**路径**：`PUT /api/v1/workflows/{id}`

### 5.5 删除工作流

**路径**：`DELETE /api/v1/workflows/{id}`

### 5.6 执行工作流

**路径**：`POST /api/v1/workflows/{id}/execute`

### 5.7 暂停工作流

**路径**：`POST /api/v1/workflows/{id}/pause`

### 5.8 终止工作流

**路径**：`POST /api/v1/workflows/{id}/terminate`

### 5.9 获取工作流依赖

**路径**：`GET /api/v1/workflows/{id}/dependencies`

### 5.10 添加任务依赖

**路径**：`POST /api/v1/workflows/{id}/dependencies`

**请求体**：
```json
{
  "taskId": 1,
  "parentTaskId": 2,
  "dependencyType": "SUCCESS"
}
```

---

## 6. 监控接口

### 6.1 获取任务统计概览

**路径**：`GET /api/v1/monitor/statistics`

**成功响应**：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "totalTaskCount": 100,
    "runningTaskCount": 5,
    "successRate": 99.5,
    "avgDuration": 120,
    "todayExecuteCount": 500,
    "todayFailCount": 2
  }
}
```

### 6.2 获取执行器列表

**路径**：`GET /api/v1/monitor/executors`

### 6.3 获取任务执行日志

**路径**：`GET /api/v1/logs`

**请求参数**：
| 参数 | 类型 | 必填 | 说明 |
|-----|------|------|------|
| pageNum | Integer | 否 | 页码，默认1 |
| pageSize | Integer | 否 | 每页数量，默认20 |
| taskId | Long | 否 | 任务ID |
| status | Integer | 否 | 执行状态 |

### 6.4 获取日志详情

**路径**：`GET /api/v1/logs/{id}`

### 6.5 删除日志

**路径**：`DELETE /api/v1/logs/{id}`

---

*文档更新时间：2026-05-13*
