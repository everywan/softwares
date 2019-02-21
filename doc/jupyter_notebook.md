# 使用docker创建
```Bash
docker pull jupyter/datascience-notebook
mkdir ~/.jupyter
docker run --rm -p 10000:8888 --name jupyter -d -e JUPYTER_ENABLE_LAB=yes -v "$PWD":/home/jovyan/work -v ~/.jupyter:/home/jovyan/.jupyter jupyter/datascience-notebook
docker exec -it jupyter /bin/bash
# 生成配置文件
jupyter notebook --generate-config
```
