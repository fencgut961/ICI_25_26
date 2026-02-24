# Fuzzing de rutas

## Paso 1: Método Manual

Este metodo solo se usa cuando estas buscando algo especifico que un diccionario normal no puede encontrar, como seria la pagina admin en una web que usa un prefijo especifico, o para hacer alguna busqueda rápida si buscas algo en especifico.

### Pasos

En el navegador modifica la parte del final de la url para añadir lo que quieras buscar:   
`http://[IP o url de la pagina]:[puerto]/[lo que buscas]`   
   
Ejemplo: Te han dado un contenedor en docker que debes auditar que esta en el puerto 8080, por lo que has visto hasta ahora parece que la pagina usa el prefijo "ls-" en sus directorios y solo 3 letras despues. Asi que si intentaras encontrar la url de administracion usarias esta dirreccion:   
`http://localhost:8080/ls-adm`

---

## Paso 2: Inspección del Cliente (DevTools)

Este método se usa para descubrir rutas válidas inspeccionando el código del lado cliente. Es especialmente útil cuando la aplicación web carga rutas mediante JavaScript o cuando es el propio cliente el que valida qué rutas se pueden usar.

### Pasos para Network

1. Abre la web objetivo en el navegador.
2. Pulsa F12 o Ctrl + Shift + I para abrir las DevTools.
3. Entra en el apartado Network y recarga la página para ver todas las peticiones que realiza la web.
4. Observa las solicitudes a archivos, APIs o rutas internas que puedan no ser visibles directamente en la URL.

### Pasos para Sources

1. Abre la web objetivo en el navegador.
2. Pulsa F12 o Ctrl + Shift + I para abrir las DevTools.
5. Accede al apartado Sources, donde podrás ver los archivos JavaScript cargados por la aplicación.
6. Usa Ctrl + F para buscar rutas, endpoints o validaciones de acceso dentro del código (por ejemplo `/admin`, `/api`, `/panel`, etc.).

Ejemplo:
Estás auditando una web y no aparecen rutas interesantes con fuzzing. Al revisar Sources, encuentras un archivo JavaScript que contiene una validación como:

```
if (route === "/admin") {
    loadAdminPanel();
}
```

Esto indica que la ruta `/admin` existe y puede ser accesible directamente desde:
`http://[IP o url]:[puerto]/admin`

---

## Paso 3: Automatización con Gobuster

Este método se usa para descubrir rutas y directorios de forma automática utilizando la herramienta Gobuster. Es muy eficaz, pero debe usarse con cuidado para no sobrecargar la página objetivo.

**Aviso importante**:
Para las pruebas contra una página del taller, se debe usar un diccionario propio y pequeño, evitando listas grandes que puedan generar demasiadas peticiones y provocar la caida de la pagina.

### Diccionario recomendado

Este es un diccionario pequeño, ideal para prácticas:

```
admin
administration
login
register
profile
rest
api
users
basket
orders
products
search
assets
ftp
uploads
config
backup
```

### Pasos

1. Prepara un diccionario reducido con las rutas más comunes o relevantes para la auditoría.
2. Ejecuta Gobuster indicando la URL objetivo y el diccionario.
3. Analiza las respuestas del servidor, prestando atención a los códigos HTTP (200, 301, 403, etc.).

Estructura general del comando:
`gobuster dir -u http://[IP o url]:[puerto] -w [diccionario]`

Ejemplo:
Tienes una web de pruebas en el puerto 8080 y un diccionario pequeño creado por ti llamado `routes.txt`:

```
gobuster dir -u http://localhost:8080 -w routes.txt
```

Gobuster probará cada ruta del diccionario y mostrará únicamente aquellas que existan o respondan de forma relevante, permitiendo identificar directorios ocultos sin generar una carga excesiva sobre el servidor.

---

