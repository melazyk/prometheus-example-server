### Step 1: Build stage
FROM golang as builder

WORKDIR /app

# Copy the Go module files and download dependencies
COPY . ./
RUN go mod download

# Copy the application source code and build the binary
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o main main.go

### 
## Step 2: Runtime stage
FROM scratch

# Copy only the binary from the build stage to the final image
COPY --from=builder /app/main /

# Set the entry point for the container
ENTRYPOINT ["/main"]