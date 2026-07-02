package com.academia.dao;

import com.academia.util.DbConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class CheckInDAO {

    /**
     * Insere um registro de Check-in associando o Aluno e a Academia
     */
    public boolean registrar(int idAluno, int idAcademia, Integer idTreino) throws SQLException {
        String sql = "INSERT INTO CheckIn (idAluno, idAcademia) VALUES (?, ?)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAluno);
            ps.setInt(2, idAcademia);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Retorna a lista de datas e horários em que o Aluno realizou check-in
     */
    public List<Timestamp> listarDatasPorAluno(int idAluno) throws SQLException {
        List<Timestamp> checkins = new ArrayList<>();
        String sql = "SELECT dataHora FROM CheckIn WHERE idAluno = ? ORDER BY dataHora DESC";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAluno);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    checkins.add(rs.getTimestamp("dataHora"));
                }
            }
        }
        return checkins;
    }
}
