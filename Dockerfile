FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn

# Add execute permission
RUN chmod +x mvnw

RUN ./mvnw dependency:go-offline

COPY src src

RUN ./mvnw package -DskipTests

EXPOSE 8091

ENTRYPOINT ["java","-jar","target/*.jar"]