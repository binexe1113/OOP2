<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema Academia - Acesso</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f6f9;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .auth-card {
            width: 100%;
            max-width: 450px;
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        .nav-tabs .nav-link {
            color: #495057;
            font-weight: 500;
        }
        .nav-tabs .nav-link.active {
            font-weight: bold;
            color: #0d6efd;
        }
    </style>
</head>
<body>

<div class="card auth-card bg-white p-4">
    <div class="text-center mb-4">
        <h3 class="fw-bold text-primary">💪 Academia Fit</h3>
        <p class="text-muted small">Gerencie seus treinos e matrículas</p>
    </div>

    <ul class="nav nav-tabs nav-fill mb-4" id="authTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" id="login-tab" data-bs-toggle="tab" data-bs-target="#login-pane" type="button" role="tab">Entrar</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="register-tab" data-bs-toggle="tab" data-bs-target="#register-pane" type="button" role="tab">Cadastrar-se</button>
        </li>
    </ul>

    <div class="tab-content" id="authTabsContent">
        
        <div class="tab-pane fade show active" id="login-pane" role="tabpanel">
            <div id="login-alert" class="alert d-none" role="alert"></div>
            <form id="form-login">
                <div class="mb-3">
                    <label for="login-email" class="form-label">E-mail</label>
                    <input type="email" class="form-control" id="login-email" name="email" required placeholder="seuemail@exemplo.com">
                </div>
                <div class="mb-3">
                    <label for="login-senha" class="form-label">Senha</label>
                    <input type="password" class="form-control" id="login-senha" name="senha" required placeholder="••••••••">
                </div>
                <div class="d-grid mt-4">
                    <button type="submit" class="btn btn-primary" id="btn-login">
                        <span class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                        Entrar
                    </button>
                </div>
            </form>
        </div>

        <div class="tab-pane fade" id="register-pane" role="tabpanel">
            <div id="register-alert" class="alert d-none" role="alert"></div>
            <form id="form-register">
                <div class="mb-3">
                    <label for="reg-nome" class="form-label">Nome Completo</label>
                    <input type="text" class="form-control" id="reg-nome" name="nome" required placeholder="João da Silva">
                </div>
                <div class="mb-3">
                    <label for="reg-email" class="form-label">E-mail</label>
                    <input type="email" class="form-control" id="reg-email" name="email" required placeholder="joao@exemplo.com">
                </div>
                <div class="mb-3">
                    <label for="reg-senha" class="form-label">Senha</label>
                    <input type="password" class="form-control" id="reg-senha" name="senha" required placeholder="Mínimo 6 caracteres">
                </div>
                <div class="d-grid mt-4">
                    <button type="submit" class="btn btn-success" id="btn-register">
                        <span class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                        Criar Conta
                    </button>
                </div>
            </form>
        </div>
        
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
$(document).ready(function() {

    // --- VERIFICA PARÂMETROS DE ATIVAÇÃO NA URL ---
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('ativado')) {
        $('#login-alert').addClass('alert-success').text('Sua conta foi ativada com sucesso! Faça login abaixo.').removeClass('d-none');
    } else if (urlParams.has('erroAtivacao')) {
        const erro = urlParams.get('erroAtivacao');
        let msg = 'Erro ao ativar a conta.';
        if (erro === 'invalido') msg = 'Token de ativação inválido.';
        else if (erro === 'nao_encontrado') msg = 'Link de ativação expirado ou já utilizado.';
        else if (erro === 'db_erro' || erro === 'banco') msg = 'Erro interno do servidor ao ativar.';
        $('#login-alert').addClass('alert-danger').text(msg).removeClass('d-none');
    }

    // --- AJAX DO LOGIN ---
    $('#form-login').on('submit', function(e) {
        e.preventDefault(); // Impede o reload da página
        
        let alertBox = $('#login-alert');
        let btn = $('#btn-login');
        let spinner = btn.find('.spinner-border');

        // Reseta alertas e ativa loading
        alertBox.addClass('d-none').removeClass('alert-success alert-danger');
        btn.prop('disabled', true);
        spinner.removeClass('d-none');

        // Captura os dados do formulário como JSON
        let formData = {
            email: $('#login-email').val(),
            senha: $('#login-senha').val()
        };

        $.ajax({
            url: 'api/login',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(formData),
            dataType: 'json',
            success: function(response) {
                if (response.sucesso) {
                    alertBox.addClass('alert-success').text(response.mensagem || 'Login efetuado com sucesso! Redirecionando...').removeClass('d-none');
                    setTimeout(function() {
                        let urlDestino = 'index.jsp';
                        if (response.role === 'ALUNO') urlDestino = 'aluno.jsp';
                        else if (response.role === 'FUNCIONARIO') urlDestino = 'funcionario.jsp';
                        else if (response.role === 'GERENTE') urlDestino = 'gerente.jsp';
                        window.location.href = urlDestino;
                    }, 1500);
                } else {
                    alertBox.addClass('alert-danger').text(response.mensagem || 'Credenciais inválidas.').removeClass('d-none');
                    btn.prop('disabled', false);
                    spinner.addClass('d-none');
                }
            },
            error: function(xhr) {
                let msg = 'Erro ao comunicar com o servidor.';
                if (xhr.responseJSON && xhr.responseJSON.mensagem) {
                    msg = xhr.responseJSON.mensagem;
                }
                alertBox.addClass('alert-danger').text(msg).removeClass('d-none');
                btn.prop('disabled', false);
                spinner.addClass('d-none');
            }
        });
    });

    // --- AJAX DO REGISTRO ---
    $('#form-register').on('submit', function(e) {
        e.preventDefault();
        
        let alertBox = $('#register-alert');
        let btn = $('#btn-register');
        let spinner = btn.find('.spinner-border');

        alertBox.addClass('d-none').removeClass('alert-success alert-danger');
        btn.prop('disabled', true);
        spinner.removeClass('d-none');

        // Captura os dados do formulário como JSON
        let formData = {
            nome: $('#reg-nome').val(),
            email: $('#reg-email').val(),
            senha: $('#reg-senha').val(),
            role: 'ALUNO' // Por padrão, novos cadastros pela página são ALUNOS
        };

        $.ajax({
            url: 'api/cadastro',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(formData),
            dataType: 'json',
            success: function(response) {
                if (response.sucesso) {
                    alertBox.addClass('alert-success').text(response.mensagem).removeClass('d-none');
                    $('#form-register')[0].reset();
                    btn.prop('disabled', false);
                    spinner.addClass('d-none');
                } else {
                    alertBox.addClass('alert-danger').text(response.mensagem || 'Erro ao registrar usuário.').removeClass('d-none');
                    btn.prop('disabled', false);
                    spinner.addClass('d-none');
                }
            },
            error: function(xhr) {
                let msg = 'Erro técnico ao processar requisição.';
                if (xhr.responseJSON && xhr.responseJSON.mensagem) {
                    msg = xhr.responseJSON.mensagem;
                }
                alertBox.addClass('alert-danger').text(msg).removeClass('d-none');
                btn.prop('disabled', false);
                spinner.addClass('d-none');
            }
        });
    });
});
</script>

</body>
</html>