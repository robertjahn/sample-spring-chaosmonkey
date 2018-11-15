# Overview

* https://piotrminkowski.wordpress.com/2018/05/23/chaos-monkey-for-spring-boot-microservices/
* https://codecentric.github.io/chaos-monkey-spring-boot/
* https://codecentric.github.io/chaos-monkey-spring-boot/2.0.1/

# run MySQL in Docker
1. start DB
docker run -d --name mysql -e MYSQL_DATABASE=chaos -e MYSQL_USER=chaos -e MYSQL_PASSWORD=chaos123 -e MYSQL_ROOT_PASSWORD=123456 -p 33306:3306 mysql:5.7
2. access db using tool like https://www.sequelpro.com/

# Build JAR and Run App
1. clone https://github.com/piomin/sample-spring-chaosmonkey.git
2. edit src/main/resources/application.yml for default chaos
3. build app
cd customer-service/
mvn clean package
4. start
java -jar customer-service/target/customer-service-1.0-SNAPSHOT.jar --spring.profiles.active=chaos-monkey
5. validate app using POSTMAN or CURL
```
> curl --header "Content-Type: application/json" --request POST -d '{ "id": 3, "name": "test3", "availableFunds": 300, "type": "VIP"}' http://localhost:8093/customers
"id":3,"name":"test3","availableFunds":300,"type":"VIP"}
```
```
> curl http://localhost:8093/customers/3
{"id":3,"name":"test3","availableFunds":300,"type":"VIP"}
```

# Adjust Chaos settings between test runs

# View watch settings.
```
> curl http://localhost:8093/actuator/chaosmonkey/watcher
{"controller":false,"restController":true,"service":false,"repository":false,"component":false}
```

```
> curl http://localhost:8093/actuator/chaosmonkey
{"chaosMonkeyProperties":{"enabled":true},"assaultProperties":{"level":5,"latencyRangeStart":1000,"latencyRangeEnd":10000,"latencyActive":true,"exceptionsActive":false,"killApplicationActive":false,"watchedCustomServices":null,"frozen":false,"targetSource":{"target":{"level":5,"latencyRangeStart":1000,"latencyRangeEnd":10000,"latencyActive":true,"exceptionsActive":false,"killApplicationActive":false,"watchedCustomServices":null},"static":true,"targetClass":"de.codecentric.spring.boot.chaos.monkey.configuration.AssaultProperties"},"targetClass":"de.codecentric.spring.boot.chaos.monkey.configuration.AssaultProperties","proxiedInterfaces":[],"advisors":[{"order":2147483647,"advice":{},"pointcut":{"classFilter":{},"methodMatcher":{"runtime":false}},"perInstance":true}],"proxyTargetClass":true,"exposeProxy":false,"preFiltered":false},"watcherProperties":{"controller":false,"restController":true,"service":false,"repository":false,"component":false}}
```

# Adust testings.
https://codecentric.github.io/chaos-monkey-spring-boot/2.0.1/#_properties

```
POST localhost:8080/actuator/chaosmonkey/assaults
{
    "level": 5,
    "latencyRangeStart": 1999,
    "latencyRangeEnd": 5000,
    "latencyActive": true,
    "exceptionsActive": true,
    "killApplicationActive": false
}
```
# Performance Test

## Gatling

1. docker run -d --name postgres -e POSTGRES_DB=gatling -e POSTGRES_USER=gatling -e POSTGRES_PASSWORD=gatling123 -p 5432:5432 postgres
2. adjust connection string in this performance-test/src/main/resources/application.yml
3. cd performance-test/
gradle loadTest

## Jmeter
1. assumes have jmeter installed locally
2. cd jmeter/
3. use run.sh or lanch_test.sh