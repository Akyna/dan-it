## Monitoring and logging

### Task

Prepare docker compose file to run EFK. It should gather logs from this node
app: https://gitlab.com/dan-it/groups/devops_soft/-/tree/main/Monitoring-2?ref_type=heads and show it in Kibana.

### HOW TO

```shell
cd src
```

Build application

```shell
docker build -t node_app:1.0.1 .
```

Run EFK stack via docker compose

```shell
docker compose up
```

Run application

```shell
docker run --name node_app -p 10000:10000 node_app:1.0.1
```

```shell
docker run --name node_app -p 80:3000 -e PORT=3000 node_app:1.0.1
```

Run application with a defined service host from a docker compose network

Inspect existing networks

```shell
docker network ls
```

Your network will be something like this `PROGECT_NAME_default`

In our case

```shell
dan-it_hw_26_default
```

Next, for example, we have `fluentd` service in EFK stack

Prepare our application

```shell
const fluentTransport = fluentLogger.createFluentSender('js_app', {
    host: 'fluentd',
    port: 24224,
    timeout: 3.0
});
```

Build it and run

```shell
docker run --name node_app --network dan-it_hw_26_default -p 10000:10000 -e PORT=10000 node_app:1.0.1
```
