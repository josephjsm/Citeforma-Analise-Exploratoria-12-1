#!/bin/hash

read -p "Digite o nome do ficheiro: " file

if [-f "$file" ]; then
    echo "Número de linhas: $(wc -l < "$file")"
    echo "Número de palavras: $(wc -w < "$file")"

    echo "Primeiras 5 linhas:"
    head -n 5 "$file"

    echo "Linhas contendo 'erro':"
    grep -i "erro" "$file"
else
    echo "Ficheiro não encontrado."
fi
