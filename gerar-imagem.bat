@echo off
setlocal enableextensions
chcp 65001 >nul

if "%~1"=="" (
  echo Uso: gerar-imagem.bat "descricao da imagem que voce quer"
  echo Exemplo: gerar-imagem.bat "icone de app azul minimalista, fundo transparente"
  exit /b 1
)

if not exist imagens mkdir imagens

echo Gerando imagem com o Codex (ChatGPT)... isso pode levar um minuto.
codex exec --skip-git-repo-check --sandbox workspace-write "Use a ferramenta de geracao de imagem embutida (image_gen) para criar esta imagem: %~1. Depois copie o arquivo PNG gerado para a pasta .\imagens deste diretorio e me diga o nome do arquivo."

echo.
echo Imagens salvas em: %CD%\imagens
pause
