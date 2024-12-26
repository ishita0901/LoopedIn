FROM maven:3.8.4-openjdk-17-slim AS build

WORKDIR /app
COPY . .

# Configure Java modules for Lombok
ENV MAVEN_OPTS="--add-opens jdk.compiler/com.sun.tools.javac.processing=ALL-UNNAMED \
    --add-opens jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED \
    --add-opens jdk.compiler/com.sun.tools.javac.code=ALL-UNNAMED \
    --add-opens jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED \
    --add-opens jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED"

# Add Spring Boot Maven plugin if not present
RUN sed -i '/<plugins>/a\
            <plugin>\
                <groupId>org.springframework.boot</groupId>\
                <artifactId>spring-boot-maven-plugin</artifactId>\
            </plugin>' pom.xml

RUN mvn clean package -DskipTests

FROM openjdk:17-slim

WORKDIR /app
COPY --from=build /app/target/socialMediaApp-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8091

ENV SPRING_PROFILES_ACTIVE=prod
ENV SPRING_DATASOURCE_URL=jdbc:postgresql://${DB_HOST}:${DB_PORT}/${DB_NAME}
ENV SPRING_DATASOURCE_USERNAME=${DB_USER}
ENV SPRING_DATASOURCE_PASSWORD=${DB_PASSWORD}


ENTRYPOINT ["java", "-jar", "app.jar"]