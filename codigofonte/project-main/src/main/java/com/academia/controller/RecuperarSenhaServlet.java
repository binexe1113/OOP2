package com.academia.controller;

import com.academia.dao.UsuarioDAO;
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
import java.sql.SQLException;
import java.util.UUID;

@WebServlet("/api/recuperar-senha")
public class RecuperarSenhaServlet extends HttpServlet {
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final Gson gson = new Gson();

    /**
     * ETAPA 1: Solicitar recuperação de senha (Gera o Token e envia e-mail)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JsonObject jsonResponse = new JsonObject();

        try {
            JsonObject data = gson.fromJson(request.getReader(), JsonObject.class);
            String email = data.get("email").getAsString();

            // 1. Gerar token de recuperação único
            String token = java.util.Base64.getUrlEncoder().withoutPadding().encodeToString(email.getBytes(java.nio.charset.StandardCharsets.UTF_8));

            // 2. Tentar atualizar o token do usuário correspondente no banco
            boolean tokenGerado = usuarioDAO.gerarTokenRecuperacao(email, token);

            if (tokenGerado) {
                // 3. Enviar e-mail de recuperação
                EmailService.enviarEmailRecuperacao(email, token, request.getContextPath());
                
                jsonResponse.addProperty("sucesso", true);
                jsonResponse.addProperty("mensagem", "E-mail de recuperação enviado com sucesso! Verifique sua caixa de entrada.");
            } else {
                // E-mail não encontrado no banco de dados
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                jsonResponse.addProperty("sucesso", false);
                jsonResponse.addProperty("mensagem", "E-mail não encontrado no sistema.");
            }

        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.addProperty("sucesso", false);
            jsonResponse.addProperty("mensagem", "Erro no banco de dados: " + e.getMessage());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse.addProperty("sucesso", false);
            jsonResponse.addProperty("mensagem", "Requisição inválida.");
        }

        response.getWriter().write(gson.toJson(jsonResponse));
    }

    /**
     * ETAPA 2: Redefinir a senha usando o Token recebido
     */
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JsonObject jsonResponse = new JsonObject();

        try {
            JsonObject data = gson.fromJson(request.getReader(), JsonObject.class);
            String token = data.get("token").getAsString();
            String novaSenha = data.get("novaSenha").getAsString();

            // 1. Criptografar a nova senha em SHA-256
            String novaSenhaCriptografada = SecurityUtil.hashPassword(novaSenha);

            // 2. Chamar o DAO para redefinir a senha e invalidar o token de recuperação
            boolean redefinida = usuarioDAO.redefinirSenha(token, novaSenhaCriptografada);

            if (redefinida) {
                jsonResponse.addProperty("sucesso", true);
                jsonResponse.addProperty("mensagem", "Sua senha foi redefinida com sucesso! Você já pode entrar.");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                jsonResponse.addProperty("sucesso", false);
                jsonResponse.addProperty("mensagem", "Token inválido ou expirado.");
            }

        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.addProperty("sucesso", false);
            jsonResponse.addProperty("mensagem", "Erro no banco de dados ao salvar a nova senha: " + e.getMessage());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse.addProperty("sucesso", false);
            jsonResponse.addProperty("mensagem", "Parâmetros de redefinição inválidos.");
        }

        response.getWriter().write(gson.toJson(jsonResponse));
    }
}
