FROM maven:3.8.4-openjdk-17-slim AS build

WORKDIR /app
COPY . .
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