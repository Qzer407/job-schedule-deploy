CREATE TABLE IF NOT EXISTS `t_task_info` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `task_name` VARCHAR(200) NOT NULL,
    `task_group` VARCHAR(100) NOT NULL,
    `cron_expression` VARCHAR(100) NOT NULL,
    `executor_handler` VARCHAR(200) NOT NULL,
    `executor_param` VARCHAR(500),
    `sharding_total` INT DEFAULT 1,
    `sharding_param` VARCHAR(500),
    `retry_count` INT DEFAULT 3,
    `alarm_status` TINYINT DEFAULT 1,
    `status` TINYINT DEFAULT 0,
    `description` VARCHAR(500),
    `timeout` INT DEFAULT 0,
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_task_group` (`task_group`),
    INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `t_task_log` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `task_id` BIGINT NOT NULL,
    `task_name` VARCHAR(200) NOT NULL,
    `executor_address` VARCHAR(200),
    `sharding_index` INT DEFAULT 0,
    `sharding_param` VARCHAR(500),
    `trigger_time` DATETIME NOT NULL,
    `start_time` DATETIME,
    `end_time` DATETIME,
    `duration` BIGINT,
    `execution_status` TINYINT DEFAULT 0,
    `execution_log` TEXT,
    `error_msg` TEXT,
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_task_id` (`task_id`),
    INDEX `idx_trigger_time` (`trigger_time`),
    INDEX `idx_execution_status` (`execution_status`),
    CONSTRAINT `fk_task_log_task_id` FOREIGN KEY (`task_id`) REFERENCES `t_task_info`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `t_alarm_record` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `task_id` BIGINT NOT NULL,
    `task_name` VARCHAR(200) NOT NULL,
    `alarm_type` VARCHAR(50) NOT NULL,
    `alarm_level` VARCHAR(20),
    `alarm_title` VARCHAR(200) NOT NULL,
    `alarm_content` TEXT NOT NULL,
    `alarm_channel` VARCHAR(50) NOT NULL,
    `alarm_time` DATETIME NOT NULL,
    `send_status` TINYINT DEFAULT 0,
    `error_msg` TEXT,
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_task_id` (`task_id`),
    INDEX `idx_alarm_time` (`alarm_time`),
    INDEX `idx_send_status` (`send_status`),
    CONSTRAINT `fk_alarm_record_task_id` FOREIGN KEY (`task_id`) REFERENCES `t_task_info`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `t_alarm_config` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `channel_type` VARCHAR(50) NOT NULL UNIQUE,
    `channel_name` VARCHAR(200),
    `channel_config` TEXT,
    `enabled` TINYINT(1) DEFAULT 1,
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `t_executor_info` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `executor_name` VARCHAR(200) NOT NULL,
    `executor_address` VARCHAR(200) NOT NULL,
    `executor_group` VARCHAR(100) NOT NULL,
    `status` TINYINT DEFAULT 1,
    `last_heartbeat` DATETIME,
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_executor_group` (`executor_group`),
    INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `t_user` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(100) NOT NULL UNIQUE,
    `password` VARCHAR(200) NOT NULL,
    `email` VARCHAR(200),
    `role` VARCHAR(50) DEFAULT 'USER',
    `status` TINYINT DEFAULT 1,
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_username` (`username`),
    INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `t_workflow` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `workflow_name` VARCHAR(200) NOT NULL,
    `workflow_desc` VARCHAR(500),
    `workflow_config` TEXT COMMENT '工作流配置JSON',
    `status` TINYINT DEFAULT 0,
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_workflow_name` (`workflow_name`),
    INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `t_workflow_execution` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `workflow_id` BIGINT NOT NULL,
    `execution_status` TINYINT DEFAULT 0,
    `trigger_type` VARCHAR(50),
    `start_time` DATETIME,
    `end_time` DATETIME,
    `execution_log` TEXT,
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_workflow_id` (`workflow_id`),
    INDEX `idx_execution_status` (`execution_status`),
    INDEX `idx_start_time` (`start_time`),
    CONSTRAINT `fk_workflow_execution_workflow_id` FOREIGN KEY (`workflow_id`) REFERENCES `t_workflow`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `t_task_dependency` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `workflow_id` BIGINT NOT NULL,
    `task_id` BIGINT NOT NULL,
    `parent_task_id` BIGINT,
    `dependency_type` VARCHAR(50) DEFAULT 'SUCCESS',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_workflow_id` (`workflow_id`),
    INDEX `idx_task_id` (`task_id`),
    INDEX `idx_parent_task_id` (`parent_task_id`),
    CONSTRAINT `fk_task_dependency_workflow_id` FOREIGN KEY (`workflow_id`) REFERENCES `t_workflow`(`id`),
    CONSTRAINT `fk_task_dependency_task_id` FOREIGN KEY (`task_id`) REFERENCES `t_task_info`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `t_sub_task` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `parent_task_id` BIGINT NOT NULL,
    `sub_task_name` VARCHAR(200) NOT NULL,
    `executor_handler` VARCHAR(200) NOT NULL,
    `executor_param` VARCHAR(500),
    `retry_count` INT DEFAULT 3,
    `order_index` INT DEFAULT 0,
    `status` TINYINT DEFAULT 1,
    `description` VARCHAR(500),
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_parent_task_id` (`parent_task_id`),
    INDEX `idx_order_index` (`order_index`),
    INDEX `idx_status` (`status`),
    CONSTRAINT `fk_sub_task_parent_task_id` FOREIGN KEY (`parent_task_id`) REFERENCES `t_task_info`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `t_workflow_template` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `template_name` VARCHAR(200) NOT NULL,
    `template_desc` VARCHAR(500),
    `template_type` VARCHAR(50),
    `template_config` TEXT,
    `status` TINYINT DEFAULT 1,
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_template_name` (`template_name`),
    INDEX `idx_template_type` (`template_type`),
    INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;