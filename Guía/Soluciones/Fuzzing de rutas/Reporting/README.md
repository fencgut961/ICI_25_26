## **Reporte de vulnerabilidad – Information Exposure via Client-Side Routing**

**ID & Título** VULN-WEB-002 – Enumeración de rutas y descubrimiento de activos mediante análisis de enrutamiento en el cliente

**Categoría** Exposición de Información (Information Exposure)

**Severidad** Media

**Activo afectado** Lógica de enrutamiento en archivo estático: `main.js`

**Descripción** La aplicación gestiona su sistema de rutas en el lado del cliente utilizando un archivo JavaScript. Aunque el servidor está configurado para redirigir cualquier ruta no encontrada a la raíz (`/`), esta configuración no impide la enumeración de endpoints válidos. Al analizar el archivo `main.js`, un atacante puede identificar rutas existentes y utilizar técnicas de *fuzzing* (excluyendo la longitud de respuesta de la página de inicio) para confirmar qué secciones de la web están activas, exponiendo potencialmente paneles ocultos o funcionalidades en desarrollo.

**Pasos de reproducción (PoC)** 
1.  Identificar que cualquier ruta aleatoria (ej. `/vulnerabilidad-test`) redirige al Home con una longitud de respuesta específica.   
2.  Localizar el archivo `main.js` en las herramientas de desarrollador y observar que contiene definiciones de rutas como `/admin`, `/config` o `/debug`.   
3.  Utilizar una herramienta de fuzzing (ffuf o Burp Suite) con un diccionario de rutas, configurando un filtro para ignorar las respuestas con esa longitud:
```bash
gobuster dir -u http://[IP]:3000/ \
-w [diccionario] \
-x html,php,js,css,json \
-t 50 \
--exclude-length 75055
```   
4.  Analizar los resultados que no fueron filtrados; estos corresponden a rutas reales que cargan componentes específicos de la aplicación.   

**Evidencias** * Captura del código fuente en `main.js` donde se listan las rutas del aplicativo.

* Captura de pantalla de la herramienta de fuzzing mostrando el descubrimiento de rutas (ej. `/admin`) tras filtrar el tamaño de la página Home.
* Diferencia de logs entre una petición a una ruta inexistente y una ruta existente pero "oculta".

**Impacto** Un atacante puede descubrir la superficie de ataque completa de la aplicación, encontrando rutas que no deberían ser públicas. Esto facilita ataques dirigidos contra paneles administrativos o endpoints sensibles que dependen exclusivamente de la "oscuridad" para su protección.

**Probabilidad** Alta. El archivo JavaScript es público por diseño y el uso de herramientas de filtrado por longitud de respuesta es una técnica estándar y automatizable.

**Mitigación (Quick Win)** * Ofuscar y minificar los archivos JavaScript de producción para dificultar la extracción manual de rutas.

* Configurar el servidor para que devuelva un código de estado `404 Not Found` real en lugar de una redirección `200 OK` para rutas que no existen en el backend.

**Mitigación (Long Term)** * Implementar "Code Splitting" (división de código) para que el cliente solo descargue los fragmentos de JavaScript necesarios para su nivel de privilegio.

* Mover la lógica de autorización al lado del servidor; el cliente no debe conocer la existencia de rutas a las que no tiene permiso de acceder.

**Validación** * Realizar un escaneo de rutas filtrando por la longitud del Home y verificar que no se obtengan falsos positivos (rutas ocultas).

* Confirmar que el archivo JavaScript principal no contiene un mapa completo de todas las rutas administrativas del sitio.