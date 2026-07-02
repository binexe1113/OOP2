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
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/FuncionarioController")
public class FuncionarioServlet extends HttpServlet {
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JsonObject jsonResponse = new JsonObject();

        String acao = request.getParameter("acao");
        if ("obterTreino".equals(acao)) {
            String idAlunoStr = request.getParameter("id_aluno");
            if (idAlunoStr != null) {
                try {
                    int idAluno = Integer.parseInt(idAlunoStr);
                    List<String> blocosAtivos = obterBlocosAtivosAluno(idAluno);
                    response.getWriter().write(gson.toJson(blocosAtivos));
                    return;
                } catch (Exception e) {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", e.getMessage());
                    response.getWriter().write(gson.toJson(jsonResponse));
                    return;
                }
            }
        }
        response.getWriter().write(gson.toJson(jsonResponse));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JsonObject jsonResponse = new JsonObject();

        String acao = request.getParameter("acao");

        if (acao == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Ação não especificada.");
            response.getWriter().write(gson.toJson(jsonResponse));
            return;
        }

        try {
            if ("vincularTreino".equals(acao)) {
                String idAlunoStr = request.getParameter("id_aluno");
                String[] treinosSelecionados = request.getParameterValues("treinos");

                if (idAlunoStr == null || treinosSelecionados == null || treinosSelecionados.length == 0) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Por favor, selecione um aluno e pelo menos um bloco de treino.");
                    response.getWriter().write(gson.toJson(jsonResponse));
                    return;
                }

                int idAluno = Integer.parseInt(idAlunoStr);
                
                // Constrói a descrição combinada dos blocos
                String descricaoConsolidada = construirDescricaoTreino(treinosSelecionados);

                if (descricaoConsolidada.isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Os blocos de treino selecionados não contêm exercícios cadastrados.");
                    response.getWriter().write(gson.toJson(jsonResponse));
                    return;
                }

                boolean sucesso = salvarTreinoAluno(idAluno, descricaoConsolidada);
                if (sucesso) {
                    jsonResponse.addProperty("success", true);
                    jsonResponse.addProperty("message", "Ficha de treinos do aluno atualizada com sucesso!");
                } else {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Erro ao salvar a ficha de treino no banco de dados.");
                }

            } else if ("criarBloco".equals(acao)) {
                String nomeBloco = request.getParameter("nome_bloco");
                String foco = request.getParameter("tipo_foco");
                String exercicios = request.getParameter("exercicios");

                if (nomeBloco == null || foco == null || exercicios == null) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Preencha todos os campos do bloco de treino.");
                    response.getWriter().write(gson.toJson(jsonResponse));
                    return;
                }

                boolean sucesso = salvarEstruturaBloco(nomeBloco, foco, exercicios);
                if (sucesso) {
                    jsonResponse.addProperty("success", true);
                    jsonResponse.addProperty("message", "Estrutura do Bloco " + nomeBloco + " salva com sucesso!");
                } else {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Erro ao salvar o bloco de treino.");
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Ação desconhecida.");
            }

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Erro interno: " + e.getMessage());
            e.printStackTrace();
        }

        response.getWriter().write(gson.toJson(jsonResponse));
    }

    private List<String> obterBlocosAtivosAluno(int idAluno) throws SQLException {
        List<String> blocos = new ArrayList<>();
        String sql = "SELECT descricao FROM Treino WHERE idAluno = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAluno);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String desc = rs.getString("descricao");
                    if (desc.contains("Treino A -")) blocos.add("A");
                    if (desc.contains("Treino B -")) blocos.add("B");
                    if (desc.contains("Treino C -")) blocos.add("C");
                    if (desc.contains("Treino D -")) blocos.add("D");
                }
            }
        }
        return blocos;
    }

    private String construirDescricaoTreino(String[] blocos) throws SQLException {
        StringBuilder sb = new StringBuilder();
        String sql = "SELECT foco, exercicios FROM BlocoTreino WHERE nome_bloco = ?";
        
        try (Connection conn = DbConnection.getConnection()) {
            for (String bloco : blocos) {
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, bloco);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            String foco = rs.getString("foco");
                            String exercicios = rs.getString("exercicios");
                            
                            sb.append("Treino ").append(bloco).append(" - ").append(foco).append(":\n");
                            String[] itens = exercicios.split(";");
                            for (String item : itens) {
                                if (!item.trim().isEmpty()) {
                                    sb.append("- ").append(item.trim()).append("\n");
                                }
                            }
                            sb.append("\n");
                        }
                    }
                }
            }
        }
        return sb.toString().trim();
    }

    private boolean salvarTreinoAluno(int idAluno, String descricao) throws SQLException {
        int idProfessor = 1;
        String sqlProf = "SELECT idProfessor FROM Professor LIMIT 1";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement psProf = conn.prepareStatement(sqlProf);
             ResultSet rsProf = psProf.executeQuery()) {
            if (rsProf.next()) {
                idProfessor = rsProf.getInt("idProfessor");
            }
        }

        String sql = "INSERT INTO Treino (descricao, dataInicio, dataFim, idAluno, idProfessor) "
                   + "VALUES (?, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 6 MONTH), ?, ?) "
                   + "ON DUPLICATE KEY UPDATE descricao = VALUES(descricao), dataInicio = VALUES(dataInicio), dataFim = VALUES(dataFim), idProfessor = VALUES(idProfessor)";
        
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, descricao);
            ps.setInt(2, idAluno);
            ps.setInt(3, idProfessor);
            return ps.executeUpdate() > 0;
        }
    }

    private boolean salvarEstruturaBloco(String nomeBloco, String foco, String exercicios) throws SQLException {
        String sql = "INSERT INTO BlocoTreino (nome_bloco, foco, exercicios) VALUES (?, ?, ?) "
                   + "ON DUPLICATE KEY UPDATE foco = VALUES(foco), exercicios = VALUES(exercicios)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nomeBloco);
            ps.setString(2, foco);
            ps.setString(3, exercicios);
            return ps.executeUpdate() > 0;
        }
    }
}
