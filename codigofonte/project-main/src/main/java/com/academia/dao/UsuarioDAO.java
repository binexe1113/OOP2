package com.academia.dao;

import com.academia.model.Usuario;
import com.academia.util.DbConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    public Usuario login(String email, String hashSenha) throws SQLException {
        String sql = "SELECT * FROM Usuario WHERE emailLogin = ? AND hashSenha = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, hashSenha);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public boolean criar(Usuario u) throws SQLException {
        String sql = "INSERT INTO Usuario (emailLogin, hashSenha, role, status_conta) VALUES (?, ?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, u.getEmailLogin());
            ps.setString(2, u.getHashSenha());
            ps.setString(3, u.getRole());
            ps.setBoolean(4, false); // status_conta = false inicialmente
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        u.setIdUsuario(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    public Usuario buscarPorToken(String token) throws SQLException {
        try {
            // Decodifica o token stateless que contém o email usando URLDecoder seguro
            String email = new String(java.util.Base64.getUrlDecoder().decode(token.trim().getBytes(java.nio.charset.StandardCharsets.UTF_8)));
            String sql = "SELECT * FROM Usuario WHERE emailLogin = ?";
            try (Connection conn = DbConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, email);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapRow(rs);
                    }
                }
            }
        } catch (Exception ignored) {
        }
        return null;
    }

    public boolean ativarConta(int idUsuario) throws SQLException {
        String sql = "UPDATE Usuario SET status_conta = true WHERE idUsuario = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean gerarTokenRecuperacao(String email, String token) throws SQLException {
        String sql = "SELECT 1 FROM Usuario WHERE emailLogin = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean redefinirSenha(String token, String hashNovaSenha) throws SQLException {
        try {
            // Decodifica o token stateless contendo o email usando URLDecoder seguro
            String email = new String(java.util.Base64.getUrlDecoder().decode(token.trim().getBytes(java.nio.charset.StandardCharsets.UTF_8)));
            String sql = "UPDATE Usuario SET hashSenha = ? WHERE emailLogin = ?";
            try (Connection conn = DbConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, hashNovaSenha);
                ps.setString(2, email);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            return false;
        }
    }

    public boolean atualizar(Usuario u) throws SQLException {
        String sql = "UPDATE Usuario SET emailLogin = ?, role = ? WHERE idUsuario = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, u.getEmailLogin());
            ps.setString(2, u.getRole());
            ps.setInt(3, u.getIdUsuario());
            return ps.executeUpdate() > 0;
        }
    }

    private Usuario mapRow(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setIdUsuario(rs.getInt("idUsuario"));
        u.setEmailLogin(rs.getString("emailLogin"));
        u.setHashSenha(rs.getString("hashSenha"));
        u.setRole(rs.getString("role"));
        u.setStatus_conta(rs.getBoolean("status_conta"));
        u.setToken_recuperacao(null);
        u.setData_criacao(rs.getTimestamp("data_criacao"));
        return u;
    }
}
