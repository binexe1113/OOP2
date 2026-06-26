package com.academia.dao;

import com.academia.model.Matricula;
import com.academia.model.Plano;
import com.academia.util.DbConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MatriculaDAO {

    public List<Matricula> listarTodos() throws SQLException {
        List<Matricula> matriculas = new ArrayList<>();
        String sql = "SELECT m.*, p.nome AS plano_nome, p.preco AS plano_preco, p.descricao AS plano_descricao, p.status AS plano_status " +
                     "FROM Matricula m " +
                     "INNER JOIN Plano p ON m.idPlano = p.idPlano";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                matriculas.add(mapRow(rs));
            }
        }
        return matriculas;
    }

    public Matricula buscarPorId(int id) throws SQLException {
        String sql = "SELECT m.*, p.nome AS plano_nome, p.preco AS plano_preco, p.descricao AS plano_descricao, p.status AS plano_status " +
                     "FROM Matricula m " +
                     "INNER JOIN Plano p ON m.idPlano = p.idPlano " +
                     "WHERE m.idMatricula = ?";
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

    public boolean criar(Matricula m) throws SQLException {
        String sql = "INSERT INTO Matricula (dataInicio, dataFim, status, idPlano) VALUES (?, ?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setDate(1, new java.sql.Date(m.getDataInicio().getTime()));
            ps.setDate(2, new java.sql.Date(m.getDataFim().getTime()));
            ps.setBoolean(3, m.isStatus());
            ps.setInt(4, m.getPlano().getIdPlano());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        m.setIdMatricula(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    public boolean atualizar(Matricula m) throws SQLException {
        String sql = "UPDATE Matricula SET dataInicio = ?, dataFim = ?, status = ?, idPlano = ? WHERE idMatricula = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, new java.sql.Date(m.getDataInicio().getTime()));
            ps.setDate(2, new java.sql.Date(m.getDataFim().getTime()));
            ps.setBoolean(3, m.isStatus());
            ps.setInt(4, m.getPlano().getIdPlano());
            ps.setInt(5, m.getIdMatricula());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deletar(int id) throws SQLException {
        String sql = "DELETE FROM Matricula WHERE idMatricula = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    private Matricula mapRow(ResultSet rs) throws SQLException {
        Plano p = new Plano();
        p.setIdPlano(rs.getInt("idPlano"));
        p.setNome(rs.getString("plano_nome"));
        p.setPreco(rs.getDouble("plano_preco"));
        p.setDescricao(rs.getString("plano_descricao"));
        p.setStatus(rs.getBoolean("plano_status"));

        Matricula m = new Matricula();
        m.setIdMatricula(rs.getInt("idMatricula"));
        m.setDataInicio(rs.getDate("dataInicio"));
        m.setDataFim(rs.getDate("dataFim"));
        m.setStatus(rs.getBoolean("status"));
        m.setPlano(p);
        return m;
    }
}
