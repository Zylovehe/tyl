package com.tyl.system;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.tyl.system.entity.SysUser;
import com.tyl.system.mapper.SysUserMapper;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.tyl.system.mapper")
public class TylApplication implements CommandLineRunner {

    @Autowired
    private SysUserMapper userMapper;

    public static void main(String[] args) {
        SpringApplication.run(TylApplication.class,args);
    }

    @Override
    public void run(String... args) {
        // 密码123456 BCrypt加密
        String pwd="$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi";
        SysUser user=new SysUser();
        user.setUsername("admin");
        user.setPassword(pwd);
        user.setNickname("管理员");
        user.setDeleted(0);

        // 不存在admin才插入
        long count = userMapper.selectCount(
                new LambdaQueryWrapper<SysUser>().eq(SysUser::getUsername,"admin")
        );
        if(count == 0){
            userMapper.insert(user);
        }
    }
}