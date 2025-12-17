# ===== Build =====
FROM maven:3.9.9-eclipse-temurin-17-alpine AS build
WORKDIR /build

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

# ===== Runtime =====
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copier UNIQUEMENT le jar
COPY --from=build /build/target/*jar app.jar

# JVM optimisée
ENTRYPOINT ["java","-XX:MaxRAMPercentage=75.0","-jar","app.jar"]
EXPOSE 8082
