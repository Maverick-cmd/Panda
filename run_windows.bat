@echo off
chcp 65001 > NUL
setlocal EnableDelayedExpansion

set PIPENV_VENV_IN_PROJECT=1

python --version > NUL 2>&1
if %ERRORLEVEL% neq 0 (
    echo Cannot find Python executable, make sure it is installed and added to your PATH.
    pause
    exit /B 0
)

python -c "import pipenv" > NUL 2>&1
if %ERRORLEVEL% neq 0 (
    python -m pip install --user pipenv
)

pipenv --version > NUL 2>&1
if %ERRORLEVEL% neq 0 (
for /F "tokens=* USEBACKQ" %%p IN (`python -m site --user-base`) do (
    echo Adding pipenv to PATH...
    set path_pipenv=%%p
    set PATH=%PATH%;!path_pipenv:site-packages=Scripts!
)

if not exist ".venv" ( pipenv --bare install )

del /Q panda.log
pipenv run python panda.py
pause