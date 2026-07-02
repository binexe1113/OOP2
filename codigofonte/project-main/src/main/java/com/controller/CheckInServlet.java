package com.controller;

import com.academia.dao.AlunoDAO;
import com.academia.dao.CheckInDAO;
import com.academia.model.Aluno;
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
import java.sql.Timestamp;
import java.util.List;

@WebServlet("/api/checkin")
public class CheckInServlet extends HttpServlet {
    private final AlunoDAO alunoDAO = new AlunoDAO();
    private final CheckInDAO checkInDAO = new CheckInDAO();
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
            jsonResponse.addProperty("mensagem", "Sessão expirada. Por favor, faça login novamente.");
            response.getWriter().write(gson.toJson(jsonResponse));
            return;
        }

        try {
            Aluno aluno = alunoDAO.buscarPorIdUsuario(usuarioLogado.getIdUsuario());

            if (aluno == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                jsonResponse.addProperty("sucesso", false);
                jsonResponse.addProperty("mensagem", "Aluno associado a este usuário não foi encontrado.");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            if (aluno.getMatricula() == null || !aluno.getMatricula().isStatus()) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                jsonResponse.addProperty("sucesso", false);
                jsonResponse.addProperty("mensagem", "Não autorizado: Sua matrícula está inativa ou pendente.");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            int idAcademia = 1;
            Integer idTreino = null;
            try {
                JsonObject data = gson.fromJson(request.getReader(), JsonObject.class);
                if (data != null) {
                    if (data.has("idAcademia")) {
                        idAcademia = data.get("idAcademia").getAsInt();
                    }
                    if (data.has("idTreino") && !data.get("idTreino").isJsonNull()) {
                        idTreino = data.get("idTreino").getAsInt();
                    }
                }
            } catch (Exception ignored) {
            }

            boolean registrado = checkInDAO.registrar(aluno.getIdAluno(), idAcademia, idTreino);

            if (registrado) {
                jsonResponse.addProperty("sucesso", true);
                jsonResponse.addProperty("mensagem", "Check-in realizado com sucesso!");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                jsonResponse.addProperty("sucesso", false);
                jsonResponse.addProperty("mensagem", "Falha ao registrar check-in.");
            }

        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.addProperty("sucesso", false);
            jsonResponse.addProperty("mensagem", "Erro no banco de dados: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(jsonResponse));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        Usuario usuarioLogado = (session != null) ? (Usuario) session.getAttribute("usuarioLogado") : null;

        if (usuarioLogado == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(gson.toJson(new JsonObject()));
            return;
        }

        try {
            Aluno aluno = alunoDAO.buscarPorIdUsuario(usuarioLogado.getIdUsuario());
            
            if (aluno != null) {
                List<Timestamp> checkins = checkInDAO.listarDatasPorAluno(aluno.getIdAluno());
                response.getWriter().write(gson.toJson(checkins));
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            }

        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
