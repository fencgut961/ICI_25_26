# 🛡️ Detección de Fake Login con n8n

## 📌 Descripción del Proyecto

Esta rama contiene un sistema automatizado de **detección de intentos de login falsos o sospechosos** implementado mediante **n8n**, junto con la configuración necesaria en Docker para desplegar el entorno de ejecución.

El objetivo del proyecto es simular un mecanismo básico de detección de incidentes de seguridad, identificando múltiples intentos fallidos de autenticación y generando una respuesta automatizada cuando se supera un umbral definido.

Se trata de una práctica orientada a ciberseguridad y automatización de procesos tipo SOC.

---

## 📂 Contenido de la Rama
.
├── workflow.json # Workflow exportado de n8n
├── docker-compose.yml # Configuración Docker para levantar n8n
└── README.md # Documentación del proyecto


### 📌 Archivos incluidos

- **workflow.json**  
  Contiene el workflow completo de n8n encargado de detectar intentos de login sospechosos.

- **docker-compose.yml**  
  Permite levantar una instancia local de n8n mediante Docker.

---

## ⚙️ Funcionamiento del Workflow

El workflow realiza las siguientes acciones:

1. Recibe eventos de intentos de login (simulados).
2. Procesa y normaliza los datos recibidos.
3. Evalúa las condiciones de detección.
4. Si se supera el umbral definido de intentos fallidos:
   - Marca el evento como incidente.
   - Ejecuta una acción automatizada (alerta, registro, etc.).

---

## 🧠 Lógica de Detección

La detección se basa en:

- Conteo de intentos fallidos por usuario/email.
- Comparación contra un umbral definido.
- Activación de alerta cuando se detecta comportamiento anómalo.

Este enfoque simula un mecanismo básico de detección de ataques tipo:

- Fuerza bruta
- Credential stuffing
- Intentos reiterados de acceso no autorizado

---

## 🐳 Despliegue con Docker

### 1️⃣ Requisitos previos

- Docker instalado
- Docker Compose instalado

### 2️⃣ Levantar el entorno

Desde la raíz del proyecto ejecutar: ```docker compose up -d```

### 3️⃣ Acceder a n8n

Abrir el navegador en: http://localhost:5678