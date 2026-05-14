# Job Scheduler Deploy

分布式定时任务调度平台 - 部署配置仓库

## 目录结构

```
deploy/
├── docker-compose/          # Docker Compose 编排配置
│   └── docker-compose.yml   # 主配置文件
├── scripts/                 # 部署脚本
│   ├── start.sh            # 启动脚本
│   └── stop.sh             # 停止脚本
├── config/                  # 配置文件
│   └── env.example          # 环境变量示例
└── docs/                   # 项目文档
    ├── 01-需求分析.md
    ├── 02-技术选型.md
    ├── 03-架构设计.md
    ├── 04-数据库设计.md
    ├── 05-API接口设计.md
    ├── 06-技术预研.md
    └── 07-最小版本方案.md
```

## 快速开始

### 1. 克隆仓库

```bash
git clone https://github.com/Qzer407/job-schedule-deploy.git
cd job-schedule-deploy
```

### 2. 配置环境变量

```bash
cp config/env.example config/.env
# 编辑 config/.env 填写实际配置
```

### 3. 启动服务

```bash
cd scripts
./start.sh
```

### 4. 停止服务

```bash
cd scripts
./stop.sh
```

## 服务地址

| 服务 | 地址 |
|-----|------|
| 前端页面 | http://localhost |
| 后端API | http://localhost:8080/api/v1 |
| XXL-JOB管理 | http://localhost:8081/xxl-job-admin |
| RabbitMQ管理 | http://localhost:15672 |

## 相关仓库

| 仓库 | 说明 |
|------|------|
| [job-schedule-backend](https://github.com/Qzer407/job-schedule-backend) | 后端服务 |
| [job-schedule-frontend](https://github.com/Qzer407/job-schedule-frontend) | 前端应用 |
