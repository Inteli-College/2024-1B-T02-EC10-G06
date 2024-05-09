# Executar sink connector


primeiro devemos instalar o sink connector, para isso devemos acessar o container do kafka connect e instalar o sink connector

```bash
docker pull confluentinc/cp-server:latest
docker run -it confluentinc/cp-server:latest bash
```

deve ser usada o caminho do kafka connect curl -X POST -H "Content-Type: application/json"

```bash
curl -X POST -H "Content-Type: application/json"  -d @sink.json http://connect:8083/connectors -w "\n"
```
