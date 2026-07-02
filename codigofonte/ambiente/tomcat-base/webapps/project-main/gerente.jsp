<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.academia.util.DbConnection" %>
<%@ page import="com.academia.model.Usuario" %>
<%
    // Garante que apenas usuários logados com perfil GERENTE possam acessar
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
    if (usuarioLogado == null) {
        response.sendRedirect("acesso.jsp");
        return;
    }
    if (!"GERENTE".equalsIgnoreCase(usuarioLogado.getRole())) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acesso restrito para gerentes.");
        return;
    }

    String nomeGerente = "";
    String cpfGerente = "";
    try (Connection connGer = DbConnection.getConnection();
         PreparedStatement psGer = connGer.prepareStatement("SELECT nome, cpf FROM Funcionario WHERE idUsuario = ?")) {
        psGer.setInt(1, usuarioLogado.getIdUsuario());
        try (ResultSet rsGer = psGer.executeQuery()) {
            if (rsGer.next()) {
                nomeGerente = rsGer.getString("nome");
                cpfGerente = rsGer.getString("cpf");
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
    <title>Painel do Gerente - Níveis de Acesso</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .custom-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }
    </style>
</head>
<body class="bg-light">

    <nav class="navbar navbar-dark bg-dark mb-4">
        <div class="container">
            <span class="navbar-brand mb-0 h1 fw-bold text-warning">
                <i class="fas fa-shield-halved me-2"></i> Painel Administrativo
            </span>
            <div>
                <a href="gerenciar-planos.jsp" class="btn btn-sm btn-outline-warning me-2">
                    <i class="fas fa-tags me-1"></i> Gerenciar Planos
                </a>
                <button class="btn btn-sm btn-outline-light me-2" data-bs-toggle="modal" data-bs-target="#modalPerfil">
                    <i class="fas fa-user-cog me-1"></i> Meus Dados
                </button>
                <span class="text-white small me-3">Olá, <%= nomeGerente.isEmpty() ? usuarioLogado.getEmailLogin() : nomeGerente %></span>
                <a href="api/logout" class="btn btn-sm btn-danger"><i class="fas fa-sign-out-alt me-1"></i> Sair</a>
            </div>
        </div>
    </nav>

    <div class="container mb-5">
        <div class="card custom-card p-4 mb-4 bg-white">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                <div>
                    <h4 class="fw-bold text-dark mb-1">Controle de Nível de Acesso</h4>
                    <p class="text-muted small mb-0">Altere as permissões dos usuários do sistema em tempo real.</p>
                </div>
                <div class="input-group style-select" style="max-width: 350px;">
                    <span class="input-group-text bg-white border-end-0"><i class="fas fa-search text-muted"></i></span>
                    <input type="text" id="busca-usuario" class="form-control border-start-0" placeholder="Buscar por nome, email ou CPF...">
                </div>
            </div>

            <div id="alert-gerente" class="alert d-none" role="alert"></div>

            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>CPF</th>
                            <th>Nome / Email</th>
                            <th>Nível Atual</th>
                            <th class="text-center" style="width: 250px;">Alterar Permissão</th>
                            <th class="text-center" style="width: 150px;">Excluir</th>
                        </tr>
                    </thead>
                    <tbody id="tabela-usuarios">
                        <%
                            Connection conn = null;
                            PreparedStatement ps = null;
                            ResultSet rs = null;
                            try {
                                conn = DbConnection.getConnection();
                                String sql = "SELECT u.idUsuario, u.emailLogin, u.role, "
                                           + "COALESCE(a.nome, f.nome, 'Sem Nome Cadastrado') AS nome, "
                                           + "COALESCE(a.cpf, f.cpf, 'N/A') AS cpf "
                                           + "FROM Usuario u "
                                           + "LEFT JOIN Aluno a ON u.idUsuario = a.idUsuario "
                                           + "LEFT JOIN Funcionario f ON u.idUsuario = f.idUsuario "
                                           + "ORDER BY nome ASC";
                                ps = conn.prepareStatement(sql);
                                rs = ps.executeQuery();
                                while (rs.next()) {
                                    int idUsuario = rs.getInt("idUsuario");
                                    String email = rs.getString("emailLogin");
                                    String role = rs.getString("role");
                                    String nome = rs.getString("nome");
                                    String cpf = rs.getString("cpf");
                        %>
                                    <tr data-id="<%= idUsuario %>">
                                        <td class="fw-medium text-secondary"><%= cpf %></td>
                                        <td>
                                            <div class="fw-bold text-dark"><%= nome %></div>
                                            <div class="text-muted small"><%= email %></div>
                                        </td>
                                        <td>
                                            <% if ("GERENTE".equalsIgnoreCase(role)) { %>
                                                <span class="badge bg-danger px-3 py-2">GERENTE</span>
                                            <% } else if ("FUNCIONARIO".equalsIgnoreCase(role)) { %>
                                                <span class="badge bg-success px-3 py-2">FUNCIONARIO</span>
                                            <% } else { %>
                                                <span class="badge bg-primary px-3 py-2">ALUNO</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <select class="form-select form-select-sm select-nivel">
                                                <option value="ALUNO" <%= "ALUNO".equalsIgnoreCase(role) ? "selected" : "" %>>Aluno</option>
                                                <option value="FUNCIONARIO" <%= "FUNCIONARIO".equalsIgnoreCase(role) ? "selected" : "" %>>Funcionário</option>
                                                <option value="GERENTE" <%= "GERENTE".equalsIgnoreCase(role) ? "selected" : "" %>>Gerente</option>
                                            </select>
                                        </td>
                                        <td class="text-center">
                                            <% if (idUsuario != usuarioLogado.getIdUsuario()) { %>
                                                <button class="btn btn-sm btn-danger btn-excluir" data-id="<%= idUsuario %>" data-nome="<%= nome %>">
                                                    <i class="fas fa-trash-alt me-1"></i> Excluir
                                                </button>
                                            <% } else { %>
                                                <span class="badge bg-secondary">Você (Logado)</span>
                                            <% } %>
                                        </td>
                                    </tr>
                        <%
                                }
                            } catch (Exception e) {
                                out.println("<tr><td colspan='4' class='text-center text-danger'>Erro ao carregar usuários: " + e.getMessage() + "</td></tr>");
                                e.printStackTrace();
                            } finally {
                                if (rs != null) try { rs.close(); } catch (Exception e) {}
                                if (ps != null) try { ps.close(); } catch (Exception e) {}
                                if (conn != null) try { conn.close(); } catch (Exception e) {}
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
    $(document).ready(function() {
        
        // --- FILTRO DE BUSCA DINÂMICO ---
        $("#busca-usuario").on("keyup", function() {
            let value = $(this).val().toLowerCase();
            $("#tabela-usuarios tr").filter(function() {
                $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
            });
        });

        // --- DISPARO AJAX AO MUDAR O SELECT ---
        $(document).on('change', '.select-nivel', function() {
            let selectElement = $(this);
            let novoNivel = selectElement.val();
            let idUsuario = selectElement.closest('tr').attr('data-id');
            let alertBox = $('#alert-gerente');

            // Desabilita o select temporariamente durante a requisição
            selectElement.prop('disabled', true);
            alertBox.addClass('d-none').removeClass('alert-success alert-danger');

            $.ajax({
                url: 'api/atualizar-acesso',
                type: 'POST',
                data: {
                    idUsuario: idUsuario,
                    nivel: novoNivel
                },
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        alertBox.removeClass('d-none alert-danger').addClass('alert-success')
                                 .text('Nível de acesso atualizado com sucesso para ' + novoNivel + '!');
                        
                        // Atualiza visualmente o Badge de texto na tabela
                        let badge = selectElement.closest('tr').find('.badge');
                        badge.text(novoNivel);
                        
                        // Altera a cor do badge dinamicamente
                        badge.removeClass('bg-primary bg-success bg-danger');
                        if (novoNivel === 'ALUNO') badge.addClass('bg-primary');
                        if (novoNivel === 'FUNCIONARIO') badge.addClass('bg-success');
                        if (novoNivel === 'GERENTE') badge.addClass('bg-danger');

                    } else {
                        alertBox.removeClass('d-none alert-success').addClass('alert-danger')
                                 .text(response.message || 'Erro ao alterar permissão.');
                    }
                },
                error: function(xhr) {
                    let errorMsg = 'Erro crítico de comunicação com o servidor.';
                    if (xhr.responseJSON && xhr.responseJSON.message) {
                        errorMsg = xhr.responseJSON.message;
                    }
                    alertBox.removeClass('d-none alert-success').addClass('alert-danger')
                             .text(errorMsg);
                },
                complete: function() {
                    // Reabilita o select após a resposta terminar
                    selectElement.prop('disabled', false);
                    
                    // Esconde o alerta automaticamente após 3 segundos
                    setTimeout(function() {
                        alertBox.addClass('d-none');
                    }, 3000);
                }
            });
        });

        // --- DISPARO AJAX AO CLICAR EM EXCLUIR ---
        $(document).on('click', '.btn-excluir', function() {
            let btn = $(this);
            let idUsuario = btn.attr('data-id');
            let nomeAluno = btn.attr('data-nome');
            let alertBox = $('#alert-gerente');

            if (confirm("Tem certeza que deseja excluir o usuário " + nomeAluno + "? Esta ação é irreversível e excluirá todo seu histórico associado.")) {
                btn.prop('disabled', true);
                alertBox.addClass('d-none').removeClass('alert-success alert-danger');

                $.ajax({
                    url: 'api/excluir-usuario',
                    type: 'POST',
                    data: {
                        idUsuario: idUsuario
                    },
                    dataType: 'json',
                    success: function(response) {
                        if (response.success) {
                            alertBox.removeClass('d-none alert-danger').addClass('alert-success').text(response.message);
                            // Remove a linha correspondente da tabela com efeito fadeOut
                            btn.closest('tr').fadeOut(600, function() {
                                $(this).remove();
                            });
                        } else {
                            alertBox.removeClass('d-none alert-success').addClass('alert-danger').text(response.message || 'Erro ao excluir usuário.');
                            btn.prop('disabled', false);
                        }
                    },
                    error: function(xhr) {
                        let errorMsg = 'Erro ao processar exclusão de usuário.';
                        if (xhr.responseJSON && xhr.responseJSON.message) {
                            errorMsg = xhr.responseJSON.message;
                        }
                        alertBox.removeClass('d-none alert-success').addClass('alert-danger').text(errorMsg);
                        btn.prop('disabled', false);
                    },
                    complete: function() {
                        setTimeout(function() {
                            alertBox.addClass('d-none');
                        }, 4000);
                    }
                });
            }
        });

        // --- AJAX: ATUALIZAR PERFIL DO GERENTE ---
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

    <!-- Modal Perfil Gerente -->
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
                            <input type="text" class="form-control" id="perf-nome" required value="<%= nomeGerente %>">
                        </div>
                        <div class="mb-3">
                            <label for="perf-cpf" class="form-label fw-semibold">CPF (não alterável)</label>
                            <input type="text" class="form-control bg-light" id="perf-cpf" value="<%= cpfGerente %>" readonly>
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