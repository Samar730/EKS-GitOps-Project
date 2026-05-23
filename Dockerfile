# Stage 1 - Frontend Builder
FROM node:24-alpine AS frontend-builder

# Creates a folder named app in the container file system
WORKDIR /app 

# Install pnpm
RUN npm install -g pnpm

# Copy dependency files - # Copy package.json and package-lock.json to the working directory
COPY app/memos/web/package.json app/memos/web/pnpm-lock.yaml ./

# Install app dependencies
RUN pnpm install --frozen-lockfile

# Copy the Frontend source code
COPY app/memos/web/ .

# Used to run the Frontend
RUN pnpm build 


# Stage 2 - Go Backend Builder
FROM golang:1.26-alpine AS backend-builder

WORKDIR /app

# Copy Go dependency files
COPY app/memos/go.mod app/memos/go.sum ./

# Download Go dependencies
RUN go mod download

# Copy Backend source code
COPY app/memos/ .

# Copy frontend build output from Stage 1 for embedding into Go binary
COPY --from=frontend-builder /app/dist ./server/router/frontend/dist

# Run the Backend
RUN go build -o memos ./cmd/memos


# Stage 3 - Runtime 
FROM alpine:3.21 AS runtime

WORKDIR /app

# Copy compiled binary from Stage 2
COPY --from=backend-builder /app/memos .

# creates an unprivileged user without an interactive password
RUN adduser --disabled-password --no-create-home appuser

RUN mkdir -p /var/opt/memos && chown appuser:appuser /var/opt/memos

# Switch to non root user
USER appuser

# for documentation purposes
EXPOSE 8081

ENTRYPOINT ["./memos"]

# Trigger ci test 