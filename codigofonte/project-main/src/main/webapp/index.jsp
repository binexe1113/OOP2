<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Academia Fit - Gestão Inteligente</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .hero-section {
            background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.8)), 
                        url('https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=1470') no-repeat center center/cover;
            height: 90vh;
            display: flex;
            align-items: center;
        }
        .feature-icon {
            font-size: 2.5rem;
            color: #ffc107;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
        <div class="container">
            <a class="navbar-brand fw-bold text-warning" href="#">💪 ACADEMIA FIT</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                <ul class="navbar-nav align-items-center">
                    <li class="nav-item"><a class="nav-link href="#recursos">Recursos</a></li>
                    <li class="nav-item"><a class="nav-link" href="#planos">Planos</a></li>
                    <li class="nav-item ms-lg-3">
                        <a href="${pageContext.request.contextPath}/acesso" class="btn btn-warning fw-bold px-4">Área do Aluno</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <header class="hero-section text-white text-center text-lg-start">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-7">
                    <h1 class="display-3 fw-bold mb-3">Leve a sua Academia ao <span class="text-warning">Próximo Nível</span></h1>
                    <p class="lead mb-4">A plataforma completa para gestão de matrículas, treinos personalizados e acompanhamento de evolução dos alunos em tempo real.</p>
                    <a href="acesso.jsp" class="btn btn-warning btn-lg fw-bold px-5 py-3 shadow me-2">
                        Começar Agora <i class="fas fa-arrow-right ms-2"></i>
                    </a>
                </div>
            </div>
        </div>
    </header>

    <section id="recursos" class="py-5 bg-light">
        <div class="container text-center py-4">
            <h2 class="fw-bold mb-5">Tudo o que precisa num só lugar</h2>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="card h-100 p-4 border-0 shadow-sm">
                        <div class="card-body">
                            <i class="fas fa-user-gradient feature-icon"></i>
                            <h4 class="card-title fw-bold">Gestão de Alunos</h4>
                            <p class="card-text text-muted">Controlo total sobre dados cadastrais, históricos de acessos e evolução de forma simples e rápida.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card h-100 p-4 border-0 shadow-sm">
                        <div class="card-body">
                            <i class="fas fa-dumbbell feature-icon"></i>
                            <h4 class="card-title fw-bold">Fichas de Treino</h4>
                            <p class="card-text text-muted">Montagem e prescrição de treinos customizados pelos professores diretamente no perfil de cada aluno.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card h-100 p-4 border-0 shadow-sm">
                        <div class="card-body">
                            <i class="fas fa-file-invoice-dollar feature-icon"></i>
                            <h4 class="card-title fw-bold">Matrículas e Planos</h4>
                            <p class="card-text text-muted">Acompanhamento automático de vigência de contratos, planos ativos e renovações pendentes.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <footer class="bg-dark text-muted text-center py-4 border-top border-secondary">
        <div class="container">
            <p class="mb-0">&copy; 2026 Academia Fit. Todos os direitos reservados.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>