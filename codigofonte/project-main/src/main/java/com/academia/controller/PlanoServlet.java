package com.academia.controller;

import com.academia.dao.PlanoDAO;
import com.academia.model.Plano;
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
import java.sql.SQLException;

@WebServlet("/api/plano")
public class PlanoServlet extends HttpServlet {
    private final PlanoDAO planoDAO = new PlanoDAO();
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
            jsonResponse.addProperty("sucesso", false);
            jsonResponse.addProperty("mensagem", "Acesso negado: apenas gerentes podem gerenciar planos.");
            response.getWriter().write(gson.toJson(jsonResponse));
            return;
        }

        try {
            JsonObject data = gson.fromJson(request.getReader(), JsonObject.class);
            String acao = data.has("acao") ? data.get("acao").getAsString() : "criar";

            if ("criar".equalsIgnoreCase(acao)) {
                String nome = data.get("nome").getAsString();
                double preco = data.get("preco").getAsDouble();
                String descricao = data.has("descricao") ? data.get("descricao").getAsString() : "";
                boolean status = data.has("status") ? data.get("status").getAsBoolean() : true;

                Plano p = new Plano();
                p.setNome(nome);
                p.setPreco(preco);
                p.setDescricao(descricao);
                p.setStatus(status);

                boolean sucesso = planoDAO.criar(p);
                if (sucesso) {
                    jsonResponse.addProperty("sucesso", true);
                    jsonResponse.addProperty("mensagem", "Plano cadastrado com sucesso!");
                } else {
                    jsonResponse.addProperty("sucesso", false);
                    jsonResponse.addProperty("mensagem", "Erro ao cadastrar plano no banco.");
                }
            } else if ("editar".equalsIgnoreCase(acao)) {
                int idPlano = data.get("idPlano").getAsInt();
                String nome = data.get("nome").getAsString();
                double preco = data.get("preco").getAsDouble();
                String descricao = data.has("descricao") ? data.get("descricao").getAsString() : "";
                boolean status = data.has("status") ? data.get("status").getAsBoolean() : true;

                Plano p = planoDAO.buscarPorId(idPlano);
                if (p == null) {
                    jsonResponse.addProperty("sucesso", false);
                    jsonResponse.addProperty("mensagem", "Plano não encontrado.");
                } else {
                    p.setNome(nome);
                    p.setPreco(preco);
                    p.setDescricao(descricao);
                    p.setStatus(status);

                    boolean sucesso = planoDAO.atualizar(p);
                    if (sucesso) {
                        jsonResponse.addProperty("sucesso", true);
                        jsonResponse.addProperty("mensagem", "Plano atualizado com sucesso!");
                    } else {
                        jsonResponse.addProperty("sucesso", false);
                        jsonResponse.addProperty("mensagem", "Erro ao atualizar plano no banco.");
                    }
                }
            } else if ("excluir".equalsIgnoreCase(acao)) {
                int idPlano = data.get("idPlano").getAsInt();
                boolean sucesso = planoDAO.deletar(idPlano);
                if (sucesso) {
                    jsonResponse.addProperty("sucesso", true);
                    jsonResponse.addProperty("mensagem", "Plano excluído com sucesso!");
                } else {
                    jsonResponse.addProperty("sucesso", false);
                    jsonResponse.addProperty("mensagem", "Erro ao excluir plano no banco.");
                }
            } else {
                jsonResponse.addProperty("sucesso", false);
                jsonResponse.addProperty("mensagem", "Ação inválida.");
            }

        } catch (SQLException e) {
            // Trata restrições de integridade referencial de forma amigável
            if (e.getErrorCode() == 1451 || e.getMessage().contains("Cannot delete or update a parent row")) {
                jsonResponse.addProperty("sucesso", false);
                jsonResponse.addProperty("mensagem", "Não é possível excluir este plano pois existem matrículas ativas vinculadas a ele. Experimente inativar o plano nas opções.");
            } else {
                jsonResponse.addProperty("sucesso", false);
                jsonResponse.addProperty("mensagem", "Erro no banco de dados: " + e.getMessage());
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse.addProperty("sucesso", false);
            jsonResponse.addProperty("mensagem", "Erro ao processar requisição: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(jsonResponse));
    }
}
