#!/bin/bash
# redis_cli, 通过docker链接
docker run -it --network redis_default --rm redis redis-cli -h redis
# AUTH password
