package com.academia.dao;

import com.academia.model.Aluno;
import com.academia.model.Matricula;
import com.academia.model.Plano;
import com.academia.model.Usuario;
import com.academia.util.DbConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AlunoDAO {

    public List<Aluno> listarTodos() throws SQLException {
        List<Aluno> alunos = new ArrayList<>();
        String sql = "SELECT a.*, " +
                     "m.dataInicio, m.dataFim, m.status AS matricula_status, " +
                     "p.idPlano, p.nome AS plano_nome, p.preco AS plano_preco, p.descricao AS plano_descricao, p.status AS plano_status, " +
                     "u.emailLogin, u.hashSenha, u.role, u.status_conta, u.token_recuperacao, u.data_criacao " +
                     "FROM Aluno a " +
                     "INNER JOIN Matricula m ON a.idMatricula = m.idMatricula " +
                     "INNER JOIN Plano p ON m.idPlano = p.idPlano " +
                     "LEFT JOIN Usuario u ON a.idUsuario = u.idUsuario";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                alunos.add(mapRow(rs));
            }
        }
        return alunos;
    }

    public Aluno buscarPorCpf(String cpf) throws SQLException {
        String sql = "SELECT a.*, " +
                     "m.dataInicio, m.dataFim, m.status AS matricula_status, " +
                     "p.idPlano, p.nome AS plano_nome, p.preco AS plano_preco, p.descricao AS plano_descricao, p.status AS plano_status, " +
                     "u.emailLogin, u.hashSenha, u.role, u.status_conta, u.token_recuperacao, u.data_criacao " +
                     "FROM Aluno a " +
                     "INNER JOIN Matricula m ON a.idMatricula = m.idMatricula " +
                     "INNER JOIN Plano p ON m.idPlano = p.idPlano " +
                     "LEFT JOIN Usuario u ON a.idUsuario = u.idUsuario " +
                     "WHERE a.cpf = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, cpf);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public Aluno buscarPorIdUsuario(int idUsuario) throws SQLException {
        String sql = "SELECT a.*, " +
                     "m.dataInicio, m.dataFim, m.status AS matricula_status, " +
                     "p.idPlano, p.nome AS plano_nome, p.preco AS plano_preco, p.descricao AS plano_descricao, p.status AS plano_status, " +
                     "u.emailLogin, u.hashSenha, u.role, u.status_conta, u.token_recuperacao, u.data_criacao " +
                     "FROM Aluno a " +
                     "INNER JOIN Matricula m ON a.idMatricula = m.idMatricula " +
                     "INNER JOIN Plano p ON m.idPlano = p.idPlano " +
                     "LEFT JOIN Usuario u ON a.idUsuario = u.idUsuario " +
                     "WHERE a.idUsuario = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public boolean criar(Aluno a) throws SQLException {
        String sql = "INSERT INTO Aluno (nome, cpf, idade, email, telefone, idMatricula, idUsuario) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, a.getNome());
            ps.setString(2, a.getCpf());
            ps.setInt(3, a.getIdade());
            ps.setString(4, a.getEmail());
            ps.setString(5, a.getTelefone());
            ps.setInt(6, a.getMatricula().getIdMatricula());
            if (a.getUsuario() != null) {
                ps.setInt(7, a.getUsuario().getIdUsuario());
            } else {
                ps.setNull(7, Types.INTEGER);
            }

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        a.setIdAluno(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    public boolean atualizar(Aluno a) throws SQLException {
        String sql = "UPDATE Aluno SET nome = ?, cpf = ?, idade = ?, email = ?, telefone = ?, idMatricula = ?, idUsuario = ? WHERE idAluno = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, a.getNome());
            ps.setString(2, a.getCpf());
            ps.setInt(3, a.getIdade());
            ps.setString(4, a.getEmail());
            ps.setString(5, a.getTelefone());
            ps.setInt(6, a.getMatricula().getIdMatricula());
            if (a.getUsuario() != null) {
                ps.setInt(7, a.getUsuario().getIdUsuario());
            } else {
                ps.setNull(7, Types.INTEGER);
            }
            ps.setInt(8, a.getIdAluno());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deletar(int id) throws SQLException {
        String sql = "DELETE FROM Aluno WHERE idAluno = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    private Aluno mapRow(ResultSet rs) throws SQLException {
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
        m.setStatus(rs.getBoolean("matricula_status"));
        m.setPlano(p);

        Usuario u = null;
        int idUsuario = rs.getInt("idUsuario");
        if (!rs.wasNull()) {
            u = new Usuario();
            u.setIdUsuario(idUsuario);
            u.setEmailLogin(rs.getString("emailLogin"));
            u.setHashSenha(rs.getString("hashSenha"));
            u.setRole(rs.getString("role"));
            u.setStatus_conta(rs.getBoolean("status_conta"));
            u.setToken_recuperacao(rs.getString("token_recuperacao"));
            u.setData_criacao(rs.getTimestamp("data_criacao"));
        }

        Aluno a = new Aluno();
        a.setIdAluno(rs.getInt("idAluno"));
        a.setNome(rs.getString("nome"));
        a.setCpf(rs.getString("cpf"));
        a.setIdade(rs.getInt("idade"));
        a.setEmail(rs.getString("email"));
        a.setTelefone(rs.getString("telefone"));
        a.setMatricula(m);
        a.setUsuario(u);
        return a;
    }
}
