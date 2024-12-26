FROM maven:3.8.4-openjdk-17-slim AS build

WORKDIR /app
COPY . .

# Configure Java modules for Lombok
ENV MAVEN_OPTS="--add-opens jdk.compiler/com.sun.tools.javac.processing=ALL-UNNAMED \
    --add-opens jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED \
    --add-opens jdk.compiler/com.sun.tools.javac.code=ALL-UNNAMED \
    --add-opens jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED \
    --add-opens jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED"

# Update Lombok version in pom.xml
RUN sed -i 's/<version>1.18.10<\/version>/<version>1.18.30<\/version>/g' pom.xml
RUN mvn clean package -DskipTests

FROM openjdk:17-slim

WORKDIR /app
COPY --from=build /app/target/socialMediaApp-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080

ENV SPRING_PROFILES_ACTIVE=prod
ENV SPRING_DATASOURCE_URL=jdbc:postgresql://${DB_HOST}:${DB_PORT}/${DB_NAME}
ENV SPRING_DATASOURCE_USERNAME=${DB_USER}
ENV SPRING_DATASOURCE_PASSWORD=${DB_PASSWORD}
ENV JWT_SECRET=${JWT_SECRET}

ENTRYPOINT ["java", "-jar", "app.jar"]