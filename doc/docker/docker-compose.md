# docker compose

expose/ports 区别
1. Expose ports. Either specify both ports (HOST:CONTAINER), or just the container port (a random host port will be chosen).
2. Expose ports without publishing them to the host machine - they’ll only be accessible to linked services. Only the internal port can be specified.
