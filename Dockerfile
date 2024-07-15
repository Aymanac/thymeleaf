FROM eclipse-temurin:21 AS build

# Install Maven
RUN apt-get update && apt-get install -y maven

WORKDIR /app

# Copy the project files
COPY pom.xml .
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Second stage: Setup runtime image
FROM eclipse-temurin:21

WORKDIR /app

# Copy the built artifact from the build stage
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]