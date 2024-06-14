Load Balancing

Load balancing helps distribute the incoming traffic, some of then, requests, evenly across multiples destinations. The mains goals of load balancing is to ensure high availability, reliability and performance by avoinding overloading and downtime of a single server.

The most common implementation of a lb is between the clients requests and the pool of destination, according to the following image.


Despite the simple description of the lb it may have some features that makes it a very powerful and important actor in the infrastructure.

Health Check

The way to a load balancer determines if a destination is up, running and available to answer the requests, is checking it’s healthy. In HTTP servers, it is an endpoint and it should response the request in a defined, by lb, time. It may have a retry mechanism to avoid false positives, but if the resource doesn’t answer in the specified time, then the load balancer mark this resource as unavailable and redirect to anyother avaialble.

After some time the lb should verify the availability again, and if it is ok, it shuold receive the requests again.

Session Persistence

In simple terms it ensures that the requests of a source, are directed to the same destination that last request were sent. This way the session between the source and destination keep opened and provide a consistent user experience.

This solution may use some external applications in function to create a more robust solution. An this is the scenario that a session persistence implementation can increase signficativelly the complexity.

SSL/TSL Termination

The process of decrypting SSL/TLS-encrypted traffic at the load balancer level, offloading the decryption burden from backend servers and allowing for centralized SSL/TLS management.
 
Algorithms

A load balancing algorithm is a method used by a load balancer to distribute incoming traffic and requests among multiple servers or resources. The primary purpose of a load balancing algorithm is to ensure efficient utilization of available resources, improve overall system performance, and maintain high availability and reliability.

Round Robin

Distributes incomming requests to server in a cyclic order, and when the last one received a request it round to the begining and starts again.

Least Connections

Directs the connections to the resource with the lowest number of active connections. As the lb solutions store a internal log of the activity for his own control and use this log to decide where to send the request. Some of them could use a personalized solution.

Weighted Round Robin

It works similary to the pure Round Robin, but you can assign a weight to a destination and it will receive more, or less, requests according to the definition.

Weighted Least Connections
Same feature of weigthing the resources, as in Weighted Round Robin, but for Least Connections.

IP Hash
This algorithm create a hash for each connection, (source IP x destination IP) and uses a session persistence to maintains this relation.

Least Response Time
Directs the connectio to the resource with lowest response time (health check) and fewest active connections. This method helps to optimize the user experience by prioritizing faster-performing servers.

Random
Well, this one doesn’t requires much explanation :-)




Roadmap

docker run --rm --name my-custom-nginx-container -h backend -v ./nginx.conf:/etc/nginx/nginx.conf:ro -d nginx

docker run --name some_nginx -d -p 80:80 -v ${PWD}:/usr/share/nginx/html:ro nginx

docker run --name some_haproxy -d -p 80:80 -v ./haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro haproxy

docker run --network=haproxy-lb --name some_haproxy -d -p 80:80 -p 8404:8404 -v ./haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro haproxy


## Reference
https://www.designgurus.io/course-play/grokking-system-design-fundamentals/doc/641db0dec48b4f7de900fd04
http://nginx.org/en/docs/http/load_balancing.html
https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/
https://ruan.dev/blog/2021/11/23/run-docker-containers-with-terraform
https://docs.nginx.com/nginx/admin-guide/load-balancer/tcp-udp-load-balancer/

https://phoenixnap.com/kb/haproxy-load-balancer
https://www.haproxy.com/blog/load-balancing-affinity-persistence-sticky-sessions-what-you-need-to-know
