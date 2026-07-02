package com.academia.controller;

import com.academia.util.DbConnection;
import com.academia.util.EmailService;
import com.academia.util.SecurityUtil;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;

@WebServlet("/api/cadastro")
public class CadastroServlet extends HttpServlet {
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JsonObject jsonResponse = new JsonObject();

        try {
            // 1. Ler o JSON enviado pelo formulário do front-end
            JsonObject data = gson.fromJson(request.getReader(), JsonObject.class);
            String email = data.get("email").getAsString();
            String senha = data.get("senha").getAsString();
            String role = data.get("role").getAsString().toUpperCase();

            String senhaCriptografada = SecurityUtil.hashPassword(senha);
            String tokenValidacao = UUID.randomUUID().toString();

            boolean cadastradoComSucesso = false;

            if ("ALUNO".equals(role)) {
                // Obter campos obrigatórios do Aluno
                String nome = data.get("nome").getAsString();
                String cpf = data.get("cpf").getAsString();
                int idade = data.get("idade").getAsInt();
                String telefone = data.get("telefone").getAsString();
                int idPlano = data.get("idPlano").getAsInt();

                cadastradoComSucesso = cadastrarAluno(email, senhaCriptografada, tokenValidacao, nome, cpf, idade, telefone, idPlano);
            } else {
                // Cadastro simples de Usuario para outros tipos de perfil
                cadastradoComSucesso = cadastrarUsuarioSimples(email, senhaCriptografada, role, tokenValidacao);
            }

            if (cadastradoComSucesso) {
                // Enviar o e-mail de ativação via Mailtrap
                try {
                    EmailService.enviarEmailAtivacao(email, tokenValidacao, request.getContextPath());
                    jsonResponse.addProperty("sucesso", true);
                    jsonResponse.addProperty("mensagem", "Cadastro realizado com sucesso! Verifique seu e-mail para ativar sua conta.");
                } catch (Exception mailError) {
                    jsonResponse.addProperty("sucesso", true);
                    jsonResponse.addProperty("mensagem", "Cadastro efetuado, mas falhou ao enviar o e-mail: " + mailError.getMessage());
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                jsonResponse.addProperty("sucesso", false);
                jsonResponse.addProperty("mensagem", "Não foi possível realizar o cadastro.");
            }

        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.addProperty("sucesso", false);
            jsonResponse.addProperty("mensagem", "E-mail ou CPF de cadastro já está em uso ou erro no banco: " + e.getMessage());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse.addProperty("sucesso", false);
            jsonResponse.addProperty("mensagem", "Parâmetros inválidos: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(jsonResponse));
    }

    private boolean cadastrarAluno(String email, String senhaHash, String token, String nome, String cpf, int idade, String telefone, int idPlano) throws SQLException {
        Connection conn = null;
        try {
            conn = DbConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Inserir na tabela Usuario
            String sqlUser = "INSERT INTO Usuario (emailLogin, hashSenha, role, status_conta, token_recuperacao) VALUES (?, ?, 'ALUNO', false, ?)";
            int idUsuario = 0;
            try (PreparedStatement psUser = conn.prepareStatement(sqlUser, PreparedStatement.RETURN_GENERATED_KEYS)) {
                psUser.setString(1, email);
                psUser.setString(2, senhaHash);
                psUser.setString(3, token);
                psUser.executeUpdate();
                try (ResultSet rs = psUser.getGeneratedKeys()) {
                    if (rs.next()) {
                        idUsuario = rs.getInt(1);
                    }
                }
            }

            // 2. Inserir na tabela Matricula (padrão de 6 meses ativos)
            String sqlMatr = "INSERT INTO Matricula (dataInicio, dataFim, status, idPlano) VALUES (CURDATE(), DATE_ADD(CURDATE(), INTERVAL 6 MONTH), true, ?)";
            int idMatricula = 0;
            try (PreparedStatement psMatr = conn.prepareStatement(sqlMatr, PreparedStatement.RETURN_GENERATED_KEYS)) {
                psMatr.setInt(1, idPlano);
                psMatr.executeUpdate();
                try (ResultSet rs = psMatr.getGeneratedKeys()) {
                    if (rs.next()) {
                        idMatricula = rs.getInt(1);
                    }
                }
            }

            // 3. Inserir na tabela Aluno
            String sqlAluno = "INSERT INTO Aluno (nome, cpf, idade, email, telefone, idMatricula, idUsuario) VALUES (?, ?, ?, ?, ?, ?, ?)";
            int idAluno = 0;
            try (PreparedStatement psAluno = conn.prepareStatement(sqlAluno, PreparedStatement.RETURN_GENERATED_KEYS)) {
                psAluno.setString(1, nome);
                psAluno.setString(2, cpf);
                psAluno.setInt(3, idade);
                psAluno.setString(4, email);
                psAluno.setString(5, telefone);
                psAluno.setInt(6, idMatricula);
                psAluno.setInt(7, idUsuario);
                psAluno.executeUpdate();
                try (ResultSet rs = psAluno.getGeneratedKeys()) {
                    if (rs.next()) {
                        idAluno = rs.getInt(1);
                    }
                }
            }

            // 4. Vincular Aluno à Academia padrão (ID 1)
            String sqlAcad = "INSERT INTO Academia_Aluno (idAcademia, idAluno) VALUES (1, ?)";
            try (PreparedStatement psAcad = conn.prepareStatement(sqlAcad)) {
                psAcad.setInt(1, idAluno);
                psAcad.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException rollbackEx) { rollbackEx.printStackTrace(); }
            }
            throw e;
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (SQLException closeEx) { closeEx.printStackTrace(); }
            }
        }
    }

    private boolean cadastrarUsuarioSimples(String email, String senhaHash, String role, String token) throws SQLException {
        String sql = "INSERT INTO Usuario (emailLogin, hashSenha, role, status_conta, token_recuperacao) VALUES (?, ?, ?, false, ?)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, senhaHash);
            ps.setString(3, role);
            ps.setString(4, token);
            return ps.executeUpdate() > 0;
        }
    }
}
