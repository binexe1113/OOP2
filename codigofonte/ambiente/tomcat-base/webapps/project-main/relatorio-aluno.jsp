<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.academia.model.Usuario" %>
<%@ page import="com.academia.model.Aluno" %>
<%@ page import="com.academia.dao.AlunoDAO" %>
<%@ page import="com.academia.model.Treino" %>
<%@ page import="com.academia.dao.TreinoDAO" %>
<%@ page import="com.academia.dao.CheckInDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%
    // Garante que o usuário está logado como ALUNO
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
    if (usuarioLogado == null) {
        response.sendRedirect("acesso.jsp");
        return;
    }
    if (!"ALUNO".equalsIgnoreCase(usuarioLogado.getRole())) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acesso restrito para alunos.");
        return;
    }

    // Busca o perfil do aluno
    AlunoDAO alunoDAO = new AlunoDAO();
    Aluno alunoLogado = null;
    try {
        alunoLogado = alunoDAO.buscarPorIdUsuario(usuarioLogado.getIdUsuario());
    } catch (Exception e) {
        e.printStackTrace();
    }

    if (alunoLogado == null) {
        response.sendRedirect("aluno.jsp");
        return;
    }

    // Obtém o histórico de check-ins do aluno e monta a estatística mensal
    CheckInDAO checkInDAO = new CheckInDAO();
    List<java.sql.Timestamp> historicoCheckIn = null;
    int totalCheckIns = 0;
    int checkInsMesAtual = 0;
    Map<String, Integer> frequenciaMeses = new HashMap<>();
    
    String[] mesesLabels = new String[6];
    int[] checkinsPorMes = new int[6];
    
    try {
        historicoCheckIn = checkInDAO.listarDatasPorAluno(alunoLogado.getIdAluno());
        totalCheckIns = (historicoCheckIn != null) ? historicoCheckIn.size() : 0;
        
        LocalDate hoje = LocalDate.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMM", new java.util.Locale("pt", "BR"));
        
        // Inicializa os últimos 6 meses no dicionário
        for (int i = 5; i >= 0; i--) {
            LocalDate dataMes = hoje.minusMonths(i);
            String mesNome = dataMes.format(formatter);
            mesNome = mesNome.substring(0, 1).toUpperCase() + mesNome.substring(1);
            mesesLabels[5 - i] = mesNome;
            frequenciaMeses.put(mesNome, 0);
        }
        
        if (historicoCheckIn != null) {
            for (java.sql.Timestamp t : historicoCheckIn) {
                if (t != null) {
                    LocalDate dt = t.toLocalDateTime().toLocalDate();
                    
                    // Conta se for do mês atual
                    if (dt.getMonthValue() == hoje.getMonthValue() && dt.getYear() == hoje.getYear()) {
                        checkInsMesAtual++;
                    }
                    
                    // Mapeia para o gráfico dos últimos 6 meses
                    String mesCheckIn = dt.format(formatter);
                    mesCheckIn = mesCheckIn.substring(0, 1).toUpperCase() + mesCheckIn.substring(1);
                    if (frequenciaMeses.containsKey(mesCheckIn)) {
                        frequenciaMeses.put(mesCheckIn, frequenciaMeses.get(mesCheckIn) + 1);
                    }
                }
            }
        }
        
        // Popula o array do gráfico
        for (int i = 0; i < 6; i++) {
            checkinsPorMes[i] = frequenciaMeses.get(mesesLabels[i]);
        }
        
    } catch (Exception e) {
        e.printStackTrace();
    }

    // Busca o status da matrícula e próximo vencimento
    String statusMatricula = "Inativa";
    String vencimentoMatricula = "N/A";
    if (alunoLogado.getMatricula() != null) {
        statusMatricula = alunoLogado.getMatricula().isStatus() ? "Ativa" : "Inativa";
        if (alunoLogado.getMatricula().getDataFim() != null) {
            vencimentoMatricula = new java.text.SimpleDateFormat("dd/MM/yyyy").format(alunoLogado.getMatricula().getDataFim());
        }
    }

    // Identifica treino em execução
    String treinoFavorito = "Nenhum";
    String focoFavorito = "Sem Ficha Ativa";
    
    TreinoDAO treinoDAO = new TreinoDAO();
    try {
        Treino treinoLogado = treinoDAO.buscarPorAluno(alunoLogado.getIdAluno());
        if (treinoLogado != null && treinoLogado.getDescricao() != null) {
            String desc = treinoLogado.getDescricao();
            if (desc.contains("Treino A")) {
                treinoFavorito = "Treino A";
                focoFavorito = desc.split("Treino A")[1].split("\n")[0].trim().replace("-", "").replace(":", "");
            } else if (desc.contains("Treino B")) {
                treinoFavorito = "Treino B";
                focoFavorito = desc.split("Treino B")[1].split("\n")[0].trim().replace("-", "").replace(":", "");
            } else {
                treinoFavorito = "Ficha Ativa";
                focoFavorito = "Treino Integrado";
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Relatórios e Evolução - Academia Fit</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .custom-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }
    </style>
</head>
<body class="bg-light">

    <nav class="navbar navbar-dark bg-primary mb-4 shadow-sm">
        <div class="container">
            <span class="navbar-brand mb-0 h1 fw-bold text-warning">
                <i class="fas fa-chart-line me-2"></i> Evolução e Relatórios
            </span>
            <div>
                <a href="aluno.jsp" class="btn btn-sm btn-outline-light me-2">
                    <i class="fas fa-arrow-left me-1"></i> Voltar para Ficha
                </a>
                <span class="text-white small">Olá, <%= alunoLogado.getNome() %></span>
            </div>
        </div>
    </nav>

    <div class="container mb-5">
        <div class="row g-4 mb-4">
            <!-- Total de Treinos Concluídos -->
            <div class="col-md-4">
                <div class="card custom-card bg-white p-3 text-center h-100 border-start border-4 border-primary">
                    <h6 class="text-muted fw-bold mb-1">Total de Treinos Concluídos</h6>
                    <h2 class="fw-bold text-primary mb-0"><%= totalCheckIns %></h2>
                    <small class="text-success"><i class="fas fa-arrow-up"></i> +<%= checkInsMesAtual %> neste mês</small>
                </div>
            </div>
            <!-- Treino Favorito / Ativo -->
            <div class="col-md-4">
                <div class="card custom-card bg-white p-3 text-center h-100 border-start border-4 border-warning">
                    <h6 class="text-muted fw-bold mb-1">Foco da Ficha Ativa</h6>
                    <h2 class="fw-bold text-warning mb-0"><%= treinoFavorito %></h2>
                    <small class="text-muted"><%= focoFavorito %></small>
                </div>
            </div>
            <!-- Status da Matrícula -->
            <div class="col-md-4">
                <div class="card custom-card bg-white p-3 text-center h-100 border-start border-4 border-success">
                    <h6 class="text-muted fw-bold mb-1">Status da Matrícula</h6>
                    <h2 class="fw-bold text-success mb-0"><%= statusMatricula %></h2>
                    <small class="text-muted">Vencimento: <%= vencimentoMatricula %></small>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <!-- Gráfico de Frequência -->
            <div class="col-12">
                <div class="card custom-card bg-white p-4 h-100">
                    <h5 class="fw-bold mb-3"><i class="fas fa-calendar-alt text-primary me-2"></i> Frequência nos Últimos 6 Meses</h5>
                    <canvas id="graficoFrequencia" height="80"></canvas>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Configuração do Gráfico Chart.js
        const ctx = document.getElementById('graficoFrequencia').getContext('2d');
        const graficoFrequencia = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: [
                    <% for (int i = 0; i < 6; i++) { %>
                        '<%= mesesLabels[i] %>'<%= (i < 5) ? "," : "" %>
                    <% } %>
                ],
                datasets: [{
                    label: 'Dias treinados no mês',
                    data: [
                        <% for (int i = 0; i < 6; i++) { %>
                            <%= checkinsPorMes[i] %><%= (i < 5) ? "," : "" %>
                        <% } %>
                    ],
                    backgroundColor: 'rgba(13, 110, 253, 0.7)',
                    borderColor: 'rgba(13, 110, 253, 1)',
                    borderWidth: 1,
                    borderRadius: 5
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>