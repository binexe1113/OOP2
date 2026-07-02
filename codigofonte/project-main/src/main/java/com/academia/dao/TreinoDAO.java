package com.academia.dao;

import com.academia.model.Treino;
import com.academia.util.DbConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TreinoDAO {

    public List<Treino> listarTodos() throws SQLException {
        List<Treino> treinos = new ArrayList<>();
        String sql = "SELECT t.* FROM Treino t";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                treinos.add(mapRow(rs));
            }
        }
        return treinos;
    }

    public Treino buscarPorAluno(int idAluno) throws SQLException {
        String sql = "SELECT t.* FROM Treino t WHERE t.idAluno = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAluno);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public boolean criar(Treino t, int idAluno) throws SQLException {
        String sql = "INSERT INTO Treino (descricao, dataInicio, idAluno) VALUES (?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, t.getDescricao());
            ps.setDate(2, new java.sql.Date(t.getDataInicio().getTime()));
            ps.setInt(3, idAluno);

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        t.setIdTreino(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    public boolean atualizar(Treino t, int idAluno) throws SQLException {
        String sql = "UPDATE Treino SET descricao = ?, dataInicio = ?, idAluno = ? WHERE idTreino = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, t.getDescricao());
            ps.setDate(2, new java.sql.Date(t.getDataInicio().getTime()));
            ps.setInt(3, idAluno);
            ps.setInt(4, t.getIdTreino());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deletar(int id) throws SQLException {
        String sql = "DELETE FROM Treino WHERE idTreino = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    private Treino mapRow(ResultSet rs) throws SQLException {
        Treino t = new Treino();
        t.setIdTreino(rs.getInt("idTreino"));
        t.setDescricao(rs.getString("descricao"));
        t.setDataInicio(rs.getDate("dataInicio"));
        t.setDataFim(null);
        t.setProfessor(null);
        return t;
    }
}
