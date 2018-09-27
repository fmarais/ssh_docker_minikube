## Expose ssh on your docker container or your minikube container

Usefull for remote debuggin using your favourite ide eg. pycharm or phpstorm etc.


### Docker build and run
navigate to Dockerfile
```
docker build -t ssh_test1 .
```

view newly created image
```
docker images 
```

start the image in a container and forward port 22 to 2222
```
docker run -d -p 2222:22 ssh_test1
```

view started container process
```
docker ps -a 
```

connect to docker image
```
ssh root@localhost -p 2222
```
***password: root***

possibly remove any existing line that starts with `[localhost]:2222` from `~/.ssh/known_hosts` if required, and retry connecting <br>


### Minikube setup
Make sure you have a similar base image.<br>
This example uses `nginx:stable-alpine`<br>
Copy everything from below `### start copy` to `### end copy`<br>
<br>
Paste all this into your existing kubernetes projects `Dockerfile` before your existing `CMD` command<br>
This should now install and setup ssh in your container.<br>
<br>
Remember you need to now manually start the sshd server to connect to it using
```
kubectl exec my-app-name-here /usr/sbin/sshd -D
```

Forward your container port, edit your service.yml and add your port forward config 22->2222 eg.<br>
Here we forward 5000 to 80 (Our web server, you might not have this, not required)<br>
***Our ssh port forward 22 to 2222 (You need to add this)***
```
spec:
  ports:
    - name: 80-5000
      port: 80
      protocol: TCP
      targetPort: 5000
    - name: 2222-22
      port: 2222
      protocol: TCP
      targetPort: 22
```

You should now be able to connect using your `minikube ip`:`nodeport`<br>
<br>
Get your minikube ip
```
minikube ip
```
***192.168.64.34***

Get your nodeport
```
kubectl get service
```
Look for something similar to
`TCP,2222:32529/TCP` your nodeport is ***32529***

Connect using
```
ssh root@192.168.64.34 -p 32529
```
***password: root***
