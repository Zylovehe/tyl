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

        if (existingUser == null) {
            SysUser user = new SysUser();
            user.setUsername("admin");
            user.setPassword(pwd);
            user.setNickname("管理员");
            user.setDeleted(0);
            userMapper.insert(user);
            System.out.println("[初始化] admin 用户已创建，密码: 123456");
        } else {
            existingUser.setPassword(pwd);
            userMapper.updateById(existingUser);
            System.out.println("[初始化] admin 密码已更新为: 123456");
        }
    }
}
