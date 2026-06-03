package com.tyl.system.service;

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
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

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

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder(10);

    /**
     * 用户登录
     */
    public LoginResponse login(LoginRequest request) {
        // 调试：打印前端传入的用户名和密码
        System.out.println("前端传入用户名: " + request.getUsername());
        System.out.println("前端传入密码: " + request.getPassword());

        // 查询用户
        SysUser user = userMapper.selectByUsername(request.getUsername());
        System.out.println("user---------------: " + user);
        if (user == null) {
            System.out.println("错误: 用户不存在");
            throw new RuntimeException("用户名或密码错误验验证；看一下如何操作操作当前的密码");
        }

        // 调试：打印数据库中的密码哈希
        System.out.println("数据库中密码哈希: " + user.getPassword());
//         User user = userMapper.selectByUsername(dto.getUsername());
// // 新增日志
// log.info("【远程库查出密文】{}",user.getPassword());
// log.info("【前端输入明文】{}",dto.getPassword());


        // 验证密码（BCrypt）
        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            System.out.println("错误: 密码验证失败");
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
