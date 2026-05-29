package com.tyl.system.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.io.Serializable;
import java.util.List;

/**
 * 登录响应DTO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LoginResponse implements Serializable {
    
    private static final long serialVersionUID = 1L;

    private String token;
    
    private UserInfo userInfo;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class UserInfo {
        private Long id;
        private String username;
        private String realName;
        private String phone;
        private String email;
        private List<String> roles;
        private List<MenuInfo> menus;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class MenuInfo {
        private Long id;
        private Long parentId;
        private String menuName;
        private String path;
        private String component;
        private String icon;
        private Integer type;
        private String perms;
    }
}
