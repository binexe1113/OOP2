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
        String sql = "INSERT INTO Usuario (emailLogin, hashSenha, role, status_conta, token_recuperacao) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, u.getEmailLogin());
            ps.setString(2, u.getHashSenha());
            ps.setString(3, u.getRole());
            ps.setBoolean(4, false); // status_conta = false inicialmente
            ps.setString(5, u.getToken_recuperacao());
            
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
        String sql = "SELECT * FROM Usuario WHERE token_recuperacao = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public boolean ativarConta(int idUsuario) throws SQLException {
        String sql = "UPDATE Usuario SET status_conta = true, token_recuperacao = NULL WHERE idUsuario = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean gerarTokenRecuperacao(String email, String token) throws SQLException {
        String sql = "UPDATE Usuario SET token_recuperacao = ? WHERE emailLogin = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean redefinirSenha(String token, String hashNovaSenha) throws SQLException {
        String sql = "UPDATE Usuario SET hashSenha = ?, token_recuperacao = NULL WHERE token_recuperacao = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashNovaSenha);
            ps.setString(2, token);
            return ps.executeUpdate() > 0;
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
        u.setToken_recuperacao(rs.getString("token_recuperacao"));
        u.setData_criacao(rs.getTimestamp("data_criacao"));
        return u;
    }
}
