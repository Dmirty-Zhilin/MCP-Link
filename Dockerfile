FROM golang:1.23-alpine AS builder

# Установка зависимостей
RUN apk add --no-cache git

# Установка рабочей директории
WORKDIR /app

# Клонирование репозитория MCP-Link
RUN git clone https://github.com/automation-ai-labs/mcp-link.git .

# Сборка приложения
RUN go mod download
RUN go build -o mcp-link main.go

# Финальный образ
FROM alpine:latest

# Установка зависимостей
RUN apk add --no-cache ca-certificates

# Копирование бинарного файла из builder
COPY --from=builder /app/mcp-link /usr/local/bin/

# Создание директории для конфигурации
RUN mkdir -p /app/config

# Установка рабочей директории
WORKDIR /app

# Экспонирование порта
EXPOSE 8081

# Запуск MCP-Link сервера
CMD ["mcp-link", "serve", "--port", "8080", "--host", "0.0.0.0"]
