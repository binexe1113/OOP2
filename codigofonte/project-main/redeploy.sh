#!/usr/bin/env bash

# Redireciona a execução para o diretório onde o script está
cd "$(dirname "$0")"

# 1. Define as variáveis de ambiente locais
export CATALINA_BASE=$PWD/tomcat-base
export CATALINA_HOME=$(dirname $(dirname $(readlink -f $(which catalina.sh))))

echo "================================================="
echo " Reiniciando e fazendo deploy no Tomcat"
echo "================================================="

# 2. Garante que a estrutura física de pastas exista
mkdir -p $CATALINA_BASE/{conf,logs,temp,webapps,work}

# 3. Copia os arquivos de configuração padrão se a pasta conf estiver vazia
if [ ! -d "$CATALINA_BASE/conf" ] || [ -z "$(ls -A $CATALINA_BASE/conf)" ]; then
    echo "Copiando configurações iniciais do Tomcat..."
    cp -r $CATALINA_HOME/conf/* $CATALINA_BASE/conf/
fi

# 4. Recompila e empacota o projeto com Maven
echo "Empacotando projeto..."
mvn clean package

if [ $? -ne 0 ]; then
    echo "Erro na compilação do Maven! Cancelando deploy."
    exit 1
fi

# 5. Limpa pasta descompactada antiga para evitar cache
rm -rf $CATALINA_BASE/webapps/project-main

# 6. Copia o novo arquivo .war para o Tomcat
cp target/*.war $CATALINA_BASE/webapps/

# 7. Inicia o Tomcat
echo "Iniciando Tomcat na porta 8080..."
catalina.sh run
