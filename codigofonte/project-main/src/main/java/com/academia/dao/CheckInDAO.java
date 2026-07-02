package com.academia.dao;

import com.academia.util.DbConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class CheckInDAO {

    public boolean registrar(int idAluno, int idAcademia, Integer idTreino) throws SQLException {
        String sql = "INSERT INTO CheckIn (idAluno, idAcademia, idTreino) VALUES (?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAluno);
            ps.setInt(2, idAcademia);
            if (idTreino != null) {
                ps.setInt(3, idTreino);
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            return ps.executeUpdate() > 0;
        }
    }

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
