<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Painel do Gerente - Níveis de Acesso</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <nav class="navbar navbar-dark bg-dark mb-4">
        <div class="container">
            <span class="navbar-brand mb-0 h1 fw-bold text-warning">🛡️ Painel Administrativo</span>
            <span class="text-white">Olá, Gerente</span>
        </div>
    </nav>

    <div class="container">
        <div class="card border-0 shadow-sm p-4 mb-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div>
                    <h4 class="fw-bold text-dark">Controle de Nível de Acesso</h4>
                    <p class="text-muted small mb-0">Altere as permissões dos usuários do sistema em tempo real.</p>
                </div>
                <div class="input-group style-select w-25">
                    <span class="input-group-text bg-white border-end-0"><i class="fas fa-search text-muted"></i></span>
                    <input type="text" id="busca-usuario" class="form-control border-start-0" placeholder="Buscar por nome ou CPF...">
                </div>
            </div>

            <div id="alert-gerente" class="alert d-none" role="alert"></div>

            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>CPF</th>
                            <th>Nome</th>
                            <th>Nível Atual</th>
                            <th class="text-center" style="width: 250px;">Alterar Permissão</th>
                        </tr>
                    </thead>
                    <tbody id="tabela-usuarios">
                        <tr data-cpf="11122233344">
                            <td class="fw-medium">111.222.333-44</td>
                            <td>Isaque Aluno</td>
                            <td><span class="badge bg-primary px-3 py-2">ALUNO</span></td>
                            <td>
                                <select class="form-select form-select-sm select-nivel">
                                    <option value="ALUNO" selected>Aluno</option>
                                    <option value="FUNCIONARIO">Funcionário (Professor)</option>
                                    <option value="GERENTE">Gerente</option>
                                </select>
                            </td>
                        </tr>
                        <tr data-cpf="55566677788">
                            <td class="fw-medium">555.666.777-88</td>
                            <td>Rodrigo Silva</td>
                            <td><span class="badge bg-success px-3 py-2">FUNCIONARIO</span></td>
                            <td>
                                <select class="form-select form-select-sm select-nivel">
                                    <option value="ALUNO">Aluno</option>
                                    <option value="FUNCIONARIO" selected>Funcionário (Professor)</option>
                                    <option value="GERENTE">Gerente</option>
                                </select>
                            </td>
                        </tr>
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
            let cpfUsuario = selectElement.closest('tr').attr('data-cpf');
            let alertBox = $('#alert-gerente');

            // Desabilita o select temporariamente durante a requisição
            selectElement.prop('disabled', true);

            $.ajax({
                url: 'GerenteController', // <-- URL da sua futura Servlet para atualizar acesso
                type: 'POST',
                data: {
                    cpf: cpfUsuario,
                    nivel: novoNivel
                },
                dataType: 'json',
                success: function(response) {
                    if(response.success) {
                        alertBox.removeClass('d-none alert-danger').addClass('alert-success')
                                 .text('Nível de acesso atualizado com sucesso para ' + novoNivel + '!');
                        
                        // Atualiza visualmente o Badge de texto na tabela
                        let badge = selectElement.closest('tr').find('.badge');
                        badge.text(novoNivel);
                        
                        // Altera a cor do badge dinamicamente
                        if(novoNivel === 'ALUNO') badge.removeClass().addClass('badge bg-primary px-3 py-2');
                        if(novoNivel === 'FUNCIONARIO') badge.removeClass().addClass('badge bg-success px-3 py-2');
                        if(novoNivel === 'GERENTE') badge.removeClass().addClass('badge bg-danger px-3 py-2');

                    } else {
                        alertBox.removeClass('d-none alert-success').addClass('alert-danger')
                                 .text(response.message || 'Erro ao alterar permissão.');
                    }
                },
                error: function() {
                    alertBox.removeClass('d-none alert-success').addClass('alert-danger')
                             .text('Erro crítico de comunicação com o servidor.');
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
    });
    </script>
</body>
</html>