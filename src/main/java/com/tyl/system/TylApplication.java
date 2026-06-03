package com.tyl.system;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.tyl.system.entity.SysUser;
import com.tyl.system.mapper.SysUserMapper;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@SpringBootApplication
@MapperScan("com.tyl.system.mapper")
public class TylApplication implements CommandLineRunner {

    @Autowired
    private SysUserMapper userMapper;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public static void main(String[] args) {
        SpringApplication.run(TylApplication.class, args);
    }

    @Override
    public void run(String... args) {
        try {
            String pwd = passwordEncoder.encode("123456");
            System.out.println("[初始化] 正在检查 admin 用户...");

            SysUser existingUser = userMapper.selectOne(
                    new LambdaQueryWrapper<SysUser>().eq(SysUser::getUsername, "admin")
            );

            Long adminId;
            if (existingUser == null) {
                // 首次启动：创建admin用户
                SysUser user = new SysUser();
                user.setUsername("admin");
                user.setPassword(pwd);
                user.setNickname("管理员");
                user.setDeleted(0);
                userMapper.insert(user);
                adminId = user.getId();
                System.out.println("[初始化] admin 用户已创建，密码: 123456, id=" + adminId);
            } else {
                existingUser.setPassword(pwd);
                userMapper.updateById(existingUser);
                adminId = existingUser.getId();
                System.out.println("[初始化] admin 密码已更新为: 123456, id=" + adminId);
            }

            // 关联超级管理员角色（幂等：INSERT IGNORE）
            try {
                userMapper.insertUserRole(adminId, 1L);
                System.out.println("[初始化] admin 已关联超级管理员角色(role_id=1)");
            } catch (Exception e) {
                System.out.println("[初始化] 角色关联信息: " + e.getMessage());
            }
        } catch (Exception e) {
            System.err.println("[初始化失败] " + e.getClass().getSimpleName() + ": " + e.getMessage());
            e.printStackTrace();
        }
    }
}
