#!/bin/sh

_replaceFrontendEnvVars() {
    echo "Procurando arquivos contendo variáveis a serem substituídas..."
    # Debug - mostrar valores das variáveis
    echo "DEBUG: REACT_APP_BACKEND_URL=$REACT_APP_BACKEND_URL"
    echo "DEBUG: REACT_APP_HOURS_CLOSE_TICKETS_AUTO=$REACT_APP_HOURS_CLOSE_TICKETS_AUTO"

    # Verificar se o diretório existe
    if [ ! -d "/usr/src/app/build" ]; then
        echo "ERRO: Diretório /usr/src/app/build não encontrado"
        exit 1
    fi

    # Debug - listar arquivos no build
    echo "DEBUG: Arquivos em /usr/src/app/build:"
    find /usr/src/app/build -type f -name "*.js" -o -name "*.html" | head -5
    
    # Encontra todos os arquivos que contêm as variáveis ou URLs específicas
    FILES=$(grep -rl "hours_ticket_close_auto\|https://api.example.com" /usr/src/app/build)

    if [ -z "$FILES" ]; then
        echo "Nenhum arquivo contendo as ocorrências específicas encontrado."
        exit 1
    fi

    for FILE in $FILES; do
        echo "Modificando $FILE..."

        # Escapar caracteres especiais nas variáveis de ambiente
        ESCAPED_REACT_APP_HOURS_CLOSE_TICKETS_AUTO=$(printf '%s\n' "$REACT_APP_HOURS_CLOSE_TICKETS_AUTO" | sed 's:[\\/&]:\\&:g')
        ESCAPED_REACT_APP_BACKEND_URL=$(printf '%s\n' "$REACT_APP_BACKEND_URL" | sed 's:[\\/&]:\\&:g')

        # Substituir as variáveis e URLs nos arquivos
        sed -i "s/hours_ticket_close_auto/${ESCAPED_REACT_APP_HOURS_CLOSE_TICKETS_AUTO}/g" "$FILE"
        sed -i "s|https://api.example.com|${ESCAPED_REACT_APP_BACKEND_URL}|g" "$FILE"

        echo "$FILE modificado com sucesso."
    done
}

_replaceFrontendEnvVars
