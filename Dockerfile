
FROM maven:3.9.9-eclipse-temurin-21 AS build

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

FROM eclipse-temurin:21-jre

WORKDIR /app

COPY --from=build /app/target/ /app/target/

RUN JAR=$(find /app/target -maxdepth 1 \
    -type f -name "*.jar" ! -name "*.original" \
    | head -n 1) && cp "$JAR" /app/app.jar

EXPOSE 10000

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
