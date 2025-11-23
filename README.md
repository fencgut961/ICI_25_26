# 🔥 Prueba del Laboratorio ELK + Hydra + SSH Víctima

Este documento describe los pasos finales para **probar el entorno ya montado** compuesto por:

- Elasticsearch
- Logstash
- Kibana
- Contenedor víctima con SSH
- Contenedor atacante con Hydra

Aquí solo se incluyen los pasos necesarios para **ver que todo funciona**.

---

## ✅ 1. Levantar toda la infraestructura

```bash
docker compose up --build
```

Comprueba que la víctima (`victim-ssh`) está funcionando:

```bash
docker compose logs -f victim-ssh
```

Debes ver mensajes indicando que **rsyslog está instalado y corriendo**, ya que es el encargado de enviar los logs a Logstash.

---

## ✅ 2. Verificar que la víctima está enviando logs

Realiza varios intentos fallidos de autenticación contra el SSH:

```bash
ssh student@localhost -p 2222
```

Introduce una contraseña incorrecta varias veces.

Ahora revisa Logstash:

```bash
docker logs -f logstash
```

Si ves líneas como:

```
Failed password for student ...
```

entonces la cadena de registro está funcionando:

**SSH → rsyslog → Logstash → Elasticsearch**

---

## ✅ 3. Ver los logs en Kibana

1. Accede a Kibana:  
   👉 http://localhost:5601

2. Crea un Data View en este enlace:  
   👉 **http://localhost:5601/app/management/kibana/dataViews/create**

3. Configura el Data View:

- **Name:** `syslog`
- **Pattern:** `syslog-*`
- **Time field:** `@timestamp`

4. Abre **Discover** y selecciona el Data View `syslog`.

Deberías ver eventos como:

- Failed password
- Accepted password
- usuario objetivo
- IP de origen
- fecha y hora del intento

---

## ✅ 4. Lanzar el ataque con Hydra

Accede al contenedor:

```bash
docker exec -it hydra-cli sh
```

Opcional: crear un wordlist rápido:

```bash
cat > /wordlists/demo.txt << 'EOF'
123456
password
Password123
EOF
```

Lanza el ataque:

```bash
hydra -l student -P /wordlists/demo.txt ssh://victim-ssh:2222
```

- `-l student` → usuario objetivo
- `-P /wordlists/demo.txt` → diccionario de contraseñas
- `ssh://victim-ssh:2222` → servicio y puerto expuesto de la víctima

Durante el ataque, puedes ver los eventos en Logstash:

```bash
docker logs -f logstash
```

Cada intento se registrará y aparecerá también en Kibana.
