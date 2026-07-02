<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.academia.model.Usuario" %>
<%@ page import="com.academia.model.Aluno" %>
<%@ page import="com.academia.model.Treino" %>
<%@ page import="com.academia.dao.AlunoDAO" %>
<%@ page import="com.academia.dao.TreinoDAO" %>
<%@ page import="com.academia.dao.CheckInDAO" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.List" %>
<%
    // Garante que o usuário está logado e possui perfil apropriado
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
    if (usuarioLogado == null) {
        response.sendRedirect("acesso.jsp");
        return;
    }

    Aluno alunoLogado = null;
    Treino treinoLogado = null;
    List<Timestamp> checkins = null;
    
    AlunoDAO alunoDAO = new AlunoDAO();
    TreinoDAO treinoDAO = new TreinoDAO();
    CheckInDAO checkInDAO = new CheckInDAO();
    try {
        alunoLogado = alunoDAO.buscarPorIdUsuario(usuarioLogado.getIdUsuario());
        if (alunoLogado != null) {
            treinoLogado = treinoDAO.buscarPorAluno(alunoLogado.getIdAluno());
            checkins = checkInDAO.listarDatasPorAluno(alunoLogado.getIdAluno());
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
                <% if (alunoLogado != null) { %>
                    <button class="btn btn-sm btn-outline-light me-2" data-bs-toggle="modal" data-bs-target="#modalPerfil">
                        <i class="fas fa-user-cog me-1"></i> Meus Dados
                    </button>
                <% } %>
                <span class="text-white small me-3">Olá, <%= (alunoLogado != null) ? alunoLogado.getNome() : usuarioLogado.getEmailLogin() %></span>
                <a href="api/logout" class="btn btn-sm btn-danger"><i class="fas fa-sign-out-alt me-1"></i> Sair</a>
            </div>
        </div>
    </nav>

    <div class="container mb-5">
        
        <div id="alert-aluno" class="alert d-none" role="alert"></div>

        <% if (alunoLogado == null) { %>
            <!-- Caso a conta do Usuário não esteja vinculada a nenhum Aluno -->
            <div class="row">
                <div class="col-12">
                    <div class="card custom-card p-5 bg-white text-center shadow-sm">
                        <i class="fas fa-exclamation-circle text-danger fs-1 mb-3"></i>
                        <h3 class="fw-bold">ALUNO SEM TREINO ENCONTRADO</h3>
                        <p class="text-muted">A sua conta de acesso (<strong><%= usuarioLogado.getEmailLogin() %></strong>) ainda não foi vinculada a nenhum treino.</p>
                        <p class="text-muted">Por favor, direcione-se a um professor para que ele possa orientá-lo(a).</p>
                        <a href="api/logout" class="btn btn-danger mt-3 px-4"><i class="fas fa-sign-out-alt me-2"></i> Efetuar Logout</a>
                    </div>
                </div>
            </div>
        <% } else if (alunoLogado.getMatricula() == null || !alunoLogado.getMatricula().isStatus()) { %>
            <!-- Caso o Aluno tenha cadastro mas matrícula esteja inativa -->
            <div class="row">
                <div class="col-12">
                    <div class="card custom-card p-5 bg-white text-center shadow-sm">
                        <i class="fas fa-hand-holding-usd text-warning fs-1 mb-3"></i>
                        <h3 class="fw-bold">Matrícula Inativa</h3>
                        <p class="text-muted">Olá, <strong><%= alunoLogado.getNome() %></strong>. Consta no sistema que a sua matrícula ou plano está inativo no momento.</p>
                        <p class="text-muted">Por favor, procure a recepção para regularizar sua matrícula e liberar seu acesso aos treinos e check-ins.</p>
                        <a href="api/logout" class="btn btn-danger mt-3 px-4"><i class="fas fa-sign-out-alt me-2"></i> Efetuar Logout</a>
                    </div>
                </div>
            </div>
        <% } else { %>
            <!-- Caso de matrícula ativa normal -->
            <% if (treinoLogado != null) { %>
                <div class="card custom-card bg-dark text-white p-4 mb-4 text-center">
                    <h4 class="fw-bold text-warning mb-2">Vai treinar hoje? 🏋️‍♂️</h4>
                    <p class="text-muted small mb-3">Selecione o treino do dia e clique no botão para registrar a sua presença.</p>
                    
                    <form id="form-checkin" class="d-flex flex-column flex-sm-row justify-content-center align-items-center gap-2 max-width-500 mx-auto">
                        <select class="form-select w-auto" id="checkin-treino" name="treino_bloco" required>
                            <option value="" selected disabled>Escolha o treino...</option>
                            <option value="A">Treino A (Geral)</option>
                        </select>
                        <button type="submit" class="btn btn-warning fw-bold px-4 w-100 w-sm-auto" id="btn-checkin">
                            <i class="fas fa-calendar-check me-2"></i> Fazer Check-In
                        </button>
                    </form>
                </div>
            <% } %>

            <div class="row g-4">
                
                <!-- Ficha de Exercícios -->
                <div class="col-lg-7">
                    <% if (treinoLogado == null) { %>
                        <div class="card custom-card p-5 bg-white h-100 text-center d-flex flex-column justify-content-center align-items-center shadow-sm">
                            <i class="fas fa-exclamation-triangle text-warning fs-1 mb-3"></i>
                            <h4 class="fw-bold text-dark">Nenhum treino cadastrado</h4>
                            <p class="text-muted small">Você ainda não possui uma ficha de exercícios cadastrada no sistema.</p>
                            <p class="text-muted small">Por favor, solicite a criação de um treino personalizado diretamente ao seu professor ou instrutor físico.</p>
                        </div>
                    <% } else { %>
                        <div class="card custom-card p-4 bg-white h-100">
                            <div class="d-flex align-items-center mb-3">
                                <i class="fas fa-dumbbell text-primary fs-4 me-2"></i>
                                <h5 class="fw-bold mb-0">Minha Ficha de Exercícios</h5>
                            </div>
                            
                            <div class="mb-3 p-3 bg-light rounded border-start border-primary border-4">
                                <div class="small text-muted">Professor Responsável</div>
                                <div class="fw-bold text-dark"><%= treinoLogado.getProfessor().getNome() %></div>
                                <div class="small text-muted mt-2">Período de Validade</div>
                                <div class="fw-medium text-secondary">
                                    <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(treinoLogado.getDataInicio()) %> até 
                                    <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(treinoLogado.getDataFim()) %>
                                </div>
                            </div>

                            <div class="mt-4">
                                <h6 class="fw-bold mb-2"><i class="fas fa-clipboard-list me-1 text-primary"></i> Exercícios e Instruções:</h6>
                                <div class="p-3 bg-light rounded text-dark" style="white-space: pre-line; line-height: 1.6;">
                                    <%= treinoLogado.getDescricao() %>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>

                <!-- Histórico de Presença -->
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
                                    <% if (checkins != null && !checkins.isEmpty()) { %>
                                        <% for (Timestamp ts : checkins) { %>
                                            <tr>
                                                <td><span class="badge bg-success">Check-in Realizado</span></td>
                                                <td class="text-end text-muted small"><%= new java.text.SimpleDateFormat("dd/MM/yyyy - HH:mm").format(ts) %></td>
                                            </tr>
                                        <% } %>
                                    <% } else { %>
                                        <tr>
                                            <td colspan="2" class="text-center text-muted small py-3">Nenhum check-in registrado ainda.</td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>
        <% } %>
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

            btn.prop('disabled', true);
            alertBox.addClass('d-none').removeClass('alert-success alert-danger');

            let idTreino = <%= (treinoLogado != null) ? treinoLogado.getIdTreino() : "null" %>;
            $.ajax({
                url: 'api/checkin',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    idAcademia: 1,
                    idTreino: idTreino
                }),
                dataType: 'json',
                success: function(response) {
                    if (response.sucesso) {
                        alertBox.removeClass('d-none').addClass('alert-success').text(response.mensagem || 'Check-in realizado com sucesso!');
                        
                        let agora = new Date();
                        let dataFormatada = agora.toLocaleDateString('pt-BR') + ' - ' + agora.toLocaleTimeString('pt-BR', {hour: '2-digit', minute:'2-digit'});
                        
                        let novaLinha = '<tr>' +
                            '<td><span class="badge bg-success">Check-in Realizado</span></td>' +
                            '<td class="text-end text-muted small">' + dataFormatada + '</td>' +
                            '</tr>';
                        
                        // Remove a linha de "Nenhum check-in registrado ainda"
                        $('#historico-checkin').find('.text-center').closest('tr').remove();
                        $('#historico-checkin').prepend(novaLinha);
                    } else {
                        alertBox.removeClass('d-none').addClass('alert-danger').text(response.mensagem || 'Erro ao realizar check-in.');
                    }
                },
                error: function(xhr) {
                    let msg = 'Erro técnico de comunicação ao enviar check-in.';
                    if (xhr.responseJSON && xhr.responseJSON.mensagem) {
                        msg = xhr.responseJSON.mensagem;
                    }
                    alertBox.removeClass('d-none').addClass('alert-danger').text(msg);
                },
                complete: function() {
                    btn.prop('disabled', false);
                    $('#form-checkin')[0].reset();
                }
            });
        });

        // --- AJAX: ATUALIZAR PERFIL DO USUÁRIO ---
        $('#form-perfil').on('submit', function(e) {
            e.preventDefault();
            
            let btn = $('#btn-salvar-perfil');
            let spinner = btn.find('.spinner-border');
            let alertBox = $('#perfil-alert');

            alertBox.addClass('d-none').removeClass('alert-success alert-danger');
            btn.prop('disabled', true);
            spinner.removeClass('d-none');

            let formData = {
                nome: $('#perf-nome').val(),
                idade: parseInt($('#perf-idade').val()),
                telefone: $('#perf-telefone').val(),
                email: $('#perf-email').val()
            };

            $.ajax({
                url: 'api/atualizar-perfil',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(formData),
                dataType: 'json',
                success: function(response) {
                    if (response.sucesso) {
                        alertBox.removeClass('d-none').addClass('alert-success').text(response.mensagem);
                        setTimeout(function() {
                            location.reload();
                        }, 1200);
                    } else {
                        alertBox.removeClass('d-none').addClass('alert-danger').text(response.mensagem || 'Erro ao atualizar dados.');
                        btn.prop('disabled', false);
                        spinner.addClass('d-none');
                    }
                },
                error: function(xhr) {
                    let msg = 'Erro ao processar alteração de perfil.';
                    if (xhr.responseJSON && xhr.responseJSON.mensagem) {
                        msg = xhr.responseJSON.mensagem;
                    }
                    alertBox.removeClass('d-none').addClass('alert-danger').text(msg);
                    btn.prop('disabled', false);
                    spinner.addClass('d-none');
                }
            });
        });

    });
    </script>

    <!-- Modal Perfil Aluno -->
    <% if (alunoLogado != null) { %>
    <div class="modal fade" id="modalPerfil" tabindex="-1" aria-labelledby="modalPerfilLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold" id="modalPerfilLabel"><i class="fas fa-user-cog me-2"></i> Meus Dados</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fechar"></button>
                </div>
                <div class="modal-body">
                    <div id="perfil-alert" class="alert d-none" role="alert"></div>
                    <form id="form-perfil">
                        <div class="mb-3">
                            <label for="perf-nome" class="form-label fw-semibold">Nome Completo</label>
                            <input type="text" class="form-control" id="perf-nome" required value="<%= alunoLogado.getNome() %>">
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="perf-cpf" class="form-label fw-semibold">CPF (não alterável)</label>
                                <input type="text" class="form-control bg-light" id="perf-cpf" value="<%= alunoLogado.getCpf() %>" readonly>
                            </div>
                            <div class="col-md-6">
                                <label for="perf-idade" class="form-label fw-semibold">Idade</label>
                                <input type="number" class="form-control" id="perf-idade" required value="<%= alunoLogado.getIdade() %>">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="perf-telefone" class="form-label fw-semibold">Telefone</label>
                            <input type="text" class="form-control" id="perf-telefone" required value="<%= alunoLogado.getTelefone() %>">
                        </div>
                        <div class="mb-3">
                            <label for="perf-email" class="form-label fw-semibold">E-mail</label>
                            <input type="email" class="form-control" id="perf-email" required value="<%= usuarioLogado.getEmailLogin() %>">
                        </div>
                        <div class="d-grid mt-4">
                            <button type="submit" class="btn btn-primary" id="btn-salvar-perfil">
                                <span class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                                Salvar Alterações
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <% } %>

</body>
</html>