# eclipse
FROM eclipse-temurin:8-jdk-alpine

ARG JAR_FILE=release/*.jar

COPY ${JAR_FILE} mesopotamia.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/mesopotamia.jar"]
