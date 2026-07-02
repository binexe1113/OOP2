<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
                <a href="aluno.jsp" class="btn btn-sm btn-outline-light me-2">Voltar para Ficha</a>
                <span class="text-white small">Olá, Isaque</span>
            </div>
        </div>
    </nav>

    <div class="container mb-5">
        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="card custom-card bg-white p-3 text-center h-100 border-start border-4 border-primary">
                    <h6 class="text-muted fw-bold mb-1">Total de Treinos Concluídos</h6>
                    <h2 class="fw-bold text-primary mb-0">24</h2>
                    <small class="text-success"><i class="fas fa-arrow-up"></i> +4 neste mês</small>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card custom-card bg-white p-3 text-center h-100 border-start border-4 border-warning">
                    <h6 class="text-muted fw-bold mb-1">Treino Favorito</h6>
                    <h2 class="fw-bold text-warning mb-0">Treino C</h2>
                    <small class="text-muted">Peito e Tríceps</small>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card custom-card bg-white p-3 text-center h-100 border-start border-4 border-success">
                    <h6 class="text-muted fw-bold mb-1">Status da Matrícula</h6>
                    <h2 class="fw-bold text-success mb-0">Ativa</h2>
                    <small class="text-muted">Próximo vencimento: 15/08/2026</small>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-lg-8">
                <div class="card custom-card bg-white p-4 h-100">
                    <h5 class="fw-bold mb-3"><i class="fas fa-calendar-alt text-primary me-2"></i> Frequência nos Últimos 6 Meses</h5>
                    <canvas id="graficoFrequencia" height="100"></canvas>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="card custom-card bg-white p-4 h-100">
                    <h5 class="fw-bold mb-3"><i class="fas fa-weight text-danger me-2"></i> Avaliação Física</h5>
                    
                    <div class="mb-3">
                        <div class="d-flex justify-content-between">
                            <span class="text-muted">Peso Atual</span>
                            <span class="fw-bold">78 kg</span>
                        </div>
                        <hr class="my-2">
                        <div class="d-flex justify-content-between">
                            <span class="text-muted">% de Gordura</span>
                            <span class="fw-bold">14%</span>
                        </div>
                        <hr class="my-2">
                        <div class="d-flex justify-content-between">
                            <span class="text-muted">Massa Muscular</span>
                            <span class="fw-bold">38 kg</span>
                        </div>
                    </div>
                    <button class="btn btn-outline-danger w-100 mt-auto fw-bold"><i class="fas fa-calendar-plus me-1"></i> Agendar Nova Avaliação</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Configuração do Gráfico Chart.js
        const ctx = document.getElementById('graficoFrequencia').getContext('2d');
        const graficoFrequencia = new Chart(ctx, {
            type: 'bar', // Tipo barra
            data: {
                labels: ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho'],
                datasets: [{
                    label: 'Dias treinados no mês',
                    data: [12, 15, 14, 18, 16, 20],
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
                        max: 30
                    }
                }
            }
        });
    </script>
</body>
</html>