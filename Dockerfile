FROM adoptopenjdk/openjdk11:latest as builder

# Install dependencies
RUN apt-get update && apt-get install -y sqlite3 

RUN mkdir -p /home/pleo

# Switch to app homedir
WORKDIR /home/pleo

# Copy over source code
COPY . .

# When the container starts: build and test.
RUN ./gradlew build && ./gradlew test


FROM adoptopenjdk/openjdk11:latest as production

# Expose the app port.
EXPOSE 8000

# Switch to app homedir
WORKDIR /home/pleo

# Copy over final build
COPY --from=builder /home/pleo .

# Create service user and set ownership
RUN groupadd -r pleo \
    && useradd --no-log-init -r -M -g pleo pleo \
    && chown -R pleo. /home/pleo

USER pleo

# Run the app
CMD ./gradlew run
