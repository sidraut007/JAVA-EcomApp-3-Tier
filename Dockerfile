# ---- Build Stage ----
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

COPY pom.xml .
COPY src ./src
COPY WebContent ./WebContent

RUN mvn clean package -DskipTests

# ---- Run Stage ----
FROM tomcat:9-jdk17

# Create the app directory where we'll mount the config
RUN mkdir -p /app

# Copy the WAR to Tomcat
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/shop.war

EXPOSE 8080

CMD ["catalina.sh", "run"]