
CREATE DATABASE IF NOT EXISTS sistema_academia;
USE sistema_academia;

-- -----------------------------------------------------
-- Tabela: Plano
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Plano (
    idPlano INT AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    descricao TEXT,
    status BOOLEAN DEFAULT TRUE,
    CONSTRAINT PK_Plano PRIMARY KEY (idPlano)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Tabela: Matricula
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Matricula (
    idMatricula INT AUTO_INCREMENT,
    dataInicio DATE NOT NULL,
    dataFim DATE NOT NULL,
    status BOOLEAN DEFAULT TRUE,
    idPlano INT NOT NULL,
    CONSTRAINT PK_Matricula PRIMARY KEY (idMatricula),
    CONSTRAINT FK_Matricula_Plano FOREIGN KEY (idPlano)
        REFERENCES Plano (idPlano)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Tabela: Usuario
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Usuario (
    idUsuario INT AUTO_INCREMENT,
    emailLogin VARCHAR(255) NOT NULL UNIQUE,
    hashSenha VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    status_conta BOOLEAN DEFAULT FALSE,
    token_recuperacao VARCHAR(255) DEFAULT NULL,
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_Usuario PRIMARY KEY (idUsuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Tabela: Aluno
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Aluno (
    idAluno INT AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    idade INT,
    email VARCHAR(255),
    telefone VARCHAR(20),
    idMatricula INT NOT NULL UNIQUE,
    idUsuario INT NULL UNIQUE,
    CONSTRAINT PK_Aluno PRIMARY KEY (idAluno),
    CONSTRAINT FK_Aluno_Matricula FOREIGN KEY (idMatricula)
        REFERENCES Matricula (idMatricula)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT FK_Aluno_Usuario FOREIGN KEY (idUsuario)
        REFERENCES Usuario (idUsuario)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Tabela: Academia
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Academia (
    idAcademia INT AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(255),
    CONSTRAINT PK_Academia PRIMARY KEY (idAcademia)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Tabela de Associação: Academia_Aluno (Muitos para Muitos)
-- Relacionamento: Academia "1..*" *-- "0..*" Aluno
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Academia_Aluno (
    idAcademia INT NOT NULL,
    idAluno INT NOT NULL,
    CONSTRAINT PK_Academia_Aluno PRIMARY KEY (idAcademia, idAluno),
    CONSTRAINT FK_AcademiaAluno_Academia FOREIGN KEY (idAcademia)
        REFERENCES Academia (idAcademia)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_AcademiaAluno_Aluno FOREIGN KEY (idAluno)
        REFERENCES Aluno (idAluno)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Tabela: Financeiro
-- Relacionamento: Financeiro "1..1" -- "1..1" Academia
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Financeiro (
    idFinanceiro INT AUTO_INCREMENT,
    idPagamento INT NOT NULL,
    dataPagamento DATE NOT NULL,
    valorPagamento DECIMAL(10, 2) NOT NULL,
    metodoPagamento VARCHAR(50) NOT NULL,
    status BOOLEAN DEFAULT TRUE,
    idAcademia INT NOT NULL,
    CONSTRAINT PK_Financeiro PRIMARY KEY (idFinanceiro),
    CONSTRAINT FK_Financeiro_Academia FOREIGN KEY (idAcademia)
        REFERENCES Academia (idAcademia)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Tabela: AvaliacaoFisica
-- Relacionamento: Aluno "1..*" --> "1..1" AvaliacaoFisica
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS AvaliacaoFisica (
    idAvaliacao INT AUTO_INCREMENT,
    data DATE NOT NULL,
    peso FLOAT NOT NULL,
    altura FLOAT NOT NULL,
    percentualGordura FLOAT,
    massaMuscular FLOAT,
    medidas TEXT,
    proximaAvaliacao DATE,
    idAluno INT NOT NULL,
    CONSTRAINT PK_AvaliacaoFisica PRIMARY KEY (idAvaliacao),
    CONSTRAINT FK_AvaliacaoFisica_Aluno FOREIGN KEY (idAluno)
        REFERENCES Aluno (idAluno)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Tabela: Aula
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Aula (
    idAula INT AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    horario TIME NOT NULL,
    capacidadeMaxima INT NOT NULL,
    CONSTRAINT PK_Aula PRIMARY KEY (idAula)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Tabela de Associação: Aluno_Aula (Muitos para Muitos)
-- Relacionamento: Aluno "1..*" --> "0..*" Aula
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Aluno_Aula (
    idAluno INT NOT NULL,
    idAula INT NOT NULL,
    CONSTRAINT PK_Aluno_Aula PRIMARY KEY (idAluno, idAula),
    CONSTRAINT FK_AlunoAula_Aluno FOREIGN KEY (idAluno)
        REFERENCES Aluno (idAluno)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_AlunoAula_Aula FOREIGN KEY (idAula)
        REFERENCES Aula (idAula)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Tabela: Professor
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Professor (
    idProfessor INT AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    email VARCHAR(255),
    telefone VARCHAR(20),
    valorHoraAula DECIMAL(10, 2) NOT NULL,
    CONSTRAINT PK_Professor PRIMARY KEY (idProfessor)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Tabela: Treino
-- Relacionamentos: Aluno "1..1" o--> "1..1" Treino e Treino "0..*" -- Professor
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Treino (
    idTreino INT AUTO_INCREMENT,
    descricao TEXT NOT NULL,
    dataInicio DATE NOT NULL,
    dataFim DATE NOT NULL,
    idAluno INT NOT NULL UNIQUE,
    idProfessor INT NOT NULL,
    CONSTRAINT PK_Treino PRIMARY KEY (idTreino),
    CONSTRAINT FK_Treino_Aluno FOREIGN KEY (idAluno)
        REFERENCES Aluno (idAluno)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Treino_Professor FOREIGN KEY (idProfessor)
        REFERENCES Professor (idProfessor)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Tabela: Funcionario
-- Relacionamento: Academia "1..*" *-- "1..1" Funcionario
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Funcionario (
    idfunc INT AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    salario DECIMAL(10, 2) NOT NULL,
    data_admissao DATE NOT NULL,
    idAcademia INT NOT NULL,
    idUsuario INT NULL UNIQUE,
    CONSTRAINT PK_Funcionario PRIMARY KEY (idfunc),
    CONSTRAINT FK_Funcionario_Academia FOREIGN KEY (idAcademia)
        REFERENCES Academia (idAcademia)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT FK_Funcionario_Usuario FOREIGN KEY (idUsuario)
        REFERENCES Usuario (idUsuario)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Tabela: Gerente (Herança/Especialização de Funcionario)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Gerente (
    idfunc INT NOT NULL,
    bonificacao DECIMAL(10, 2) NOT NULL,
    nivelAcesso VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Gerente PRIMARY KEY (idfunc),
    CONSTRAINT FK_Gerente_Funcionario FOREIGN KEY (idfunc)
        REFERENCES Funcionario (idfunc)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Tabela: Recepcionista (Herança/Especialização de Funcionario)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Recepcionista (
    idfunc INT NOT NULL,
    turno VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Recepcionista PRIMARY KEY (idfunc),
    CONSTRAINT FK_Recepcionista_Funcionario FOREIGN KEY (idfunc)
        REFERENCES Funcionario (idfunc)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
