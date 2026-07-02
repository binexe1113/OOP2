package com.academia.controller;

import com.academia.dao.UsuarioDAO;
import com.academia.model.Usuario;
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

@WebServlet("/api/cadastro")
public class CadastroServlet extends HttpServlet {
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
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
            String role = data.get("role").getAsString(); // Ex: "ALUNO" ou "RECEPCIONISTA"

            // 2. Criptografar a senha com SHA-256 determinístico
            String senhaCriptografada = SecurityUtil.hashPassword(senha);

            // 3. Gerar um token UUID único para validação por e-mail
            String tokenValidacao = UUID.randomUUID().toString();

            // 4. Montar o objeto Usuario
            Usuario usuario = new Usuario();
            usuario.setEmailLogin(email);
            usuario.setHashSenha(senhaCriptografada);
            usuario.setRole(role.toUpperCase());
            usuario.setStatus_conta(false); // Fica INATIVO até validar o e-mail
            usuario.setToken_recuperacao(tokenValidacao); // Usando a coluna token_recuperacao para fins de ativação

            // 5. Salvar usuário no Banco
            boolean salvo = usuarioDAO.criar(usuario);

            if (salvo) {
                // 6. Enviar o e-mail de ativação via Mailtrap
                try {
                    EmailService.enviarEmailAtivacao(email, tokenValidacao, request.getContextPath());
                    jsonResponse.addProperty("sucesso", true);
                    jsonResponse.addProperty("mensagem", "Cadastro realizado com sucesso! Verifique seu e-mail para ativar sua conta.");
                } catch (Exception mailError) {
                    // Se falhar o envio de e-mail, informa no JSON mas mantém o registro no banco
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
            jsonResponse.addProperty("mensagem", "E-mail de cadastro já está em uso ou erro no banco.");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse.addProperty("sucesso", false);
            jsonResponse.addProperty("mensagem", "Parâmetros inválidos.");
        }

        response.getWriter().write(gson.toJson(jsonResponse));
    }
}
