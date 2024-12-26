FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Add dependencies
RUN apk add --no-cache maven

# Copy project files
COPY pom.xml .
COPY src src

# Add compile arg for Lombok
RUN mvn clean package -DskipTests --add-opens=jdk.compiler/com.sun.tools.javac.processing=ALL-UNNAMED

EXPOSE 8091

# Update jar path to match your actual jar name
ENTRYPOINT ["java","-jar","target/socialMediaApp-0.0.1-SNAPSHOT.jar"]