package com.tyl.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.tyl.system.entity.SysUser;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 用户Mapper接口
 */
@Mapper
public interface SysUserMapper extends BaseMapper<SysUser> {
    
    /**
     * 根据用户名查询用户
     */
    SysUser selectByUsername(@Param("username") String username);

    /**
     * 查询用户的角色ID列表
     */
    List<Long> selectRoleIdsByUserId(@Param("userId") Long userId);

    /**
     * 插入用户-角色关联（幂等）
     */
    int insertUserRole(@Param("userId") Long userId, @Param("roleId") Long roleId);
}
