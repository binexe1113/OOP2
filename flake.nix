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
            jdk21       # JDK 21 LTS (compatível com Tomcat 9+)
            maven          # Gerenciador de build/dependências

            # Servidor de aplicação
            tomcat11        # Tomcat 11 (requisito do projeto)

            # Banco de dados
            mysql84        # MySQL Server 8.4 (LTS)

            # Utilitários
            git
            curl           # útil para testar endpoints sem Postman
          ];

          shellHook = ''
            echo ""
            echo "================================================"
            echo ||                    TESTE                     ||"
            echo "================================================"
          '';
        };
      });
}
