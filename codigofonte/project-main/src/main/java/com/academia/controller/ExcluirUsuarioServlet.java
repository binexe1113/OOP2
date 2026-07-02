package com.academia.controller;

import com.academia.util.DbConnection;
import com.academia.model.Usuario;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/api/excluir-usuario")
public class ExcluirUsuarioServlet extends HttpServlet {
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JsonObject jsonResponse = new JsonObject();

        HttpSession session = request.getSession(false);
        Usuario usuarioLogado = (session != null) ? (Usuario) session.getAttribute("usuarioLogado") : null;

        if (usuarioLogado == null || !"GERENTE".equalsIgnoreCase(usuarioLogado.getRole())) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Acesso negado: apenas gerentes podem excluir usuários.");
            response.getWriter().write(gson.toJson(jsonResponse));
            return;
        }

        String idUsuarioStr = request.getParameter("idUsuario");
        if (idUsuarioStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Parâmetro idUsuario não informado.");
            response.getWriter().write(gson.toJson(jsonResponse));
            return;
        }

        try {
            int idUsuario = Integer.parseInt(idUsuarioStr);

            // Impedir que o gerente logado exclua a si mesmo
            if (idUsuario == usuarioLogado.getIdUsuario()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Ação inválida: você não pode excluir a si mesmo.");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            Connection conn = null;
            try {
                conn = DbConnection.getConnection();
                conn.setAutoCommit(false);

                // 1. Verificar se é Aluno ou Funcionário
                int idMatricula = -1;
                String sqlSelectAluno = "SELECT idMatricula FROM Aluno WHERE idUsuario = ?";
                try (PreparedStatement psSelect = conn.prepareStatement(sqlSelectAluno)) {
                    psSelect.setInt(1, idUsuario);
                    try (ResultSet rs = psSelect.executeQuery()) {
                        if (rs.next()) {
                            idMatricula = rs.getInt("idMatricula");
                        }
                    }
                }

                boolean isFuncionario = false;
                String sqlSelectFunc = "SELECT idfunc FROM Funcionario WHERE idUsuario = ?";
                try (PreparedStatement psSelect = conn.prepareStatement(sqlSelectFunc)) {
                    psSelect.setInt(1, idUsuario);
                    try (ResultSet rs = psSelect.executeQuery()) {
                        if (rs.next()) {
                            isFuncionario = true;
                        }
                    }
                }

                if (idMatricula != -1) {
                    // É Aluno:
                    // Deletar da tabela Aluno
                    String sqlDelAluno = "DELETE FROM Aluno WHERE idUsuario = ?";
                    try (PreparedStatement psDelAluno = conn.prepareStatement(sqlDelAluno)) {
                        psDelAluno.setInt(1, idUsuario);
                        psDelAluno.executeUpdate();
                    }

                    // Deletar da tabela Matricula
                    String sqlDelMatricula = "DELETE FROM Matricula WHERE idMatricula = ?";
                    try (PreparedStatement psDelMatricula = conn.prepareStatement(sqlDelMatricula)) {
                        psDelMatricula.setInt(1, idMatricula);
                        psDelMatricula.executeUpdate();
                    }
                } else if (isFuncionario) {
                    // É Funcionário/Gerente:
                    // Deletar da tabela Funcionario (Cascateia para Gerente e Recepcionista)
                    String sqlDelFunc = "DELETE FROM Funcionario WHERE idUsuario = ?";
                    try (PreparedStatement psDelFunc = conn.prepareStatement(sqlDelFunc)) {
                        psDelFunc.setInt(1, idUsuario);
                        psDelFunc.executeUpdate();
                    }
                }

                // Deletar da tabela Usuario
                String sqlDelUser = "DELETE FROM Usuario WHERE idUsuario = ?";
                try (PreparedStatement psDelUser = conn.prepareStatement(sqlDelUser)) {
                    psDelUser.setInt(1, idUsuario);
                    psDelUser.executeUpdate();
                }

                conn.commit();
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Usuário excluído com sucesso!");

            } catch (SQLException e) {
                if (conn != null) {
                    try { conn.rollback(); } catch (SQLException ex) {}
                }
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Erro ao excluir usuário: " + e.getMessage());
            } finally {
                if (conn != null) {
                    try { conn.close(); } catch (SQLException e) {}
                }
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "ID do usuário inválido.");
        }

        response.getWriter().write(gson.toJson(jsonResponse));
    }
}
