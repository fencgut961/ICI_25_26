## Reporte de vulnerabilidad – Poison Null Byte

**ID & Título**  
VULN-FTP-001 – Bypass de restricción de extensión mediante Poison Null Byte

**Severidad**  
Alto

**Activo afectado**  
Endpoint de descarga de archivos: `http://localhost:3000/ftp/*`

**Descripción**  
La aplicación aplica una validación incompleta del nombre del archivo, permitiendo únicamente extensiones `.md`. Mediante la inyección de un Null Byte codificado en la URL, es posible bypassear la validación y descargar archivos con extensiones no permitidas.

**Pasos de reproducción (PoC)**  
1. Acceder a `http://localhost:3000/ftp/legal.md`.  
2. Navegar a `http://localhost:3000/ftp` y comprobar que solo se permiten archivos `.md`.  
3. Solicitar un archivo no permitido añadiendo `%2500.md` al final del nombre:  
   `http://localhost:3000/ftp/[archivo]%2500.md`  
4. El navegador inicia la descarga del archivo.

**Evidencias**  
- Captura del listado del directorio `/ftp`.  
- Captura de la descarga iniciada tras usar `%2500.md`.  
- Logs del servidor con la petición HTTP manipulada.

**Impacto**  
Un atacante podría acceder y descargar archivos sensibles del servidor (configuraciones, credenciales o código), comprometiendo la confidencialidad del sistema.

**Probabilidad**  
Alta. El ataque es sencillo, no requiere autenticación y se ejecuta con una única petición HTTP.

**Mitigación (Quick Win)**  
- Normalizar y decodificar completamente la URL antes de validar.  
- Bloquear nombres de archivo que contengan Null Bytes (`\x00`) o codificaciones equivalentes.

**Mitigación (Long Term)**  
- Implementar una allowlist estricta de archivos/rutas permitidas.  
- Evitar el acceso directo al sistema de archivos desde la aplicación web.  
- Usar funciones seguras de manejo de ficheros y validación server-side robusta.

**Validación**  
- Comprobar que peticiones con `%00`, `%2500` u otras variantes no permiten descargas.  
- Verificar que solo archivos explícitamente permitidos son accesibles tras el parche.
