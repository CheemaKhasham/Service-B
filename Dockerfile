# --- Stage 1: Build the application using Maven ---
FROM maven:3.9.6-eclipse-temurin-17 AS build

# Set the working directory
WORKDIR /workspace/app

# Copy the Maven project file
COPY pom.xml .

# This build argument determines which service's source code to copy
ARG SERVICE_NAME
# This new build argument will specify the main class for Maven
ARG MAIN_CLASS

COPY ${SERVICE_NAME}/ .

# Build the application, passing the start-class property to Maven.
# This explicitly tells Maven which main class to use for the executable JAR.
RUN mvn package -DskipTests -Dstart-class=${MAIN_CLASS}


# --- Stage 2: Create the final, slim container image ---
FROM eclipse-temurin:17-jre-jammy

# Define build argument again for the final stage
ARG SERVICE_NAME

# Copy the executable JAR from the 'build' stage
COPY --from=build /workspace/app/target/*.jar app.jar

# Define an environment variable for the server port
ENV SERVER_PORT=8080

# Expose the port the app runs on
EXPOSE ${SERVER_PORT}

# This is the command that will run when the container starts
ENTRYPOINT ["java", "-jar", "app.jar"]
