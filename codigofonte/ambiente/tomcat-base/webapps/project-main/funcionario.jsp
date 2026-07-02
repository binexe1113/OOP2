<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.academia.model.Usuario" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.academia.util.DbConnection" %>
<%
    // Garante que apenas usuários logados com perfil FUNCIONARIO ou GERENTE possam acessar
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
    if (usuarioLogado == null) {
        response.sendRedirect("acesso.jsp");
        return;
    }
    if (!"FUNCIONARIO".equalsIgnoreCase(usuarioLogado.getRole()) && !"GERENTE".equalsIgnoreCase(usuarioLogado.getRole())) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acesso restrito para instrutores/funcionários.");
        return;
    }

    String nomeFunc = "";
    String cpfFunc = "";
    try (Connection connFunc = DbConnection.getConnection();
         PreparedStatement psFunc = connFunc.prepareStatement("SELECT nome, cpf FROM Funcionario WHERE idUsuario = ?")) {
        psFunc.setInt(1, usuarioLogado.getIdUsuario());
        try (ResultSet rsFunc = psFunc.executeQuery()) {
            if (rsFunc.next()) {
                nomeFunc = rsFunc.getString("nome");
                cpfFunc = rsFunc.getString("cpf");
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
    <title>Painel do Funcionário - Gestão de Treinos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .custom-card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }
    </style>
</head>
<body class="bg-light">

    <nav class="navbar navbar-dark bg-secondary mb-4">
        <div class="container">
            <span class="navbar-brand mb-0 h1 fw-bold text-warning">
                <i class="fas fa-dumbbell me-2"></i> Painel do Instrutor
            </span>
            <div>
                <button class="btn btn-sm btn-outline-light me-2" data-bs-toggle="modal" data-bs-target="#modalPerfil">
                    <i class="fas fa-user-cog me-1"></i> Meus Dados
                </button>
                <span class="text-white small me-3">Olá, <%= nomeFunc.isEmpty() ? usuarioLogado.getEmailLogin() : nomeFunc %></span>
                <a href="api/logout" class="btn btn-sm btn-danger"><i class="fas fa-sign-out-alt me-1"></i> Sair</a>
            </div>
        </div>
    </nav>

    <div class="container mb-5">
        <div id="alert-funcionario" class="alert d-none" role="alert"></div>

        <div class="row g-4">
            
            <!-- Atribuir / Trocar Treino do Aluno -->
            <div class="col-lg-6">
                <div class="card custom-card p-4 h-100 bg-white">
                    <h5 class="fw-bold text-dark mb-3"><i class="fas fa-user-edit text-primary me-2"></i> Atribuir / Trocar Treino do Aluno</h5>
                    <p class="text-muted small">Selecione o aluno e marque quais blocos de treino ele deve realizar.</p>
                    
                    <form id="form-vincular-treino">
                        <div class="mb-3">
                            <label for="select-aluno" class="form-label fw-semibold">Selecionar Aluno</label>
                            <select class="form-select" id="select-aluno" name="cpf_aluno" required>
                                <option value="" selected disabled>Escolha um aluno...</option>
                                <%
                                    Connection conn = null;
                                    PreparedStatement ps = null;
                                    ResultSet rs = null;
                                    try {
                                        conn = DbConnection.getConnection();
                                        String sql = "SELECT nome, cpf FROM Aluno ORDER BY nome ASC";
                                        ps = conn.prepareStatement(sql);
                                        rs = ps.executeQuery();
                                        while (rs.next()) {
                                            String nome = rs.getString("nome");
                                            String cpf = rs.getString("cpf");
                                %>
                                            <option value="<%= cpf %>"><%= nome %> (CPF: <%= cpf %>)</option>
                                <%
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    } finally {
                                        if (rs != null) try { rs.close(); } catch (Exception e) {}
                                        if (ps != null) try { ps.close(); } catch (Exception e) {}
                                        if (conn != null) try { conn.close(); } catch (Exception e) {}
                                    }
                                %>
                            </select>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-semibold d-block">Selecione os Blocos Ativos</label>
                            <p class="text-muted card-text small mt-0 mb-2">Os treinos selecionados serão vinculados diretamente ao perfil do aluno.</p>
                            
                            <div class="form-check form-check-inline">
                                <input class="form-check-input chk-treino" type="checkbox" name="treinos" id="chk-a" value="A">
                                <label class="form-check-label fw-medium" for="chk-a">Treino A</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input chk-treino" type="checkbox" name="treinos" id="chk-b" value="B">
                                <label class="form-check-label fw-medium" for="chk-b">Treino B</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input chk-treino" type="checkbox" name="treinos" id="chk-c" value="C">
                                <label class="form-check-label fw-medium" for="chk-c">Treino C</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input chk-treino" type="checkbox" name="treinos" id="chk-d" value="D">
                                <label class="form-check-label fw-medium" for="chk-d">Treino D</label>
                            </div>
                        </div>

                        <!-- Ficha de Treinos Atual do Aluno -->
                        <div id="ficha-atual-container" class="mb-3 p-3 bg-light border rounded d-none">
                            <h6 class="fw-bold text-dark mb-2 small"><i class="fas fa-file-invoice text-secondary me-2"></i> Ficha de Treinos Atual</h6>
                            <pre id="ficha-atual-texto" class="mb-0 text-muted small" style="white-space: pre-wrap; font-family: inherit; font-size: 0.85rem;"></pre>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 fw-bold" id="btn-salvar-aluno-treino">
                            <span class="spinner-border spinner-border-sm d-none" role="status"></span>
                            Atualizar Ficha do Aluno
                        </button>
                    </form>
                </div>
            </div>

            <!-- Criar / Editar Bloco de Treino -->
            <div class="col-lg-6">
                <div class="card custom-card p-4 h-100 bg-white">
                    <h5 class="fw-bold text-dark mb-3"><i class="fas fa-folder-plus text-success me-2"></i> Criar / Editar Bloco de Treino</h5>
                    <p class="text-muted small">Monte a estrutura de exercícios de um bloco específico (ex: Bloco A, B, C...).</p>
                    
                    <form id="form-criar-treino">
                        <div class="row g-2 mb-3">
                            <div class="col-md-6">
                                <label for="nome-bloco" class="form-label fw-semibold">Nome do Bloco</label>
                                <select class="form-select" id="nome-bloco" name="nome_bloco" required>
                                    <option value="A">Bloco A</option>
                                    <option value="B">Bloco B</option>
                                    <option value="C">Bloco C</option>
                                    <option value="D">Bloco D</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="tipo-foco" class="form-label fw-semibold">Foco / Tipo</label>
                                <input type="text" class="form-control" id="tipo-foco" name="tipo_foco" placeholder="Ex: Peito e Tríceps" required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="lista-exercicios" class="form-label fw-semibold">Exercícios do Bloco</label>
                            <p class="text-muted card-text small mt-0 mb-2">Digite os exercícios separados por ponto e vírgula (;)</p>
                            <textarea class="form-control" id="lista-exercicios" name="exercicios" rows="4" 
                                      placeholder="Supino Reto 4x10; Peck Deck 3x12; Tríceps Corda 4x12;" required></textarea>
                        </div>

                        <button type="submit" class="btn btn-success w-100 fw-bold" id="btn-salvar-bloco">
                            <span class="spinner-border spinner-border-sm d-none" role="status"></span>
                            Salvar Estrutura do Bloco
                        </button>
                    </form>
                </div>
            </div>

        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
    $(document).ready(function() {
        
        let alertBox = $('#alert-funcionario');

        function exibirAlerta(mensagem, sucesso) {
            alertBox.removeClass('d-none alert-success alert-danger');
            if (sucesso) {
                alertBox.addClass('alert-success').text(mensagem);
            } else {
                alertBox.addClass('alert-danger').text(mensagem);
            }
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        // --- CARREGAR TREINOS E FICHA DO ALUNO AO SELECIONAR ---
        $('#select-aluno').on('change', function() {
            let cpfAluno = $(this).val();
            if (!cpfAluno) return;

            // Limpa checkboxes e esconde a ficha anterior
            $('.chk-treino').prop('checked', false);
            $('#ficha-atual-container').addClass('d-none');
            $('#ficha-atual-texto').text('');

            $.ajax({
                url: 'FuncionarioController',
                type: 'GET',
                data: {
                    acao: 'obterTreino',
                    cpf_aluno: cpfAluno
                },
                dataType: 'json',
                success: function(response) {
                    // Marcando os checkboxes corretos
                    if (response.blocosAtivos && Array.isArray(response.blocosAtivos)) {
                        response.blocosAtivos.forEach(function(bloco) {
                            $('.chk-treino[value="' + bloco + '"]').prop('checked', true);
                        });
                    }
                    // Exibindo a ficha de treino atual
                    if (response.fichaTreino) {
                        $('#ficha-atual-texto').text(response.fichaTreino);
                        $('#ficha-atual-container').removeClass('d-none');
                    }
                },
                error: function() {
                    console.log('Erro ao buscar treinos ativos do aluno.');
                }
            });
        });

        // --- VINCULAR OU TROCAR TREINO DO ALUNO ---
        $('#form-vincular-treino').on('submit', function(e) {
            e.preventDefault();
            
            let btn = $('#btn-salvar-aluno-treino');
            let spinner = btn.find('.spinner-border');
            
            btn.prop('disabled', true);
            spinner.removeClass('d-none');

            let formData = $(this).serialize();

            $.ajax({
                url: 'FuncionarioController',
                type: 'POST',
                data: formData + '&acao=vincularTreino',
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        exibirAlerta(response.message || 'Ficha de treinos do aluno atualizada com sucesso!', true);
                        // Atualiza a ficha atual do aluno na tela
                        $('#select-aluno').trigger('change');
                    } else {
                        exibirAlerta(response.message || 'Erro ao atualizar treinos do aluno.', false);
                    }
                },
                error: function(xhr) {
                    let msg = 'Erro técnico de comunicação ao salvar a ficha do aluno.';
                    if (xhr.responseJSON && xhr.responseJSON.message) {
                        msg = xhr.responseJSON.message;
                    }
                    exibirAlerta(msg, false);
                },
                complete: function() {
                    btn.prop('disabled', false);
                    spinner.addClass('d-none');
                }
            });
        });

        // --- CRIAR OU EDITAR UM BLOCO DE TREINO ---
        $('#form-criar-treino').on('submit', function(e) {
            e.preventDefault();
            
            let btn = $('#btn-salvar-bloco');
            let spinner = btn.find('.spinner-border');
            
            btn.prop('disabled', true);
            spinner.removeClass('d-none');

            let formData = $(this).serialize();

            $.ajax({
                url: 'FuncionarioController',
                type: 'POST',
                data: formData + '&acao=criarBloco',
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        exibirAlerta(response.message || 'Estrutura do Bloco salva com sucesso no banco!', true);
                        $('#form-criar-treino')[0].reset();
                    } else {
                        exibirAlerta(response.message || 'Erro ao salvar o bloco de treino.', false);
                    }
                },
                error: function(xhr) {
                    let msg = 'Erro técnico de comunicação ao salvar o bloco.';
                    if (xhr.responseJSON && xhr.responseJSON.message) {
                        msg = xhr.responseJSON.message;
                    }
                    exibirAlerta(msg, false);
                },
                complete: function() {
                    btn.prop('disabled', false);
                    spinner.addClass('d-none');
                }
            });
        });
        // --- AJAX: ATUALIZAR PERFIL DO FUNCIONÁRIO ---
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

    <!-- Modal Perfil Funcionário -->
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
                            <input type="text" class="form-control" id="perf-nome" required value="<%= nomeFunc %>">
                        </div>
                        <div class="mb-3">
                            <label for="perf-cpf" class="form-label fw-semibold">CPF (não alterável)</label>
                            <input type="text" class="form-control bg-light" id="perf-cpf" value="<%= cpfFunc %>" readonly>
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

</body>
</html>