package com.tyl.system.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.tyl.system.common.JwtUtil;
import com.tyl.system.dto.LoginRequest;
import com.tyl.system.dto.LoginResponse;
import com.tyl.system.entity.SysMenu;
import com.tyl.system.entity.SysRole;
import com.tyl.system.entity.SysUser;
import com.tyl.system.mapper.SysMenuMapper;
import com.tyl.system.mapper.SysRoleMapper;
import com.tyl.system.mapper.SysUserMapper;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.DigestUtils;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 认证服务类
 */
@Service
public class AuthService {

    @Autowired
    private SysUserMapper userMapper;

    @Autowired
    private SysRoleMapper roleMapper;

    @Autowired
    private SysMenuMapper menuMapper;

    @Autowired
    private JwtUtil jwtUtil;

    /**
     * 用户登录
     */
    public LoginResponse login(LoginRequest request) {
        // 查询用户
        SysUser user = userMapper.selectByUsername(request.getUsername());
        if (user == null) {
            throw new RuntimeException("用户名或密码错误");
        }

        // 验证密码
        String encryptPassword = DigestUtils.md5DigestAsHex(request.getPassword().getBytes(StandardCharsets.UTF_8));
        if (!encryptPassword.equals(user.getPassword())) {
            throw new RuntimeException("用户名或密码错误");
        }

        // 检查用户状态
        if (user.getStatus() == 0) {
            throw new RuntimeException("用户已被禁用");
        }

        // 生成token
        String token = jwtUtil.generateToken(user.getId(), user.getUsername());

        // 构建返回信息
        LoginResponse response = new LoginResponse();
        response.setToken(token);

        LoginResponse.UserInfo userInfo = new LoginResponse.UserInfo();
        BeanUtils.copyProperties(user, userInfo);

        // 查询用户角色
        List<SysRole> roles = roleMapper.selectRolesByUserId(user.getId());
        List<String> roleNames = roles.stream().map(SysRole::getRoleName).collect(Collectors.toList());
        userInfo.setRoles(roleNames);

        // 查询用户菜单
        List<SysMenu> menus = menuMapper.selectMenusByUserId(user.getId());
        List<LoginResponse.MenuInfo> menuInfos = new ArrayList<>();
        for (SysMenu menu : menus) {
            LoginResponse.MenuInfo menuInfo = new LoginResponse.MenuInfo();
            BeanUtils.copyProperties(menu, menuInfo);
            menuInfos.add(menuInfo);
        }
        userInfo.setMenus(menuInfos);

        response.setUserInfo(userInfo);
        return response;
    }

    /**
     * 用户退出
     */
    public void logout() {
        // JWT无状态，前端删除token即可，后端可以记录黑名单（简化处理）
    }
}
