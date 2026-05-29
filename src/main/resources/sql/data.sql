-- 初始化数据

USE `tyl_system`;

-- 插入默认用户 (密码: admin123)
INSERT INTO `sys_user` (`username`, `password`, `real_name`, `phone`, `email`, `status`) 
VALUES ('admin', '0192023a7bbd73250516f069df18b500', '管理员', '13800138000', 'admin@example.com', 1);

-- 插入默认角色
INSERT INTO `sys_role` (`role_name`, `role_code`, `description`, `status`) 
VALUES 
('超级管理员', 'SUPER_ADMIN', '拥有所有权限', 1),
('普通用户', 'USER', '普通用户权限', 1);

-- 插入默认菜单
INSERT INTO `sys_menu` (`parent_id`, `menu_name`, `menu_code`, `path`, `component`, `icon`, `sort`, `type`, `perms`, `status`) 
VALUES 
(0, '系统管理', 'SYSTEM', '/system', 'Layout', 'setting', 1, 0, NULL, 1),
(1, '用户管理', 'USER_MANAGE', '/system/user', 'system/user/index', 'user', 1, 1, 'system:user:list', 1),
(1, '角色管理', 'ROLE_MANAGE', '/system/role', 'system/role/index', 'peoples', 2, 1, 'system:role:list', 1),
(1, '菜单管理', 'MENU_MANAGE', '/system/menu', 'system/menu/index', 'tree-table', 3, 1, 'system:menu:list', 1);

-- 关联用户和角色 (admin用户关联超级管理员角色)
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (1, 1);

-- 关联角色和菜单 (超级管理员角色关联所有菜单)
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1, 1), (1, 2), (1, 3), (1, 4);
