package com.tyl.system;

// import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
// import com.tyl.system.entity.SysUser;
// import com.tyl.system.mapper.SysUserMapper;
// import org.mybatis.spring.annotation.MapperScan;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
// import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

// 删掉 implements CommandLineRunner
@SpringBootApplication
public class TylApplication {
    public static void main(String[] args) {
        SpringApplication.run(TylApplication.class,args);
    }

    // 全部删除：@Autowired private SysUserMapper、整个@Override run方法
}


// @SpringBootApplication
// @MapperScan("com.tyl.system.mapper")
// public class TylApplication implements CommandLineRunner {

//     // @Autowired
//     // private SysUserMapper userMapper;

//     private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

//     public static void main(String[] args) {
//         SpringApplication.run(TylApplication.class, args);
//     }

//     // @Override
//     // public void run(String... args) {
//     //     // 密码123456，运行时动态生成BCrypt哈希
//     //     String pwd = passwordEncoder.encode("123456");

//     //     SysUser existingUser = userMapper.selectOne(
//     //             new LambdaQueryWrapper<SysUser>().eq(SysUser::getUsername, "admin")
//     //     );

//     //     if (existingUser == null) {
//     //         SysUser user = new SysUser();
//     //         user.setUsername("admin");
//     //         user.setPassword(pwd);
//     //         user.setNickname("管理员");
//     //         user.setDeleted(0);
//     //         userMapper.insert(user);
//     //     } else {
//     //         // admin已存在：更新密码为正确的BCrypt哈希，覆盖之前任何错误值
//     //         existingUser.setPassword(pwd);
//     //         userMapper.updateById(existingUser);
//     //     }
//     // }
// }
