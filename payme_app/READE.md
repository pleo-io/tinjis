# PayME Invoice Service

This service responds round-robin fashion to requests with a JSON response with a Boolean value. Sometimes you eat the bear, and sometimes the bear eats you.

## Build
```
$ docker build -t payme:0.0.1 .
```

## Run
```
$ docker run -d -p 9000:9000 payme:0.0.1 .
```

## Test
```
$ curl -s -X POST http://${SERVICE_ADDR}:9000/pay
{"result": true}
```
