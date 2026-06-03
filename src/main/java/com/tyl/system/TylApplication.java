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
        // 每次启动都用 BCrypt 动态生成 "123456" 的哈希，确保与 AuthService 验证一致
        String pwd = passwordEncoder.encode("123456");

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
            System.out.println("[初始化] admin 用户已创建，密码: 123456");
        } else {
            // 已存在：更新密码 + 获取ID
            existingUser.setPassword(pwd);
            userMapper.updateById(existingUser);
            adminId = existingUser.getId();
            System.out.println("[初始化] admin 密码已更新为: 123456");
        }

        // 确保 admin 用户关联超级管理员角色（role_id=1）
        int count = userMapper.selectCount(
                new LambdaQueryWrapper<SysUser>()
                        .eq(SysUser::getUsername, "admin")
                        .apply("EXISTS (SELECT 1 FROM sys_user_role WHERE user_id = {0} AND role_id = 1)", adminId)
        ) > 0 ? 1 : 0;

        // 通过原生SQL插入用户-角色关联（如果不存在）
        if (count == 0) {
            try {
                // MyBatis Plus 不直接支持 INSERT IGNORE，用 BaseMapper 的 insert 不适用关联表
                // 这里通过 @Select 注解或直接 SQL 执行
                userMapper.insertUserRole(adminId, 1L);
                System.out.println("[初始化] admin 已关联超级管理员角色");
            } catch (Exception e) {
                // 关联可能已存在（并发场景），忽略即可
                System.out.println("[初始化] 用户角色关联已存在或创建失败: " + e.getMessage());
            }
        }
    }
}
