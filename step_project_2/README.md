## HOW TO

### **!!! It can be run on Ubuntu only, in terms of using a docker as a proxy for 'worker' node inside !!!**


Open terminal 
```shell
git clone ...
```
```shell
cd src
```
```shell
docker compose up --build server
```
- Open browser `http://localhost:8080`
- Finish setup with Jenkins secret
- Disable default Node workers
- Create a new Node worker. Set the name as in `compose.yaml` file, i.e. `JENKINS_AGENT_NAME: worker`
- Update secret for worker in `compose.yaml` for `JENKINS_SECRET: 8b755d...`
- Run 
```shell
docker compose up --build worker
```
- Create pipline 
- Enjoy your work :)
