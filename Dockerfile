FROM maven:3.8.6-openjdk-18 AS BUILD
WORKDIR /app
COPY .  .
RUN mvn package -DskipTests

FROM openjdk:18.0.2.1-jdk AS RUN
COPY --from=BUILD /app/target/demo-0.0.1-SNAPSHOT.jar /run/demo.jar

ARG USER=devops
ENV HOME=/home/${USER}
RUN adduser ${USER} && chown ${USER}:${USER} /run/demo.jar
USER ${USER}

# no need to install curl with microdnf, it is already present
HEALTHCHECK --interval=30s --timeout=10s --retries=2 --start-period=20s CMD curl -f http://localhost:8080/ || exit 1

EXPOSE 8080
CMD java  -jar /run/demo.jar
