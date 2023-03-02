# Start with a base image containing Java runtime
#FROM openjdk:8-jdk-alpine

# Add Maintainer Info
#LABEL maintainer="aashish.choudhary1@gmail.com"

# Add a volume pointing to /tmp
#VOLUME /tmp

# Make port 8080 available to the world outside this container
#EXPOSE 8080

# The application's jar file
#ARG JAR_FILE=target/springboot-kubernetes-0.0.1-SNAPSHOT.jar

# Add the application's jar to the container
#ADD ${JAR_FILE} springboot-kubernetes.jar

#ADD target/springboot-kubernetes-0.0.1-SNAPSHOT.jar springboot-kubernetes.jar

# Run the jar file
#ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/springboot-kubernetes.jar"]

# Build the application first using Maven
FROM maven:3.8-openjdk-11 as build
WORKDIR /app
COPY . .
RUN mvn package

# Inject the JAR file into a new container to keep the file small
FROM openjdk:8-jre-alpine
WORKDIR /app
COPY --from=build /app/auth-service/target/auth-service-1.0.0-SNAPSHOT.jar /app/app.jar
EXPOSE 8080
ENTRYPOINT ["sh", "-c"]

ENV Environment env-dev

CMD ["java -jar -Dspring.profiles.active=${Environment} app.jar"]
