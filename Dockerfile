FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copy pom.xml separately to cache dependencies
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn
RUN ./mvnw dependency:go-offline

# Copy source code
COPY src src
COPY application.properties src/main/resources/

# Build application
RUN ./mvnw package -DskipTests

EXPOSE 8091

ENTRYPOINT ["java","-jar","target/*.jar"]