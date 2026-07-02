#!/usr/bin/env bash

# Redireciona a execução para o diretório onde o script está
cd "$(dirname "$0")"

# 1. Define os caminhos relativos ao projeto
PROJECT_DIR="../project-main"

# 2. Tenta descobrir o CATALINA_HOME se não estiver definida
if [ -z "$CATALINA_HOME" ]; then
    if command -v catalina.sh &> /dev/null; then
        # Se estiver no path (como no NixOS)
        export CATALINA_HOME=$(dirname $(dirname $(readlink -f $(which catalina.sh))))
    elif [ -d "/usr/share/tomcat11" ]; then
        # Local padrão no Ubuntu/Debian para Tomcat 11
        export CATALINA_HOME="/usr/share/tomcat11"
    elif [ -d "/usr/share/tomcat10" ]; then
        # Local padrão no Ubuntu/Debian para Tomcat 10
        export CATALINA_HOME="/usr/share/tomcat10"
    elif [ -d "/usr/share/tomcat9" ]; then
        export CATALINA_HOME="/usr/share/tomcat9"
    elif [ -d "/usr/share/tomcat" ]; then
        export CATALINA_HOME="/usr/share/tomcat"
    else
        echo "ERRO: A variável de ambiente CATALINA_HOME não está definida."
        echo "Por favor, exporte-a antes de rodar o script."
        echo "Exemplo: export CATALINA_HOME=/usr/share/tomcat11"
        exit 1
    fi
fi

# 3. Define a base do Tomcat local dentro de ambiente
export CATALINA_BASE=$PWD/tomcat-base

echo "================================================="
echo " Reiniciando e fazendo deploy no Tomcat"
echo "================================================="

# 4. Garante que a estrutura física de pastas exista no CATALINA_BASE
mkdir -p $CATALINA_BASE/{conf,logs,temp,webapps,work}

# 5. Copia os arquivos de configuração padrão se a pasta conf estiver vazia
if [ ! -d "$CATALINA_BASE/conf" ] || [ -z "$(ls -A $CATALINA_BASE/conf)" ]; then
    echo "Copiando configurações iniciais do Tomcat de $CATALINA_HOME..."
    cp -r $CATALINA_HOME/conf/* $CATALINA_BASE/conf/
fi

# 6. Recompila e empacota o projeto com Maven no diretório correto
echo "Compilando projeto Maven em $PROJECT_DIR..."
(cd "$PROJECT_DIR" && mvn clean package)

if [ $? -ne 0 ]; then
    echo "Erro na compilação do Maven! Cancelando deploy."
    exit 1
fi

# 7. Limpa pasta descompactada antiga para evitar cache
rm -rf $CATALINA_BASE/webapps/project-main

# 8. Copia o novo arquivo .war gerado no target do projeto para o Tomcat local
cp "$PROJECT_DIR"/target/*.war $CATALINA_BASE/webapps/

# 9. Inicia o Tomcat
echo "Iniciando Tomcat de $CATALINA_HOME na porta 8080..."
if command -v catalina.sh &> /dev/null; then
    catalina.sh run
else
    "$CATALINA_HOME/bin/catalina.sh" run
fi
