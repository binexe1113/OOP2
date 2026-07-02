@echo off
:: Muda para a pasta onde o script está
cd /d "%~dp0"

set PROJECT_DIR=..\project-main
set CATALINA_BASE=%CD%\tomcat-base

echo =================================================
echo  Reiniciando e fazendo deploy no Tomcat (Windows)
echo =================================================

:: 1. Verifica se CATALINA_HOME está definida
if "%CATALINA_HOME%"=="" (
    echo ERRO: A variavel CATALINA_HOME nao esta definida!
    echo Por favor, defina a variavel de ambiente CATALINA_HOME apontando para a pasta instalada do Tomcat.
    echo Exemplo: set CATALINA_HOME=C:\apache-tomcat-9.0.80
    pause
    exit /b 1
)

:: 2. Garante a estrutura fisica de pastas do Tomcat local
if not exist "%CATALINA_BASE%\conf" mkdir "%CATALINA_BASE%\conf"
if not exist "%CATALINA_BASE%\logs" mkdir "%CATALINA_BASE%\logs"
if not exist "%CATALINA_BASE%\temp" mkdir "%CATALINA_BASE%\temp"
if not exist "%CATALINA_BASE%\webapps" mkdir "%CATALINA_BASE%\webapps"
if not exist "%CATALINA_BASE%\work" mkdir "%CATALINA_BASE%\work"

:: 3. Copia configuracoes se estiver vazio
dir /b /a "%CATALINA_BASE%\conf" | findstr . >nul
if errorlevel 1 (
    echo Copiando configuracoes iniciais do Tomcat...
    xcopy "%CATALINA_HOME%\conf\*" "%CATALINA_BASE%\conf\" /s /e /y
)

:: 4. Compila o projeto com Maven
echo Compilando projeto Maven em %PROJECT_DIR%...
cd %PROJECT_DIR%
call mvn clean package
if %ERRORLEVEL% neq 0 (
    echo Erro na compilacao do Maven! Cancelando deploy.
    pause
    exit /b 1
)
cd /d "%~dp0"

:: 5. Limpa cache antigo do app
if exist "%CATALINA_BASE%\webapps\project-main" rmdir /s /q "%CATALINA_BASE%\webapps\project-main"
del /f /q "%CATALINA_BASE%\webapps\*.war" 2>nul

:: 6. Copia o novo .war
copy /y "%PROJECT_DIR%\target\*.war" "%CATALINA_BASE%\webapps\"

:: 7. Inicia o Tomcat
echo Iniciando Tomcat...
call "%CATALINA_HOME%\bin\catalina.bat" run
