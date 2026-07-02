<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Área do Aluno - Academia Fit</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .custom-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }
        .exercise-item {
            border-left: 4px solid #ffc107;
            background-color: #f8f9fa;
            transition: all 0.2s;
        }
        .exercise-item:hover {
            background-color: #f1f3f5;
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
                <a href="relatorio-aluno.jsp" class="btn btn-sm btn-outline-light me-2">Ver Relatorio</a>
                <span class="text-white small">Olá, Isaque</span>
            </div>
        </div>
    </nav>

    <div class="container mb-5">
        
        <div id="alert-aluno" class="alert d-none" role="alert"></div>

        <div class="card custom-card bg-dark text-white p-4 mb-4 text-center">
            <h4 class="fw-bold text-warning mb-2">Vai treinar hoje? 🏋️‍♂️</h4>
            <p class="text-muted small mb-3">Selecione o treino do dia e clique no botão para registrar a sua presença.</p>
            
            <form id="form-checkin" class="d-flex flex-column flex-sm-row justify-content-center align-items-center gap-2 max-width-500 mx-auto">
                <select class="form-select w-auto" id="checkin-treino" name="treino_bloco" required>
                    <option value="" selected disabled>Escolha o treino...</option>
                    <option value="A">Treino A (Pernas / Quadríceps)</option>
                    <option value="B">Treino B (Costas e Bíceps)</option>
                    <option value="C">Treino C (Peito e Tríceps)</option>
                </select>
                <button type="submit" class="btn btn-warning fw-bold px-4 w-100 w-sm-auto" id="btn-checkin">
                    <i class="fas fa-calendar-check me-2"></i> Fazer Check-In
                </button>
            </form>
        </div>

        <div class="row g-4">
            
            <div class="col-lg-7">
                <div class="card custom-card p-4 bg-white h-100">
                    <div class="d-flex align-items-center mb-3">
                        <i class="fas fa-dumbbell text-primary fs-4 me-2"></i>
                        <h5 class="fw-bold mb-0">Minha Ficha de Exercícios</h5>
                    </div>
                    <p class="text-muted small">Navegue pelas abas para ver os exercícios passados pelo instrutor.</p>

                    <ul class="nav nav-pills nav-fill mb-3 bg-light p-1 rounded" id="pills-tab" role="tablist">
                        <li class="nav-item">
                            <button class="nav-link active fw-bold" id="tab-a" data-bs-toggle="pill" data-bs-target="#pane-a" type="button">Treino A</button>
                        </li>
                        <li class="nav-item">
                            <button class="nav-link fw-bold" id="tab-b" data-bs-toggle="pill" data-bs-target="#pane-b" type="button">Treino B</button>
                        </li>
                        <li class="nav-item">
                            <button class="nav-link fw-bold" id="tab-c" data-bs-toggle="pill" data-bs-target="#pane-c" type="button">Treino C</button>
                        </li>
                    </ul>

                    <div class="tab-content" id="pills-tabContent">
                        
                        <div class="tab-pane fade show active" id="pane-a" role="tabpanel">
                            <div class="badge bg-secondary mb-3">Foco: Pernas e Abdominais</div>
                            <div class="d-flex flex-column gap-2">
                                <div class="p-3 rounded exercise-item d-flex justify-content-between align-items-center">
                                    <span class="fw-medium">Leg Press 45º</span>
                                    <span class="badge bg-dark">4x12 - 120kg</span>
                                </div>
                                <div class="p-3 rounded exercise-item d-flex justify-content-between align-items-center">
                                    <span class="fw-medium">Cadeira Extensora</span>
                                    <span class="badge bg-dark">3x15 - Drop-set</span>
                                </div>
                                <div class="p-3 rounded exercise-item d-flex justify-content-between align-items-center">
                                    <span class="fw-medium">Mesa Flexora</span>
                                    <span class="badge bg-dark">4x10 - Cadência 3s</span>
                                </div>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="pane-b" role="tabpanel">
                            <div class="badge bg-secondary mb-3">Foco: Costas e Bíceps</div>
                            <div class="d-flex flex-column gap-2">
                                <div class="p-3 rounded exercise-item d-flex justify-content-between align-items-center">
                                    <span class="fw-medium">Puxada Alta na Polia</span>
                                    <span class="badge bg-dark">4x10</span>
                                </div>
                                <div class="p-3 rounded exercise-item d-flex justify-content-between align-items-center">
                                    <span class="fw-medium">Remada Baixa Triângulo</span>
                                    <span class="badge bg-dark">3x12</span>
                                </div>
                                <div class="p-3 rounded exercise-item d-flex justify-content-between align-items-center">
                                    <span class="fw-medium">Rosca Scott (Barra W)</span>
                                    <span class="badge bg-dark">4x8</span>
                                </div>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="pane-c" role="tabpanel">
                            <div class="badge bg-secondary mb-3">Foco: Peito e Tríceps</div>
                            <div class="d-flex flex-column gap-2">
                                <div class="p-3 rounded exercise-item d-flex justify-content-between align-items-center">
                                    <span class="fw-medium">Supino Reto (Barra)</span>
                                    <span class="badge bg-dark">4x10</span>
                                </div>
                                <div class="p-3 rounded exercise-item d-flex justify-content-between align-items-center">
                                    <span class="fw-medium">Crucifixo Inclinado Hálteres</span>
                                    <span class="badge bg-dark">3x12</span>
                                </div>
                                <div class="p-3 rounded exercise-item d-flex justify-content-between align-items-center">
                                    <span class="fw-medium">Tríceps Corda</span>
                                    <span class="badge bg-dark">4x12</span>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>

            <div class="col-lg-5">
                <div class="card custom-card p-4 bg-white h-100">
                    <div class="d-flex align-items-center mb-3">
                        <i class="fas fa-history text-success fs-4 me-2"></i>
                        <h5 class="fw-bold mb-0">Histórico de Presença</h5>
                    </div>
                    <p class="text-muted small">Últimos treinos concluídos salvos no sistema.</p>

                    <div class="table-responsive">
                        <table class="table table-sm table-borderless align-middle">
                            <thead>
                                <tr class="border-bottom text-muted small">
                                    <th>Treino</th>
                                    <th class="text-end">Data / Hora</th>
                                </tr>
                            </thead>
                            <tbody id="historico-checkin">
                                <tr>
                                    <td><span class="badge bg-primary">Treino A</span></td>
                                    <td class="text-end text-muted small">28/06/2026 - 19:34</td>
                                </tr>
                                <tr>
                                    <td><span class="badge bg-info text-dark">Treino B</span></td>
                                    <td class="text-end text-muted small">26/06/2026 - 08:15</td>
                                </tr>
                                <tr>
                                    <td><span class="badge bg-success">Treino C</span></td>
                                    <td class="text-end text-muted small">25/06/2026 - 18:02</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
    $(document).ready(function() {

        // --- AJAX: DISPARAR CHECK-IN DO DIA ---
        $('#form-checkin').on('submit', function(e) {
            e.preventDefault();

            let btn = $('#btn-checkin');
            let alertBox = $('#alert-aluno');
            let treinoSelecionado = $('#checkin-treino').val();

            btn.prop('disabled', true);
            alertBox.addClass('d-none').removeClass('alert-success alert-danger');

            $.ajax({
                url: 'AlunoController', // <-- URL da sua Servlet para controle do Aluno
                type: 'POST',
                data: {
                    acao: 'checkin',
                    treino: treinoSelecionado
                },
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        alertBox.removeClass('d-none').addClass('alert-success').text('Check-in do Treino ' + treinoSelecionado + ' salvo com sucesso! Bom descanso.');
                        
                        // Adiciona dinamicamente a linha nova na tabela de histórico sem dar reload
                        let agora = new Date();
                        let dataFormatada = agora.toLocaleDateString('pt-BR') + ' - ' + agora.toLocaleTimeString('pt-BR', {hour: '2-digit', minute:'2-digit'});
                        
                        let novaLinha = '<tr>' +
                            '<td><span class="badge bg-secondary">Treino ' + treinoSelecionado + '</span></td>' +
                            '<td class="text-end text-muted small">' + dataFormatada + '</td>' +
                            '</tr>';
                        
                        $('#historico-checkin').prepend(novaLinha);
                    } else {
                        alertBox.removeClass('d-none').addClass('alert-danger').text(response.message || 'Erro ao realizar check-in.');
                    }
                },
                error: function() {
                    alertBox.removeClass('d-none').addClass('alert-danger').text('Erro técnico de comunicação ao enviar check-in.');
                },
                complete: function() {
                    btn.prop('disabled', false);
                    $('#form-checkin')[0].reset();
                }
            });
        });

    });
    </script>
</body>
</html>