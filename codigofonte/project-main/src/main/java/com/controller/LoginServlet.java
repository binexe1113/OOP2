package com.academia.controller;

import com.academia.dao.UsuarioDAO;
import com.academia.model.Usuario;
import com.academia.util.SecurityUtil;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/api/login")
public class LoginServlet extends HttpServlet {
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Define que a resposta será do tipo JSON e com caracteres UTF-8
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JsonObject jsonResponse = new JsonObject();

        try {
            // 1. Ler o JSON enviado pelo corpo da requisição do jQuery AJAX
            JsonObject data = gson.fromJson(request.getReader(), JsonObject.class);
            String email = data.get("email").getAsString();
            String senha = data.get("senha").getAsString();

            // 2. Hashear a senha digitada usando SHA-256 (via Apache Commons Codec)
            String senhaHasheada = SecurityUtil.hashPassword(senha);

            // 3. Chamar a autenticação direta do UsuarioDAO
            Usuario usuario = usuarioDAO.login(email, senhaHasheada);

            if (usuario != null) {
                // 4. Verificar se a conta do usuário está ativada por e-mail
                if (!usuario.isStatus_conta()) {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN); // HTTP 403
                    jsonResponse.addProperty("sucesso", false);
                    jsonResponse.addProperty("mensagem", "Sua conta ainda não foi ativada por e-mail.");
                } else {
                    // 5. Se estiver ativado, cria uma sessão e guarda o usuário nela
                    HttpSession session = request.getSession();
                    session.setAttribute("usuarioLogado", usuario);

                    jsonResponse.addProperty("sucesso", true);
                    jsonResponse.addProperty("role", usuario.getRole());
                    jsonResponse.addProperty("mensagem", "Login efetuado com sucesso!");
                }
            } else {
                // Usuário não encontrado ou senha errada
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // HTTP 401
                jsonResponse.addProperty("sucesso", false);
                jsonResponse.addProperty("mensagem", "E-mail ou senha inválidos.");
            }

        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // HTTP 500
            jsonResponse.addProperty("sucesso", false);
            jsonResponse.addProperty("mensagem", "Erro ao acessar o banco de dados: " + e.getMessage());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // HTTP 400
            jsonResponse.addProperty("sucesso", false);
            jsonResponse.addProperty("mensagem", "Requisição inválida.");
        }

        // Escreve a resposta JSON de volta para o frontend
        response.getWriter().write(gson.toJson(jsonResponse));
    }
}
