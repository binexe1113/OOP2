<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.academia.model.Usuario" %>
<%@ page import="com.academia.model.Plano" %>
<%@ page import="com.academia.dao.PlanoDAO" %>
<%@ page import="java.util.List" %>
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

    PlanoDAO planoDAO = new PlanoDAO();
    List<Plano> planos = null;
    try {
        planos = planoDAO.listarTodos();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gerenciamento de Planos - Academia Fit</title>
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

    <nav class="navbar navbar-dark bg-dark mb-4 shadow-sm">
        <div class="container">
            <span class="navbar-brand mb-0 h1 fw-bold text-warning">
                <i class="fas fa-tags me-2"></i> Gerenciamento de Planos
            </span>
            <div>
                <a href="gerente.jsp" class="btn btn-sm btn-outline-light me-2">
                    <i class="fas fa-arrow-left me-1"></i> Painel Geral
                </a>
                <span class="text-white small">Olá, Gerente</span>
            </div>
        </div>
    </nav>

    <div class="container mb-5">
        
        <div id="plano-global-alert" class="alert d-none" role="alert"></div>

        <div class="card custom-card bg-white p-4 mb-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold mb-0 text-dark"><i class="fas fa-list text-primary me-2"></i> Planos Cadastrados</h5>
                <button class="btn btn-success fw-semibold" data-bs-toggle="modal" data-bs-target="#modalNovoPlano">
                    <i class="fas fa-plus me-1"></i> Novo Plano
                </button>
            </div>
            
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th scope="col"># ID</th>
                            <th scope="col">Nome do Plano</th>
                            <th scope="col">Preço Mensal</th>
                            <th scope="col">Descrição</th>
                            <th scope="col" class="text-center">Status</th>
                            <th scope="col" class="text-end">Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (planos == null || planos.isEmpty()) { %>
                            <tr>
                                <td colspan="6" class="text-center text-muted p-4">Nenhum plano cadastrado no banco.</td>
                            </tr>
                        <% } else { 
                            for (Plano p : planos) { %>
                            <tr>
                                <td><strong><%= p.getIdPlano() %></strong></td>
                                <td><span class="fw-semibold text-dark"><%= p.getNome() %></span></td>
                                <td><span class="text-success fw-bold">R$ <%= String.format("%.2f", p.getPreco()) %></span></td>
                                <td><span class="text-muted small"><%= p.getDescricao() != null ? p.getDescricao() : "Sem descrição" %></span></td>
                                <td class="text-center">
                                    <% if (p.isStatus()) { %>
                                        <span class="badge bg-success">Ativo</span>
                                    <% } else { %>
                                        <span class="badge bg-danger">Inativo</span>
                                    <% } %>
                                </td>
                                <td class="text-end">
                                    <button class="btn btn-sm btn-primary btn-editar-plano me-1" 
                                            data-id="<%= p.getIdPlano() %>" 
                                            data-nome="<%= p.getNome() %>" 
                                            data-preco="<%= p.getPreco() %>" 
                                            data-descricao="<%= p.getDescricao() != null ? p.getDescricao() : "" %>" 
                                            data-status="<%= p.isStatus() %>" 
                                            data-bs-toggle="modal" 
                                            data-bs-target="#modalEditarPlano">
                                        <i class="fas fa-edit me-1"></i> Editar
                                    </button>
                                    <button class="btn btn-sm btn-danger btn-excluir-plano" 
                                            data-id="<%= p.getIdPlano() %>" 
                                            data-nome="<%= p.getNome() %>">
                                        <i class="fas fa-trash-alt me-1"></i> Excluir
                                    </button>
                                </td>
                            </tr>
                        <% } 
                        } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Modal Novo Plano -->
    <div class="modal fade" id="modalNovoPlano" tabindex="-1" aria-labelledby="modalNovoPlanoLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold" id="modalNovoPlanoLabel"><i class="fas fa-plus-circle me-2"></i> Criar Novo Plano</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fechar"></button>
                </div>
                <div class="modal-body">
                    <div id="novo-plano-alert" class="alert d-none" role="alert"></div>
                    <form id="form-novo-plano">
                        <div class="mb-3">
                            <label for="novo-nome" class="form-label fw-semibold">Nome do Plano</label>
                            <input type="text" class="form-control" id="novo-nome" required placeholder="Ex: Mensal Gold">
                        </div>
                        <div class="mb-3">
                            <label for="novo-preco" class="form-label fw-semibold">Preço Mensal (R$)</label>
                            <input type="number" step="0.01" class="form-control" id="novo-preco" required placeholder="Ex: 89.90">
                        </div>
                        <div class="mb-3">
                            <label for="novo-descricao" class="form-label fw-semibold">Descrição</label>
                            <textarea class="form-control" id="novo-descricao" rows="3" placeholder="Benefícios do plano..."></textarea>
                        </div>
                        <div class="mb-3 form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="novo-status" checked>
                            <label class="form-check-label fw-semibold" for="novo-status">Plano Ativo</label>
                        </div>
                        <div class="d-grid mt-4">
                            <button type="submit" class="btn btn-success" id="btn-criar-plano">
                                <span class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                                Cadastrar Plano
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Editar Plano -->
    <div class="modal fade" id="modalEditarPlano" tabindex="-1" aria-labelledby="modalEditarPlanoLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold" id="modalEditarPlanoLabel"><i class="fas fa-edit me-2"></i> Editar Plano</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fechar"></button>
                </div>
                <div class="modal-body">
                    <div id="editar-plano-alert" class="alert d-none" role="alert"></div>
                    <form id="form-editar-plano">
                        <input type="hidden" id="edit-id">
                        <div class="mb-3">
                            <label for="edit-nome" class="form-label fw-semibold">Nome do Plano</label>
                            <input type="text" class="form-control" id="edit-nome" required>
                        </div>
                        <div class="mb-3">
                            <label for="edit-preco" class="form-label fw-semibold">Preço Mensal (R$)</label>
                            <input type="number" step="0.01" class="form-control" id="edit-preco" required>
                        </div>
                        <div class="mb-3">
                            <label for="edit-descricao" class="form-label fw-semibold">Descrição</label>
                            <textarea class="form-control" id="edit-descricao" rows="3"></textarea>
                        </div>
                        <div class="mb-3 form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="edit-status">
                            <label class="form-check-label fw-semibold" for="edit-status">Plano Ativo</label>
                        </div>
                        <div class="d-grid mt-4">
                            <button type="submit" class="btn btn-primary" id="btn-atualizar-plano">
                                <span class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                                Salvar Alterações
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

            // Preenche modal de edição ao clicar no botão Editar
            $('.btn-editar-plano').on('click', function() {
                $('#edit-id').val($(this).data('id'));
                $('#edit-nome').val($(this).data('nome'));
                $('#edit-preco').val($(this).data('preco'));
                $('#edit-descricao').val($(this).data('descricao'));
                
                let statusVal = $(this).data('status');
                // Se for string "true" ou booleano true
                $('#edit-status').prop('checked', statusVal === true || statusVal === 'true');
            });

            // AJAX: Criar Novo Plano
            $('#form-novo-plano').on('submit', function(e) {
                e.preventDefault();
                let btn = $('#btn-criar-plano');
                let spinner = btn.find('.spinner-border');
                let alertBox = $('#novo-plano-alert');

                alertBox.addClass('d-none').removeClass('alert-success alert-danger');
                btn.prop('disabled', true);
                spinner.removeClass('d-none');

                let formData = {
                    acao: 'criar',
                    nome: $('#novo-nome').val(),
                    preco: parseFloat($('#novo-preco').val()),
                    descricao: $('#novo-descricao').val(),
                    status: $('#novo-status').is(':checked')
                };

                $.ajax({
                    url: 'api/plano',
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
                            alertBox.removeClass('d-none').addClass('alert-danger').text(response.mensagem);
                            btn.prop('disabled', false);
                            spinner.addClass('d-none');
                        }
                    },
                    error: function(xhr) {
                        let msg = 'Erro ao processar criação de plano.';
                        if (xhr.responseJSON && xhr.responseJSON.mensagem) {
                            msg = xhr.responseJSON.mensagem;
                        }
                        alertBox.removeClass('d-none').addClass('alert-danger').text(msg);
                        btn.prop('disabled', false);
                        spinner.addClass('d-none');
                    }
                });
            });

            // AJAX: Excluir Plano
            $(document).on('click', '.btn-excluir-plano', function() {
                let btn = $(this);
                let idPlano = btn.data('id');
                let nomePlano = btn.data('nome');
                let alertBox = $('#plano-global-alert');

                if (confirm("Tem certeza que deseja excluir o plano \"" + nomePlano + "\"? Esta ação é permanente e só poderá ser executada se não houver matrículas vinculadas.")) {
                    btn.prop('disabled', true);
                    alertBox.addClass('d-none').removeClass('alert-success alert-danger');

                    let formData = {
                        acao: 'excluir',
                        idPlano: parseInt(idPlano)
                    };

                    $.ajax({
                        url: 'api/plano',
                        type: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify(formData),
                        dataType: 'json',
                        success: function(response) {
                            if (response.sucesso) {
                                alertBox.removeClass('d-none alert-danger').addClass('alert-success').text(response.mensagem);
                                btn.closest('tr').fadeOut(600, function() {
                                    $(this).remove();
                                });
                            } else {
                                alertBox.removeClass('d-none alert-success').addClass('alert-danger').text(response.mensagem);
                                btn.prop('disabled', false);
                            }
                        },
                        error: function(xhr) {
                            let msg = 'Erro ao processar exclusão de plano.';
                            if (xhr.responseJSON && xhr.responseJSON.mensagem) {
                                msg = xhr.responseJSON.mensagem;
                            }
                            alertBox.removeClass('d-none alert-success').addClass('alert-danger').text(msg);
                            btn.prop('disabled', false);
                        },
                        complete: function() {
                            setTimeout(function() {
                                alertBox.addClass('d-none');
                            }, 5000);
                        }
                    });
                }
            });
            $('#form-editar-plano').on('submit', function(e) {
                e.preventDefault();
                let btn = $('#btn-atualizar-plano');
                let spinner = btn.find('.spinner-border');
                let alertBox = $('#editar-plano-alert');

                alertBox.addClass('d-none').removeClass('alert-success alert-danger');
                btn.prop('disabled', true);
                spinner.removeClass('d-none');

                let formData = {
                    acao: 'editar',
                    idPlano: parseInt($('#edit-id').val()),
                    nome: $('#edit-nome').val(),
                    preco: parseFloat($('#edit-preco').val()),
                    descricao: $('#edit-descricao').val(),
                    status: $('#edit-status').is(':checked')
                };

                $.ajax({
                    url: 'api/plano',
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
                            alertBox.removeClass('d-none').addClass('alert-danger').text(response.mensagem);
                            btn.prop('disabled', false);
                            spinner.addClass('d-none');
                        }
                    },
                    error: function(xhr) {
                        let msg = 'Erro ao processar atualização do plano.';
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
</body>
</html>
