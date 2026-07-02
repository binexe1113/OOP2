USE sistema_academia;

-- Limpar dados existentes sem violar chaves estrangeiras
SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM CheckIn;
DELETE FROM Gerente;
DELETE FROM Funcionario;
DELETE FROM Aluno;
DELETE FROM Matricula;
DELETE FROM Plano;
DELETE FROM Academia;
DELETE FROM Usuario;
DELETE FROM Treino;
DELETE FROM BlocoTreino;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. Inserir Academia Padrão (ID 1)
INSERT INTO Academia (idAcademia, nome, endereco, telefone, email) 
VALUES (1, 'Academia Fit - Unidade Central', 'Av. Principal, 123 - Centro', '(11) 99999-9999', 'contato@academiafit.com');

-- 2. Inserir Planos de Teste
INSERT INTO Plano (idPlano, nome, preco, descricao, status) VALUES 
(1, 'Plano Mensal', 89.90, 'Acesso livre à academia por 30 dias.', true),
(2, 'Plano Semestral', 79.90, 'Acesso livre com fidelidade de 6 meses.', true),
(3, 'Plano Anual', 69.90, 'Melhor custo-benefício com fidelidade de 12 meses.', true);

-- 3. Inserir Usuários
INSERT INTO Usuario (idUsuario, emailLogin, hashSenha, role, status_conta) VALUES 
(1, 'gerente@academia.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'GERENTE', true),
(2, 'professor@academia.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'FUNCIONARIO', true),
(3, 'aluno@exemplo.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'ALUNO', true);

-- 4. Inserir Matrícula de Teste
INSERT INTO Matricula (idMatricula, dataInicio, dataFim, status, idPlano) 
VALUES (1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 6 MONTH), true, 2);

-- 5. Inserir Funcionários (Professor e Gerente) - Inserimos antes de Aluno/Treino para garantir a FK
INSERT INTO Funcionario (idfunc, nome, cpf, salario, data_admissao, idAcademia, idUsuario) VALUES 
(1, 'Gerente da Academia', '111.111.111-11', 5000.00, CURDATE(), 1, 1),
(2, 'Professor de Musculação', '222.222.222-22', 2500.00, CURDATE(), 1, 2);

-- 6. Inserir Detalhes do Gerente
INSERT INTO Gerente (idfunc, bonificacao, nivelAcesso) 
VALUES (1, 1000.00, 'ADMINISTRADOR');

-- 7. Inserir Aluno
INSERT INTO Aluno (idAluno, nome, cpf, idade, email, telefone, idMatricula, idUsuario) 
VALUES (1, 'Aluno de Teste', '123.456.789-00', 25, 'aluno@exemplo.com', '(11) 98888-8888', 1, 3);

-- 8. Inserir Treino Inicial (Agora com professor e dataFim já no INSERT)
INSERT INTO Treino (idTreino, descricao, dataInicio, dataFim, idAluno, idProfessor) 
VALUES (1, 'Treino A - Peito e Tríceps:\n- Supino Reto: 4x10\n- Tríceps Testa: 3x12', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 1 MONTH), 1, 2);

-- 9. Inserir Estrutura dos Blocos de Treino Padrão (A, B, C, D)
INSERT INTO BlocoTreino (nome_bloco, foco, exercicios) VALUES
('A', 'Peito e Tríceps', 'Supino Reto: 4x10;Supino Inclinado com Halteres: 4x10;Tríceps Testa: 3x12;Tríceps Pulley: 3x12'),
('B', 'Costas e Bíceps', 'Puxada Frente: 4x10;Remada Curvada: 4x10;Rosca Direta: 3x12;Rosca Martelo: 3x12'),
('C', 'Pernas Completo', 'Agachamento Livre: 4x10;Leg Press 45: 4x10;Cadeira Extensora: 3x12;Mesa Flexora: 3x12'),
('D', 'Ombros e Trapézio', 'Desenvolvimento com Halteres: 4x10;Elevação Lateral: 4x12;Encolhimento com Barra: 4x15');