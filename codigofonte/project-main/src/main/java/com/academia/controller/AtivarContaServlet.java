package com.academia.controller;

import com.academia.dao.UsuarioDAO;
import com.academia.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/api/ativar")
public class AtivarContaServlet extends HttpServlet {
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Recuperar o token enviado na URL (ex: /api/ativar?token=UUID-AQUI)
        String token = request.getParameter("token");

        if (token == null || token.trim().isEmpty()) {
            // Se não houver token, redireciona com mensagem de erro
            response.sendRedirect(request.getContextPath() + "/acesso.jsp?erroAtivacao=invalido");
            return;
        }

        try {
            // 2. Buscar o usuário pelo token de ativação
            Usuario usuario = usuarioDAO.buscarPorToken(token);

            if (usuario != null) {
                // 3. Ativar a conta no banco (muda status_conta para true e limpa o token)
                boolean ativado = usuarioDAO.ativarConta(usuario.getIdUsuario());

                if (ativado) {
                    // Redireciona informando sucesso
                    response.sendRedirect(request.getContextPath() + "/acesso.jsp?ativado=true");
                } else {
                    response.sendRedirect(request.getContextPath() + "/acesso.jsp?erroAtivacao=banco");
                }
            } else {
                // Token expirado ou não encontrado
                response.sendRedirect(request.getContextPath() + "/acesso.jsp?erroAtivacao=nao_encontrado");
            }

        } catch (SQLException e) {
            response.sendRedirect(request.getContextPath() + "/acesso.jsp?erroAtivacao=db_erro");
        }
    }
}
