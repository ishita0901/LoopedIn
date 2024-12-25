FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Install required packages
RUN apk add --no-cache maven

COPY pom.xml .
COPY src src

# Build with maven directly instead of mvnw
RUN mvn clean package -DskipTests

EXPOSE 8091

ENTRYPOINT ["java","-jar","target/*.jar"]