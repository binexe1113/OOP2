package com.academia.filter;

import com.academia.model.Usuario;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Inicialização do filtro 
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) 
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        // Pega o caminho relativo da requisição (ex: "/login.jsp")
        String path = request.getRequestURI().substring(request.getContextPath().length());

        // 1. Definir quais caminhos são públicos e não precisam de login
        boolean ehRecursoPublico = path.equals("/") || 
                                   path.equals("/index.jsp") || 
                                   path.equals("/acesso.jsp") || 
                                   path.equals("/recuperar.jsp") || 
                                   path.equals("/redefinir.jsp") ||
                                   path.startsWith("/api/login") || 
                                   path.startsWith("/api/cadastro") || 
                                   path.startsWith("/api/ativar") || 
                                   path.startsWith("/api/recuperar-senha") ||
                                   path.startsWith("/css/") || 
                                   path.startsWith("/js/") || 
                                   path.startsWith("/imagens/") || 
                                   path.startsWith("/assets/");

        // Recupera o usuário logado da sessão, se existir
        Usuario usuarioLogado = (session != null) ? (Usuario) session.getAttribute("usuarioLogado") : null;

        // 2. Se for um recurso público, libera o acesso imediatamente
        if (ehRecursoPublico) {
            chain.doFilter(req, res);
            return;
        }

        // 3. Se não for público e o usuário não estiver logado, redireciona para o login
        if (usuarioLogado == null) {
            response.sendRedirect(request.getContextPath() + "/acesso.jsp");
            return;
        }

        // 4. Controle de perfil de Acesso (Administrador / Gerente)
        // Se tentar acessar URLs da pasta "/admin/" e a role não for GERENTE, nega acesso (403 Forbidden)
        if (path.startsWith("/admin/") && !usuarioLogado.getRole().equalsIgnoreCase("GERENTE")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acesso Negado: Apenas gerentes autorizados.");
            return;
        }

        // 5. Se passou por todas as regras, libera a requisição
        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {
        // Limpeza de recursos do filtro
    }
}
