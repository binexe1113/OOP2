package com.academia.dao;

import com.academia.model.Plano;
import com.academia.util.DbConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PlanoDAO {

    public List<Plano> listarTodos() throws SQLException {
        List<Plano> planos = new ArrayList<>();
        String sql = "SELECT * FROM Plano";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                planos.add(mapRow(rs));
            }
        }
        return planos;
    }

    public Plano buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM Plano WHERE idPlano = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public boolean criar(Plano p) throws SQLException {
        String sql = "INSERT INTO Plano (nome, preco, descricao, status) VALUES (?, ?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, p.getNome());
            ps.setDouble(2, p.getPreco());
            ps.setString(3, p.getDescricao());
            ps.setBoolean(4, p.isStatus());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        p.setIdPlano(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    public boolean atualizar(Plano p) throws SQLException {
        String sql = "UPDATE Plano SET nome = ?, preco = ?, descricao = ?, status = ? WHERE idPlano = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getNome());
            ps.setDouble(2, p.getPreco());
            ps.setString(3, p.getDescricao());
            ps.setBoolean(4, p.isStatus());
            ps.setInt(5, p.getIdPlano());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deletar(int id) throws SQLException {
        String sql = "DELETE FROM Plano WHERE idPlano = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    private Plano mapRow(ResultSet rs) throws SQLException {
        Plano p = new Plano();
        p.setIdPlano(rs.getInt("idPlano"));
        p.setNome(rs.getString("nome"));
        p.setPreco(rs.getDouble("preco"));
        p.setDescricao(rs.getString("descricao"));
        p.setStatus(rs.getBoolean("status"));
        return p;
    }
}
