FROM maven:3.8.3-openjdk-17 AS build

WORKDIR /app
COPY . .

ENV MAVEN_OPTS="--add-opens=java.base/java.lang=ALL-UNNAMED \
    --add-opens=jdk.compiler/com.sun.tools.javac.processing=ALL-UNNAMED \
    --add-opens=jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED \
    --add-opens=jdk.compiler/com.sun.tools.javac.code=ALL-UNNAMED \
    --add-opens=jdk.compiler/com.sun.tools.javac.main=ALL-UNNAMED \
    --add-opens=jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED \
    --add-opens=jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED \
    --add-opens=jdk.compiler/com.sun.tools.javac.jvm=ALL-UNNAMED"

# Update lombok version
RUN sed -i 's/<version>1.18.10<\/version>/<version>1.18.28<\/version>/g' pom.xml

RUN mvn clean package -DskipTests

FROM openjdk:17-slim

WORKDIR /app
COPY --from=build /app/target/socialMediaApp-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8091

ENV SPRING_PROFILES_ACTIVE=prod
ENV SPRING_DATASOURCE_URL=jdbc:postgresql://${DB_HOST}:${DB_PORT}/${DB_NAME}
ENV SPRING_DATASOURCE_USERNAME=${DB_USER}
ENV SPRING_DATASOURCE_PASSWORD=${DB_PASSWORD}


ENTRYPOINT ["sh", "-c", "echo \"Database URL: $SPRING_DATASOURCE_URL\" && echo \"Database User: $SPRING_DATASOURCE_USERNAME\" && java -jar app.jar"]