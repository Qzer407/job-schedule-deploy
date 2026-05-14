#!/bin/bash

echo "===== 启动分布式任务调度平台 ====="

echo "正在启动所有服务..."
docker-compose up -d

echo ""
echo "===== 服务启动完成 ====="
echo ""
echo "服务地址:"
echo "  前端页面:     http://localhost"
echo "  后端API:      http://localhost:8080/api/v1"
echo "  XXL-JOB管理:  http://localhost:8081/xxl-job-admin"
echo "  RabbitMQ管理: http://localhost:15672"
echo ""
echo "查看日志: docker-compose logs -f"
echo "停止服务: docker-compose down"
