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
import java.sql.SQLException;

@WebServlet("/api/atualizar-perfil")
public class AtualizarPerfilServlet extends HttpServlet {
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JsonObject jsonResponse = new JsonObject();

        HttpSession session = request.getSession(false);
        Usuario usuarioLogado = (session != null) ? (Usuario) session.getAttribute("usuarioLogado") : null;

        if (usuarioLogado == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            jsonResponse.addProperty("sucesso", false);
            jsonResponse.addProperty("mensagem", "Usuário não autenticado.");
            response.getWriter().write(gson.toJson(jsonResponse));
            return;
        }

        try {
            JsonObject data = gson.fromJson(request.getReader(), JsonObject.class);
            String novoEmail = data.has("email") ? data.get("email").getAsString() : null;

            Connection conn = null;
            try {
                conn = DbConnection.getConnection();
                conn.setAutoCommit(false);

                // 1. Atualizar dados na tabela Usuario (apenas e-mail)
                if (novoEmail != null && !novoEmail.trim().isEmpty()) {
                    String sqlUser = "UPDATE Usuario SET emailLogin = ? WHERE idUsuario = ?";
                    try (PreparedStatement psUser = conn.prepareStatement(sqlUser)) {
                        psUser.setString(1, novoEmail);
                        psUser.setInt(2, usuarioLogado.getIdUsuario());
                        psUser.executeUpdate();
                    }
                    usuarioLogado.setEmailLogin(novoEmail);
                }

                // 2. Atualizar dados específicos por perfil (excluindo CPF e Senha de alteração direta)
                if ("ALUNO".equalsIgnoreCase(usuarioLogado.getRole())) {
                    String nome = data.get("nome").getAsString();
                    int idade = data.get("idade").getAsInt();
                    String telefone = data.get("telefone").getAsString();

                    String sqlAluno = "UPDATE Aluno SET nome = ?, idade = ?, telefone = ?, email = ? WHERE idUsuario = ?";
                    try (PreparedStatement psAluno = conn.prepareStatement(sqlAluno)) {
                        psAluno.setString(1, nome);
                        psAluno.setInt(2, idade);
                        psAluno.setString(3, telefone);
                        psAluno.setString(4, novoEmail != null ? novoEmail : usuarioLogado.getEmailLogin());
                        psAluno.setInt(5, usuarioLogado.getIdUsuario());
                        psAluno.executeUpdate();
                    }
                } else if ("FUNCIONARIO".equalsIgnoreCase(usuarioLogado.getRole()) || "GERENTE".equalsIgnoreCase(usuarioLogado.getRole())) {
                    String nome = data.get("nome").getAsString();

                    String sqlFunc = "UPDATE Funcionario SET nome = ? WHERE idUsuario = ?";
                    try (PreparedStatement psFunc = conn.prepareStatement(sqlFunc)) {
                        psFunc.setString(1, nome);
                        psFunc.setInt(2, usuarioLogado.getIdUsuario());
                        psFunc.executeUpdate();
                    }
                }

                conn.commit();
                
                // Atualizar o usuário logado na sessão
                session.setAttribute("usuarioLogado", usuarioLogado);

                jsonResponse.addProperty("sucesso", true);
                jsonResponse.addProperty("mensagem", "Dados atualizados com sucesso!");

            } catch (SQLException e) {
                if (conn != null) {
                    try { conn.rollback(); } catch (SQLException ex) {}
                }
                throw e;
            } finally {
                if (conn != null) {
                    try { conn.close(); } catch (SQLException ex) {}
                }
            }

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse.addProperty("sucesso", false);
            jsonResponse.addProperty("mensagem", "Erro ao atualizar dados: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(jsonResponse));
    }
}
