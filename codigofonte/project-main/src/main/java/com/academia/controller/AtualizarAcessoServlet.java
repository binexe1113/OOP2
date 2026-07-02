package com.academia.controller;

import com.academia.util.DbConnection;
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
import java.sql.SQLException;

@WebServlet("/api/atualizar-acesso")
public class AtualizarAcessoServlet extends HttpServlet {
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JsonObject jsonResponse = new JsonObject();

        String idUsuarioStr = request.getParameter("idUsuario");
        String novoNivel = request.getParameter("nivel");

        if (idUsuarioStr == null || novoNivel == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Parâmetros inválidos.");
            response.getWriter().write(gson.toJson(jsonResponse));
            return;
        }

        try {
            int idUsuario = Integer.parseInt(idUsuarioStr);
            boolean atualizado = atualizarNivelAcesso(idUsuario, novoNivel.toUpperCase());

            if (atualizado) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Nível de acesso atualizado com sucesso!");
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Usuário não encontrado.");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "ID do usuário inválido.");
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Erro no banco de dados: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(jsonResponse));
    }

    private boolean atualizarNivelAcesso(int idUsuario, String novoNivel) throws SQLException {
        String sql = "UPDATE Usuario SET role = ? WHERE idUsuario = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, novoNivel);
            ps.setInt(2, idUsuario);
            return ps.executeUpdate() > 0;
        }
    }
}
