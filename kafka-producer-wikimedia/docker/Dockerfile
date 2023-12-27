# Fase de ejecución
FROM openjdk:17-jdk-alpine

WORKDIR /app

# Copiar el JAR ya construido al directorio de trabajo en la imagen Docker
COPY target/kafka-producer-wikimedia-0.0.1-SNAPSHOT.jar .

# Copiar el archivo de propiedades de configuración si es necesario
COPY src/main/resources/application.properties ./app.stream.config/application.properties

CMD ["java", "-jar", "kafka-producer-wikimedia-0.0.1-SNAPSHOT.jar", "--spring.app.stream.config.location=app.stream.config/application.properties"]
