package com.tyl.system.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.tyl.system.entity.SysMenu;
import com.tyl.system.mapper.SysMenuMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 菜单服务类
 */
@Service
public class MenuService {

    @Autowired
    private SysMenuMapper menuMapper;

    /**
     * 根据ID查询菜单
     */
    public SysMenu getById(Long id) {
        return menuMapper.selectById(id);
    }

    /**
     * 查询所有菜单
     */
    public List<SysMenu> list() {
        return menuMapper.selectList(new LambdaQueryWrapper<SysMenu>().orderByAsc(SysMenu::getSort));
    }

    /**
     * 新增菜单
     */
    @Transactional(rollbackFor = Exception.class)
    public void save(SysMenu menu) {
        menu.setCreateTime(LocalDateTime.now());
        menu.setUpdateTime(LocalDateTime.now());
        menu.setDeleted(0);
        menuMapper.insert(menu);
    }

    /**
     * 更新菜单
     */
    @Transactional(rollbackFor = Exception.class)
    public void update(SysMenu menu) {
        menu.setUpdateTime(LocalDateTime.now());
        menuMapper.updateById(menu);
    }

    /**
     * 删除菜单
     */
    @Transactional(rollbackFor = Exception.class)
    public void delete(Long id) {
        menuMapper.deleteById(id);
    }
}
