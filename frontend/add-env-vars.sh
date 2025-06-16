#!/bin/sh

_replaceFrontendEnvVars() {
    echo "Procurando arquivos contendo vari�veis a serem substitu�das..."
    # Debug - mostrar valores das vari�veis
    echo "DEBUG: REACT_APP_BACKEND_URL=$REACT_APP_BACKEND_URL"
    echo "DEBUG: REACT_APP_HOURS_CLOSE_TICKETS_AUTO=$REACT_APP_HOURS_CLOSE_TICKETS_AUTO"

    # Verificar se o diret�rio existe
    if [ ! -d "/usr/src/app/build" ]; then
        echo "ERRO: Diret�rio /usr/src/app/build n�o encontrado"
        exit 1
    fi

    # Debug - listar arquivos no build
    echo "DEBUG: Arquivos em /usr/src/app/build:"
    find /usr/src/app/build -type f -name "*.js" -o -name "*.html" | head -5
    
    # Encontra todos os arquivos que cont�m as vari�veis ou URLs espec�ficas
    FILES=$(grep -rl "hours_ticket_close_auto\|https://api.example.com" /usr/src/app/build)

    if [ -z "$FILES" ]; then
        echo "Nenhum arquivo contendo as ocorr�ncias espec�ficas encontrado."
        exit 1
    fi

    for FILE in $FILES; do
        echo "Modificando $FILE..."

        # Escapar caracteres especiais nas vari�veis de ambiente
        ESCAPED_REACT_APP_HOURS_CLOSE_TICKETS_AUTO=$(printf '%s\n' "$REACT_APP_HOURS_CLOSE_TICKETS_AUTO" | sed 's:[\\/&]:\\&:g')
        ESCAPED_REACT_APP_BACKEND_URL=$(printf '%s\n' "$REACT_APP_BACKEND_URL" | sed 's:[\\/&]:\\&:g')

        # Substituir as vari�veis e URLs nos arquivos
        sed -i "s/hours_ticket_close_auto/${ESCAPED_REACT_APP_HOURS_CLOSE_TICKETS_AUTO}/g" "$FILE"
        sed -i "s|https://api.example.com|${ESCAPED_REACT_APP_BACKEND_URL}|g" "$FILE"

        echo "$FILE modificado com sucesso."
    done
}

_replaceFrontendEnvVars
