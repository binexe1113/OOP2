package com.academia.util;

import org.apache.commons.codec.digest.DigestUtils;

public class SecurityUtil {
    public static String hashPassword(String password) {
        return DigestUtils.sha256Hex(password); // Retorna o hash em SHA-256
    }
}
