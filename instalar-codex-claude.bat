@echo off
setlocal enableextensions
chcp 65001 >nul
title Instalador Codex + Claude Code

echo ============================================================
echo  Instalador: Codex (ChatGPT) + Claude Code dentro do Codex
echo ============================================================
echo.

rem ---- 1. Git ----
where git >nul 2>nul
if errorlevel 1 (
  echo [1/6] Instalando Git...
  winget install --id Git.Git -e --source winget --accept-package-agreements --accept-source-agreements
) else (
  echo [1/6] Git ja instalado.
)

rem ---- 2. Node.js ----
where node >nul 2>nul
if errorlevel 1 (
  echo [2/6] Instalando Node.js LTS...
  winget install --id OpenJS.NodeJS.LTS -e --source winget --accept-package-agreements --accept-source-agreements
  echo.
  echo Node.js foi instalado. FECHE esta janela e rode este arquivo de novo
  echo para o Windows reconhecer o Node.
  pause
  exit /b 0
) else (
  echo [2/6] Node.js ja instalado.
)

rem ---- 3. Codex CLI ----
echo [3/6] Instalando Codex CLI...
call npm install -g @openai/codex
if errorlevel 1 goto :erro

rem ---- 4. Claude Code ----
echo [4/6] Instalando Claude Code...
call npm install -g @anthropic-ai/claude-code
if errorlevel 1 goto :erro

rem ---- 5. Registrar o Claude Code como ferramenta (MCP) dentro do Codex ----
echo [5/6] Conectando o Claude Code ao Codex...
set "CODEX_DIR=%USERPROFILE%\.codex"
set "CODEX_CFG=%CODEX_DIR%\config.toml"
if not exist "%CODEX_DIR%" mkdir "%CODEX_DIR%"
if exist "%CODEX_CFG%" (
  findstr /c:"[mcp_servers.claude]" "%CODEX_CFG%" >nul 2>nul
  if not errorlevel 1 (
    echo     Ja estava configurado.
    goto :login
  )
)
(
  echo.
  echo [mcp_servers.claude]
  echo command = "claude"
  echo args = ["mcp", "serve"]
) >> "%CODEX_CFG%"
echo     Configuracao adicionada em %CODEX_CFG%

:login
rem ---- 6. Logins ----
echo.
echo [6/6] Login. Vai abrir o navegador duas vezes.
echo.
echo --- Login do Codex (use sua conta do ChatGPT, sem chave de API) ---
call codex login
echo.
echo --- Login do Claude Code (use sua conta Claude) ---
echo Na tela do Claude, faca o login e depois digite /exit para sair.
call claude

echo.
echo ============================================================
echo  Pronto!
echo  - Para trabalhar no seu app: abra a pasta dele e rode  codex
echo  - Para gerar imagem:  gerar-imagem.bat "descricao da imagem"
echo ============================================================
pause
exit /b 0

:erro
echo.
echo Ocorreu um erro na instalacao. Copie a mensagem acima e me envie.
pause
exit /b 1
