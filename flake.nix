{
  description = "Ambiente de desenvolvimento APO2 — Java Web (Tomcat 9, Maven, MySQL 8)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          name = "apo2-dev";

          packages = with pkgs; [
            # Java
            jdk17          # JDK 17 LTS (compatível com Tomcat 9+)
            maven          # Gerenciador de build/dependências

            # Servidor de aplicação
            tomcat9        # Tomcat 9 (requisito do projeto)

            # Banco de dados
            mysql84        # MySQL Server 8.4 (LTS)

            # Utilitários
            git
            curl           # útil para testar endpoints sem Postman
          ];

          shellHook = ''
            echo ""
            echo "╔══════════════════════════════════════════════╗"
            echo "║    Ambiente APO2 — Java Web / Maven / MySQL  ║"
            echo "╚══════════════════════════════════════════════╝"
            echo ""
            echo "  Java   : $(java -version 2>&1 | head -1)"
            echo "  Maven  : $(mvn -version 2>&1 | head -1)"
            echo "  MySQL  : $(mysqld --version 2>&1 | head -1)"
            echo ""
            echo "  Comandos úteis:"
            echo "    mvn clean package          → gera o WAR em target/"
            echo "    mysql -u root              → abre o cliente MySQL"
            echo "    bash codigofonte/ambiente/setup-db.sh  → cria o banco"
            echo ""

            export JAVA_HOME="${pkgs.jdk17}"
            export CATALINA_HOME="${pkgs.tomcat9}"
            export PATH="$JAVA_HOME/bin:$PATH"
          '';
        };
      });
}
