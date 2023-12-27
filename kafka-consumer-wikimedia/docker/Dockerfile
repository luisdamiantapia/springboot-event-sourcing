# Fase de ejecución
FROM openjdk:17-jdk-alpine

WORKDIR /app

COPY target/kafka-consumer-wikimedia-0.0.1-SNAPSHOT.jar .

COPY src/main/resources/application.properties ./app.stream.config/application.properties

CMD ["java", "-jar", "kafka-consumer-wikimedia-0.0.1-SNAPSHOT.jar", "--spring.app.stream.config.location=app.stream.config/application.properties"]
