#!/bin/bash

echo "===== 停止分布式任务调度平台 ====="

echo "正在停止所有服务..."
docker-compose down

echo ""
echo "===== 服务已停止 ====="
