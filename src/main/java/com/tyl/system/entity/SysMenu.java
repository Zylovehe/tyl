package com.tyl.system.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 菜单实体类
 */
@Data
@TableName("sys_menu")
public class SysMenu implements Serializable {
    
    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long parentId; // 父菜单ID

    private String menuName;

    private String menuCode;

    private String path; // 路由路径

    private String component; // 组件路径

    private String icon; // 图标

    private Integer sort; // 排序

    private Integer type; // 0-目录 1-菜单 2-按钮

    private String perms; // 权限标识

    private Integer status; // 0-禁用 1-正常

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    @TableLogic
    private Integer deleted; // 0-未删除 1-已删除
}
