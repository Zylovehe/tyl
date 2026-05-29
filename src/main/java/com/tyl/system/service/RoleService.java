package com.tyl.system.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.tyl.system.entity.SysRole;
import com.tyl.system.mapper.SysRoleMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 角色服务类
 */
@Service
public class RoleService {

    @Autowired
    private SysRoleMapper roleMapper;

    /**
     * 根据ID查询角色
     */
    public SysRole getById(Long id) {
        return roleMapper.selectById(id);
    }

    /**
     * 查询所有角色
     */
    public List<SysRole> list() {
        return roleMapper.selectList(new LambdaQueryWrapper<>());
    }

    /**
     * 新增角色
     */
    @Transactional(rollbackFor = Exception.class)
    public void save(SysRole role) {
        role.setCreateTime(LocalDateTime.now());
        role.setUpdateTime(LocalDateTime.now());
        role.setDeleted(0);
        roleMapper.insert(role);
    }

    /**
     * 更新角色
     */
    @Transactional(rollbackFor = Exception.class)
    public void update(SysRole role) {
        role.setUpdateTime(LocalDateTime.now());
        roleMapper.updateById(role);
    }

    /**
     * 删除角色
     */
    @Transactional(rollbackFor = Exception.class)
    public void delete(Long id) {
        roleMapper.deleteById(id);
    }
}
