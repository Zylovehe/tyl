package com.tyl.system.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.tyl.system.entity.SysUser;
import com.tyl.system.mapper.SysUserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 用户服务类
 */
@Service
public class UserService {

    @Autowired
    private SysUserMapper userMapper;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    /**
     * 根据ID查询用户
     */
    public SysUser getById(Long id) {
        return userMapper.selectById(id);
    }

    /**
     * 查询所有用户
     */
    public List<SysUser> list() {
        return userMapper.selectList(new LambdaQueryWrapper<>());
    }

    /**
     * 新增用户
     */
    @Transactional(rollbackFor = Exception.class)
    public void save(SysUser user) {
        // BCrypt加密密码
        if (user.getPassword() != null) {
            user.setPassword(passwordEncoder.encode(user.getPassword()));
        }
        user.setDeleted(0);
        userMapper.insert(user);
    }

    /**
     * 更新用户
     */
    @Transactional(rollbackFor = Exception.class)
    public void update(SysUser user) {
        // 如果修改密码，需要加密
        if (user.getPassword() != null) {
            user.setPassword(passwordEncoder.encode(user.getPassword()));
        }
        userMapper.updateById(user);
    }

    /**
     * 删除用户
     */
    @Transactional(rollbackFor = Exception.class)
    public void delete(Long id) {
        userMapper.deleteById(id);
    }
}
