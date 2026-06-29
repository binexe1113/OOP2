<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
            <span class="navbar-brand mb-0 h1 fw-bold text-warning"><i class="fas fa-dumbbell me-2"></i> Painel do Instrutor</span>
            <span class="text-white">Olá, Professor</span>
        </div>
    </nav>

    <div class="container mb-5">
        <div id="alert-funcionario" class="alert d-none" role="alert"></div>

        <div class="row g-4">
            
            <div class="col-lg-6">
                <div class="card custom-card p-4 h-100 bg-white">
                    <h5 class="fw-bold text-dark mb-3"><i class="fas fa-user-edit text-primary me-2"></i> Atribuir / Trocar Treino do Aluno</h5>
                    <p class="text-muted small">Selecione o aluno e marque quais blocos de treino ele deve realizar.</p>
                    
                    <form id="form-vincular-treino">
                        <div class="mb-3">
                            <label for="select-aluno" class="form-label fw-semibold">Selecionar Aluno</label>
                            <select class="form-select" id="select-aluno" name="cpf_aluno" required>
                                <option value="" selected disabled>Escolha um aluno...</option>
                                <option value="11122233344">Isaque (CPF: 111.222.333-44)</option>
                                <option value="99988877766">Rodrigo Silva (CPF: 999.888.777-66)</option>
                            </select>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-semibold d-block">Selecione os Blocos Ativos</label>
                            <p class="text-muted card-text small mt-0 mb-2">Os treinos selecionados serão vinculados diretamente ao perfil do aluno.</p>
                            
                            <div class="form-check form-check-inline">
                                <input class="form-check-input chk-treino" type="checkbox" name="treinos" id="chk-a" value="1">
                                <label class="form-check-input-label fw-medium" for="chk-a">Treino A</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input chk-treino" type="checkbox" name="treinos" id="chk-b" value="2">
                                <label class="form-check-input-label fw-medium" for="chk-b">Treino B</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input chk-treino" type="checkbox" name="treinos" id="chk-c" value="3">
                                <label class="form-check-input-label fw-medium" for="chk-c">Treino C</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input chk-treino" type="checkbox" name="treinos" id="chk-d" value="4">
                                <label class="form-check-input-label fw-medium" for="chk-d">Treino D</label>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 fw-bold" id="btn-salvar-aluno-treino">
                            <span class="spinner-border spinner-border-sm d-none" role="status"></span>
                            Atualizar Ficha do Aluno
                        </button>
                    </form>
                </div>
            </div>

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
            // Rola a página suavemente para o topo onde está o alerta
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        // --- AJAX 1: VINCULAR OU TROCAR TREINO DO ALUNO ---
        $('#form-vincular-treino').on('submit', function(e) {
            e.preventDefault();
            
            let btn = $('#btn-salvar-aluno-treino');
            let spinner = btn.find('.spinner-border');
            
            btn.prop('disabled', true);
            spinner.removeClass('d-none');

            let formData = $(this).serialize();

            $.ajax({
                url: 'FuncionarioController', // <-- URL da Servlet de controle do Funcionário
                type: 'POST',
                data: formData + '&acao=vincularTreino', // Envia flag de ação
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        exibirAlerta(response.message || 'Ficha de treinos do aluno atualizada com sucesso!', true);
                    } else {
                        exibirAlerta(response.message || 'Erro ao atualizar treinos do aluno.', false);
                    }
                },
                error: function() {
                    exibirAlerta('Erro técnico de comunicação ao salvar a ficha do aluno.', false);
                },
                complete: function() {
                    btn.prop('disabled', false);
                    spinner.addClass('d-none');
                }
            });
        });

        // --- AJAX 2: CRIAR OU EDITAR UM BLOCO DE TREINO ---
        $('#form-criar-treino').on('submit', function(e) {
            e.preventDefault();
            
            let btn = $('#btn-salvar-bloco');
            let spinner = btn.find('.spinner-border');
            
            btn.prop('disabled', true);
            spinner.removeClass('d-none');

            let formData = $(this).serialize();

            $.ajax({
                url: 'FuncionarioController', // <-- Mesma Servlet cuidando da criação de estruturas
                type: 'POST',
                data: formData + '&acao=criarBloco', // Envia flag de ação diferente
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        exibirAlerta(response.message || 'Estrutura do Bloco salva com sucesso no banco!', true);
                        $('#form-criar-treino')[0].reset();
                    } else {
                        exibirAlerta(response.message || 'Erro ao salvar o bloco de treino.', false);
                    }
                },
                error: function() {
                    exibirAlerta('Erro técnico de comunicação ao salvar o bloco.', false);
                },
                complete: function() {
                    btn.prop('disabled', false);
                    spinner.addClass('d-none');
                }
            });
        });

        // Evento extra opcional: Quando o funcionário trocar o aluno no Select, 
        // você poderia disparar um AJAX GET rápido para buscar quais treinos ele já tem ativos 
        // e marcar os checkboxes automaticamente na tela.
    });
    </script>
</body>
</html>