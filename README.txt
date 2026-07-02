========================================================================
SISTEMA DE GERENCIAMENTO DE ACADEMIA - ACADEMIA FIT (APO2 FINAL)
========================================================================

1. REQUISITOS E DEPENDÊNCIAS
------------------------------------------------------------------------
- Banco de Dados: MySQL Server 8.0 ou superior (rodando localmente).
- Compilação: Maven instalado e configurado no PATH do sistema.
- Servidor Java: Apache Tomcat (versão 10.1 ou superior, preferencialmente Tomcat 11 devido a Jakarta EE 11) instalado localmente.

2. ESTRUTURA DO BANCO DE DADOS
------------------------------------------------------------------------
Antes de iniciar a aplicação, certifique-se de que o servidor MySQL está rodando e configure o banco de dados:
1. Acesse o terminal do seu MySQL e crie o schema:
   CREATE DATABASE sistema_academia;
2. Execute o arquivo DDL para estruturar a base de dados:
   mysql -u <usuario> -p sistema_academia < codigofonte/database/ddl.sql
3. Execute o arquivo DML para carregar as contas e planos de teste essenciais:
   mysql -u <usuario> -p sistema_academia < codigofonte/database/dml.sql

3. INSTRUÇÕES DE EXECUÇÃO
------------------------------------------------------------------------

--- A. USUÁRIOS DE LINUX (UBUNTU / DEBIAN / ETC.) E MAC ---
1. Certifique-se de ter o Maven e o Tomcat 10.1+ / 11 instalados.
2. Defina a variável de ambiente CATALINA_HOME caso o Tomcat não esteja instalado nos diretórios padrão (/usr/share/tomcat11 ou /usr/share/tomcat10):
   export CATALINA_HOME=/caminho/do/seu/tomcat
3. Vá até a pasta ambiente:
   cd codigofonte/ambiente
4. Execute o script de deploy:
   ./redeploy.sh
5. O script compilará o projeto, criará uma base de execução isolada dentro da pasta ambiente e iniciará o Tomcat na porta 8080.

--- B. USUÁRIOS DE NIXOS (OU COM NIX INSTALADO) ---
1. Abra o terminal na raiz do projeto.
2. Inicialize o shell de desenvolvimento do Nix:
   nix develop
3. No shell do Nix, execute o script de deploy localizado na pasta de ambiente:
   ./codigofonte/ambiente/redeploy.sh

--- C. USUÁRIOS DE WINDOWS ---
1. Abra o Prompt de Comando (cmd) ou o PowerShell.
2. Defina a variável CATALINA_HOME apontando para a pasta onde você extraiu o Apache Tomcat:

3. Pressione a tecla Win e digite "Variáveis de Ambiente".
4. Selecione "Editar as variáveis de ambiente do sistema".
5. Na janela que abrir, clique no botão "Variáveis de Ambiente".
6. Em Variáveis do Sistema (a lista de baixo), clique em Novo.
7. Nome da variável: CATALINA_HOME
8. Exemplo de "valor da variável": C:\apache-tomcat-11.0.23

Clique em OK em todas as janelas.
Importante: Feche todas as janelas do prompt de comando (CMD) que estiverem abertas e abra uma nova para que ela reconheça a mudança.  

9. Execute o arquivo batch que esta na pasta OOP2\codigofonte\ambiente :
   redeploy.bat
10. O script compilará o Maven, gerará as pastas locais do Tomcat na pasta ambiente e subirá o servidor automaticamente.

--- D. EXECUÇÃO DIRETAMENTE VIA IDE (INTELLIJ IDEA OU ECLIPSE) ---
Caso prefira não utilizar a linha de comando, você pode importar e rodar o projeto por uma IDE:

>> Via IntelliJ IDEA:
1. Abra o IntelliJ IDEA.
2. Clique em "Open" e selecione o arquivo pom.xml em "codigofonte/project-main/pom.xml". Escolha abrir como projeto (Open as Project).
3. No canto superior direito, clique em "Add Configuration..." (ou "Edit Configurations...").
4. Clique no "+" no canto superior esquerdo e adicione "Tomcat Server" -> "Local" (ou use o plugin "Smart Tomcat" na versão Community).
5. Em "Application Server", configure o diretório de instalação do seu Tomcat local.
6. Na aba "Deployment" (ao lado da aba Server), clique no "+" e adicione a opção "Artifact..." selecionando "project-main:war exploded".
7. Altere o campo "Application context" no final para "/project-main".
8. Salve as configurações e clique no botão de "Play" verde no canto superior direito para compilar e iniciar o sistema.

>> Via Eclipse IDE:
1. Abra o Eclipse IDE.
2. Vá em File ➔ Import...
3. Selecione Maven ➔ Existing Maven Projects e clique em Next.
4. Em Root Directory, selecione a pasta "codigofonte/project-main/" (onde está o pom.xml) e clique em Finish. O Eclipse baixará as dependências.
5. Na aba "Servers" (geralmente embaixo), clique no link para criar um novo servidor (ou clique com botão direito ➔ New ➔ Server).
6. Escolha Apache ➔ Tomcat v10.1 Server ou Tomcat v11.0 Server (ou sua versão) e aponte para a pasta de instalação local do seu Tomcat.
7. Clique com o botão direito sobre o projeto "project-main" no Project Explorer.
8. Selecione Run As ➔ Run on Server, selecione o seu Tomcat configurado e clique em Finish. O Eclipse compilará e rodará a aplicação automaticamente.

4. ACESSO À APLICAÇÃO
------------------------------------------------------------------------
Com o servidor rodando em qualquer sistema operacional, acesse a aplicação no seu navegador:
- URL: http://localhost:8080/project-main

5. CREDENCIAIS INICIAIS DE TESTE
------------------------------------------------------------------------
As seguintes credenciais podem ser utilizadas após as cargas iniciais do banco:
- Perfil Gerente:
  * E-mail: gerente@academia.com
- Perfil Instrutor (Funcionário):
  * E-mail: professor@academia.com
- Perfil Aluno:
  * E-mail: aluno@exemplo.com
