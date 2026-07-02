<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.academia.util.DbConnection" %>
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
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px 0;
        }
        .auth-card {
            width: 100%;
            max-width: 500px;
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
    
    <!-- Painel de Login / Cadastro normal -->
    <div id="auth-pane">
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
            
            <!-- Login -->
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
                    
                    <div class="text-end mb-3">
                        <a href="#" class="text-decoration-none small" data-bs-toggle="modal" data-bs-target="#modalRecuperar">Esqueci minha senha</a>
                    </div>

                    <div class="d-grid mt-4">
                        <button type="submit" class="btn btn-primary" id="btn-login">
                            <span class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                            Entrar
                        </button>
                    </div>
                </form>
            </div>

            <!-- Cadastro -->
            <div class="tab-pane fade" id="register-pane" role="tabpanel">
                <div id="register-alert" class="alert d-none" role="alert"></div>
                <form id="form-register">
                    <div class="mb-3">
                        <label for="reg-nome" class="form-label fw-semibold">Nome Completo</label>
                        <input type="text" class="form-control" id="reg-nome" name="nome" required placeholder="João da Silva">
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="reg-cpf" class="form-label fw-semibold">CPF</label>
                            <input type="text" class="form-control" id="reg-cpf" name="cpf" required placeholder="123.456.789-00">
                        </div>
                        <div class="col-md-6">
                            <label for="reg-idade" class="form-label fw-semibold">Idade</label>
                            <input type="number" class="form-control" id="reg-idade" name="idade" required min="12" max="120" placeholder="Ex: 25">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="reg-telefone" class="form-label fw-semibold">Telefone</label>
                        <input type="text" class="form-control" id="reg-telefone" name="telefone" required placeholder="(11) 99999-9999">
                    </div>
                    <div class="mb-3">
                        <label for="reg-plano" class="form-label fw-semibold">Escolha seu Plano</label>
                        <select class="form-select" id="reg-plano" name="idPlano" required>
                            <option value="" selected disabled>Selecione um plano...</option>
                            <%
                                Connection connPlano = null;
                                PreparedStatement psPlano = null;
                                ResultSet rsPlano = null;
                                try {
                                    connPlano = DbConnection.getConnection();
                                    String sqlPlano = "SELECT idPlano, nome, preco FROM Plano WHERE status = true ORDER BY nome ASC";
                                    psPlano = connPlano.prepareStatement(sqlPlano);
                                    rsPlano = psPlano.executeQuery();
                                    while (rsPlano.next()) {
                                        int idPlano = rsPlano.getInt("idPlano");
                                        String nomePlano = rsPlano.getString("nome");
                                        double precoPlano = rsPlano.getDouble("preco");
                            %>
                                        <option value="<%= idPlano %>"><%= nomePlano %> - R$ <%= String.format("%.2f", precoPlano) %></option>
                            <%
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if (rsPlano != null) try { rsPlano.close(); } catch (Exception e) {}
                                    if (psPlano != null) try { psPlano.close(); } catch (Exception e) {}
                                    if (connPlano != null) try { connPlano.close(); } catch (Exception e) {}
                                }
                            %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="reg-email" class="form-label fw-semibold">E-mail</label>
                        <input type="email" class="form-control" id="reg-email" name="email" required placeholder="joao@exemplo.com">
                    </div>
                    <div class="mb-3">
                        <label for="reg-senha" class="form-label fw-semibold">Senha</label>
                        <input type="password" class="form-control" id="reg-senha" name="senha" required minlength="6" placeholder="Mínimo 6 caracteres">
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

    <!-- Painel de Redefinição de Senha (mostrado apenas se houver token na URL) -->
    <div id="redefinir-pane" class="d-none">
        <div class="text-center mb-4">
            <h3 class="fw-bold text-primary">🔒 Nova Senha</h3>
            <p class="text-muted small">Crie uma nova senha para sua conta</p>
        </div>
        <div id="redefinir-alert" class="alert d-none" role="alert"></div>
        <form id="form-redefinir">
            <input type="hidden" id="redefinir-token">
            <div class="mb-3">
                <label for="redefinir-nova-senha" class="form-label">Nova Senha</label>
                <input type="password" class="form-control" id="redefinir-nova-senha" required placeholder="Mínimo 6 caracteres">
            </div>
            <div class="mb-3">
                <label for="redefinir-confirma-senha" class="form-label">Confirmar Nova Senha</label>
                <input type="password" class="form-control" id="redefinir-confirma-senha" required placeholder="Confirme a nova senha">
            </div>
            <div class="d-grid mt-4">
                <button type="submit" class="btn btn-primary" id="btn-redefinir">
                    <span class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                    Salvar Nova Senha
                </button>
            </div>
            <div class="text-center mt-3">
                <a href="acesso.jsp" class="text-decoration-none small">Voltar para o Login</a>
            </div>
        </form>
    </div>

</div>

<!-- Modal de Recuperação de Senha -->
<div class="modal fade" id="modalRecuperar" tabindex="-1" aria-labelledby="modalRecuperarLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold" id="modalRecuperarLabel">Recuperar Senha</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fechar"></button>
            </div>
            <div class="modal-body">
                <div id="recuperar-alert" class="alert d-none" role="alert"></div>
                <form id="form-recuperar">
                    <p class="text-muted small">Digite seu e-mail cadastrado e enviaremos um link para você redefinir sua senha.</p>
                    <div class="mb-3">
                        <label for="rec-email" class="form-label">E-mail</label>
                        <input type="email" class="form-control" id="rec-email" required placeholder="seuemail@exemplo.com">
                    </div>
                    <div class="d-grid mt-4">
                        <button type="submit" class="btn btn-primary" id="btn-recuperar">
                            <span class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                            Enviar Link
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
$(document).ready(function() {

    // --- VERIFICA PARÂMETROS NA URL ---
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

    const tokenParam = urlParams.get('token');
    if (tokenParam) {
        $('#auth-pane').addClass('d-none');
        $('#redefinir-pane').removeClass('d-none');
        $('#redefinir-token').val(tokenParam);
    }

    // --- AJAX DO LOGIN ---
    $('#form-login').on('submit', function(e) {
        e.preventDefault();
        
        let alertBox = $('#login-alert');
        let btn = $('#btn-login');
        let spinner = btn.find('.spinner-border');

        alertBox.addClass('d-none').removeClass('alert-success alert-danger');
        btn.prop('disabled', true);
        spinner.removeClass('d-none');

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

        let formData = {
            nome: $('#reg-nome').val(),
            email: $('#reg-email').val(),
            senha: $('#reg-senha').val(),
            cpf: $('#reg-cpf').val(),
            idade: parseInt($('#reg-idade').val()),
            telefone: $('#reg-telefone').val(),
            idPlano: parseInt($('#reg-plano').val()),
            role: 'ALUNO'
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

    // --- AJAX DE SOLICITAR RECUPERAÇÃO ---
    $('#form-recuperar').on('submit', function(e) {
        e.preventDefault();
        let alertBox = $('#recuperar-alert');
        let btn = $('#btn-recuperar');
        let spinner = btn.find('.spinner-border');

        alertBox.addClass('d-none').removeClass('alert-success alert-danger');
        btn.prop('disabled', true);
        spinner.removeClass('d-none');

        let email = $('#rec-email').val();

        $.ajax({
            url: 'api/recuperar-senha',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({ email: email }),
            dataType: 'json',
            success: function(response) {
                alertBox.addClass('alert-success').text(response.mensagem).removeClass('d-none');
                $('#form-recuperar')[0].reset();
                btn.prop('disabled', false);
                spinner.addClass('d-none');
            },
            error: function(xhr) {
                let msg = 'Erro ao solicitar recuperação.';
                if (xhr.responseJSON && xhr.responseJSON.mensagem) {
                    msg = xhr.responseJSON.mensagem;
                }
                alertBox.addClass('alert-danger').text(msg).removeClass('d-none');
                btn.prop('disabled', false);
                spinner.addClass('d-none');
            }
        });
    });

    // --- AJAX DE REDEFINIR SENHA ---
    $('#form-redefinir').on('submit', function(e) {
        e.preventDefault();
        
        let alertBox = $('#redefinir-alert');
        let btn = $('#btn-redefinir');
        let spinner = btn.find('.spinner-border');
        
        let token = $('#redefinir-token').val();
        let novaSenha = $('#redefinir-nova-senha').val();
        let confirmaSenha = $('#redefinir-confirma-senha').val();

        if (novaSenha !== confirmaSenha) {
            alertBox.addClass('alert-danger').text('As senhas não coincidem.').removeClass('d-none');
            return;
        }

        alertBox.addClass('d-none').removeClass('alert-success alert-danger');
        btn.prop('disabled', true);
        spinner.removeClass('d-none');

        $.ajax({
            url: 'api/recuperar-senha',
            type: 'PUT',
            contentType: 'application/json',
            data: JSON.stringify({
                token: token,
                novaSenha: novaSenha
            }),
            dataType: 'json',
            success: function(response) {
                alertBox.addClass('alert-success').text(response.mensagem + ' Redirecionando para o login...').removeClass('d-none');
                setTimeout(function() {
                    window.location.href = 'acesso.jsp';
                }, 2000);
            },
            error: function(xhr) {
                let msg = 'Erro ao redefinir a senha.';
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