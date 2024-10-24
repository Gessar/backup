#!/bin/bash

# Каталог для архивирования
source_directory="/home/username/directory_for_arch"

# Каталог для хранения архивов
backup_directory="/home/username/backup"

# Проверка и создание папок для хранения архивов, если они не существуют
mkdir -p "$backup_directory/daily"
mkdir -p "$backup_directory/weekly"
mkdir -p "$backup_directory/monthly"
mkdir -p "$backup_directory/yearly"

# Архив с именем, включающим дату и время
archive_name=$(date +%Y-%m-%d_%H-%M-%S).tar.gz

# Архивация каждый день
tar -czf "$backup_directory/daily/$archive_name" "$source_directory"

# Удаление архивов, старше 7 дней
find "$backup_directory/daily" -type f -mtime +7 -delete

# Архивация раз в неделю (воскресенье)
if [ $(date +%u) -eq 7 ]; then
    tar -czf "$backup_directory/weekly/$archive_name" "$source_directory"
    # Удаление архивов, старше 1 месяца
    find "$backup_directory/weekly" -type f -mtime +30 -delete
fi

# Архивация раз в месяц (первое число месяца)
if [ $(date +%d) -eq 1 ]; then
    tar -czf "$backup_directory/monthly/$archive_name" "$source_directory"
    # Удаление архивов, старше 6 месяцев
    find "$backup_directory/monthly" -type f -mtime +180 -delete
fi

# Архивация раз в год (1 января)
if [ $(date +%j) -eq 1 ]; then
    tar -czf "$backup_directory/yearly/$archive_name" "$source_directory"
    # Удаление архивов, старше 5 лет
    find "$backup_directory/yearly" -type f -mtime +1825 -delete
fi
