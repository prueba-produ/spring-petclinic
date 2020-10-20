FROM alpine/git AS clone
WORKDIR /clone
RUN git clone https://github.com/prueba-produ/spring-petclinic --single-branch -b ops

FROM maven:alpine AS build
WORKDIR /build
COPY --from=clone /clone/spring-petclinic .
RUN mvn install && mv target/spring-petclinic-*.jar target/spring-petclinic.jar

FROM openjdk:jre-alpine
WORKDIR /app
COPY --from=build /build/target/spring-petclinic.jar .

ENTRYPOINT ["java", "-jar"]
CMD ["spring-petclinic.jar"]
