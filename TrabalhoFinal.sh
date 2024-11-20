#!/bin/hash

#Cada setor foi testado em ficheiros diferentes. Procurei ajuda em o stack overflow, etc.

# Primeiro codigo, e o mais importante.
if [ $# -eq 0 ]; then
    while true; do
        echo "BEEP"
        echo "Argumento não encontrado."
        echo "Introduza o nome da pasta que quer criar: "
        read Pasta

        if [ -z "$Pasta" ]; then
            echo "BZZZZ"
            echo "Nenhum nome foi introduzido."
            echo "Por favor, tente novamente."
        else
            if [ ! -d "$Pasta" ]; then
                mkdir -p "$Pasta"
                echo "A pasta '$Pasta' foi criada com sucesso."
            else
                echo "A pasta '$Pasta' já existe."
                echo "Conteúdo da pasta '$Pasta' ordenado por tamanho (maior para menor):"
                find "$Pasta" -type f -exec du -h {} + | sort -rh
            fi
            
            if [ -d "$Pasta" ]; then
                echo "A diretoria '$Pasta' existe agora."
                break
            else
                echo "Houve um erro ao criar a diretoria '$Pasta'."
                echo "Por favor, tente novamente."
            fi
        fi
    done
else
    Pasta="$1"

    if [ ! -d "$Pasta" ]; then
        echo "A pasta '$Pasta' não existe."
        mkdir -p "$Pasta"
        echo "A pasta '$Pasta' foi criada com sucesso."
    else
        echo "A pasta '$Pasta' já existe."

#Ordernar pasta se ela existe
        echo "Conteúdo da pasta '$Pasta' ordenado por tamanho (maior para menor):"
        find "$Pasta" -type f -exec du -h {} + | sort -rh
    fi
fi


#Codigo para criar pasta backup
backup_dir="$1/backup_$(date +%Y-%m-%d)"
mkdir -p "$backup_dir"

#Codigo para copiar os ficheiros para a pasta backup
rsync -av --exclude="$backup_dir" "$1/" "$backup_dir/"

echo "Backup completed: $backup_dir"


#Código com a previsão do tempo
#URL="https://api.openweathermap.org/data/2.5/weather?q=Lisboa,Portugal&mode=json&units=metric&appid=24c5e8a6cad0cafcc690daf59df136d9"
#infoTempo=$(curl -s "$URL" | jq '.main.temp')
#echo "Lisboa, Portugal: $infoTempo°C"

# Relatório Gerado Aqui
# Nome e número de ficheiros dentro da pasta e todos os diretórios
ficheiros_totais=$(find . -type f | wc -l)
echo "Total de ficheiros: $ficheiros_totais"


# Número de ficheiros por tamanho: pequeno, medio e grande
pequeno=0
medio=0
grande=0

for file in $(find . -type f); do
    size=$(wc -c <"$file")
    if [ "$size" -le 10000 ]; then
        pequeno=$((pequeno + 1))
    elif [ "$size" -le 1000000 ]; then
        medio=$((medio + 1))
    else
        grande=$((grande + 1))
    fi
done

echo "Pequenos (<10KB): $pequeno"
echo "Medios (10KB-1MB): $medio"
echo "Grandes (>1MB): $grande"

# Nome do maior ficheiro
maior_ficheiro=$(find . -type f -exec du -b {} + | sort -rn | head -n 1 | awk '{print $2}')
maior_tamanho=$(du -h "$maior_ficheiro" | awk '{print $1}')
echo "Maior ficheiro: $maior_ficheiro ($maior_tamanho)"

# Tamanho medio dos ficheiros
tamanho_total=$(du -sb . | awk '{print $1}')
tamanho_medio=$((tamanho_total / ficheiros_totais))
echo "Tamanho medio dos ficheiros: $tamanho_medio bytes"

# Previsão do tempo
infoTempo=$(curl -s "https://api.openweathermap.org/data/2.5/weather?q=Lisboa,Portugal&mode=json&units=metric&appid=24c5e8a6cad0cafcc690daf59df136d9" | jq '.main.temp')
echo "Lisboa, Portugal: $infoTempo°C"

# Output do relatório
output_file="Relatório.txt"

{
    echo "Relatório do Sistema"
    echo "---------------------"
    echo "Total de ficheiros: $ficheiros_totais"
    echo "Pequenos (<10KB): $pequeno"
    echo "medios (10KB-1MB): $medio"
    echo "Grandes (>1MB): $grande"
    echo "Maior ficheiro: $maior_ficheiro ($maior_tamanho)"
    echo "Tamanho medio dos ficheiros: $tamanho_medio bytes"
    echo "Lisboa, Portugal: $infoTempo°C"
} > "$output_file"

if [ -f "$output_file" ]; then
    echo "Relatório criado com sucesso: $output_file"
else
    echo "Erro ao criar o relatório."
fi