package com.academia.dao;

import com.academia.model.Professor;
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
        String sql = "SELECT t.*, prof.nome AS prof_nome, prof.cpf AS prof_cpf, prof.email AS prof_email, " +
                     "prof.telefone AS prof_telefone, prof.valorHoraAula AS prof_valorHora " +
                     "FROM Treino t " +
                     "INNER JOIN Professor prof ON t.idProfessor = prof.idProfessor";
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
        String sql = "SELECT t.*, prof.nome AS prof_nome, prof.cpf AS prof_cpf, prof.email AS prof_email, " +
                     "prof.telefone AS prof_telefone, prof.valorHoraAula AS prof_valorHora " +
                     "FROM Treino t " +
                     "INNER JOIN Professor prof ON t.idProfessor = prof.idProfessor " +
                     "WHERE t.idAluno = ?";
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
        String sql = "INSERT INTO Treino (descricao, dataInicio, dataFim, idAluno, idProfessor) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, t.getDescricao());
            ps.setDate(2, new java.sql.Date(t.getDataInicio().getTime()));
            ps.setDate(3, new java.sql.Date(t.getDataFim().getTime()));
            ps.setInt(4, idAluno);
            ps.setInt(5, t.getProfessor().getIdProfessor());

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
        String sql = "UPDATE Treino SET descricao = ?, dataInicio = ?, dataFim = ?, idAluno = ?, idProfessor = ? WHERE idTreino = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, t.getDescricao());
            ps.setDate(2, new java.sql.Date(t.getDataInicio().getTime()));
            ps.setDate(3, new java.sql.Date(t.getDataFim().getTime()));
            ps.setInt(4, idAluno);
            ps.setInt(5, t.getProfessor().getIdProfessor());
            ps.setInt(6, t.getIdTreino());
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
        Professor prof = new Professor();
        prof.setIdProfessor(rs.getInt("idProfessor"));
        prof.setNome(rs.getString("prof_nome"));
        prof.setCpf(rs.getString("prof_cpf"));
        prof.setEmail(rs.getString("prof_email"));
        prof.setTelefone(rs.getString("prof_telefone"));
        prof.setValorHoraAula(rs.getDouble("prof_valorHora"));

        Treino t = new Treino();
        t.setIdTreino(rs.getInt("idTreino"));
        t.setDescricao(rs.getString("descricao"));
        t.setDataInicio(rs.getDate("dataInicio"));
        t.setDataFim(rs.getDate("dataFim"));
        t.setProfessor(prof);
        return t;
    }
}
