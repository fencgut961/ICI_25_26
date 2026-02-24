# Reporte de Vulnerabilidad - SQL Injection

## ID & Título
**VULN-2026-001** - SQL Injection en endpoint de búsqueda de productos

## Severidad
**Alto**

## Activo afectado
- **Endpoint:** `/rest/products/search`
- **Parámetro vulnerable:** `q`
- **URL completa:** `GET /rest/products/search?q=[PAYLOAD]`
- **Aplicación:** OWASP Juice Shop

## Descripción
El endpoint de búsqueda de productos no sanitiza correctamente las entradas del usuario en el parámetro `q`, permitiendo la inyección de comandos SQL arbitrarios. Al enviar comillas simples (`'`) como valor de búsqueda, la aplicación genera un error SQL o comportamiento anómalo, confirmando que la entrada se interpreta directamente en la consulta a la base de datos sin validación.

## Pasos de reproducción (PoC)
1. Configurar Burp Suite como proxy e iniciar el navegador integrado
2. Navegar a OWASP Juice Shop
3. Utilizar el buscador de productos con un término válido (ej: "apple")
4. En Burp Suite → Proxy → HTTP History, localizar la petición: `GET /rest/products/search?q=apple`
5. Clic derecho sobre la petición → **Send to Repeater**
6. En la pestaña Repeater, modificar el parámetro `q` por una comilla simple: `q='`
7. Hacer clic en **"Send"** para reenviar la petición modificada
8. Observar la respuesta HTTP que muestra error SQL o comportamiento anómalo
9. **Explotación completa:** La consulta devuelve 9 columnas y existe una tabla `Users` que puede ser objetivo de extracción

## Evidencias
- **Petición original:** `GET /rest/products/search?q=apple`
- **Petición con payload:** `GET /rest/products/search?q='`
- **Respuesta esperada:** Error SQL visible o cambio en el comportamiento de la aplicación
- **Capturas:** Disponibles en la documentación del taller (Paso1.PNG, Paso3.PNG)

## Impacto
Un atacante podría:
- Extraer información sensible de la base de datos (credenciales de usuarios, datos personales)
- Acceder a la tabla `Users` y obtener contraseñas, correos electrónicos y otra información confidencial
- Modificar o eliminar datos críticos de la base de datos
- Bypassear mecanismos de autenticación y autorización
- En casos extremos, ejecutar comandos del sistema operativo si los privilegios de la base de datos lo permiten

## Probabilidad
**Alta**

La vulnerabilidad es fácilmente explotable:
- Requiere únicamente acceso público al formulario de búsqueda
- No necesita autenticación previa
- El payload más simple (`'`) confirma la vulnerabilidad
- Las herramientas necesarias (Burp Suite) son gratuitas y ampliamente disponibles
- La explotación puede automatizarse con herramientas como SQLMap

## Mitigación (Quick Win)
- Implementar inmediatamente **prepared statements** o **consultas parametrizadas** en el código que maneja el parámetro `q`
- Añadir validación de entrada que rechace caracteres especiales SQL (comillas simples, punto y coma, guiones dobles)
- Configurar mensajes de error genéricos que no revelen información sobre la estructura de la base de datos
- Aplicar el principio de menor privilegio a la cuenta de base de datos utilizada por la aplicación

## Mitigación (Long Term)
- Adoptar un **ORM** (Object-Relational Mapping) que gestione automáticamente las consultas seguras
- Implementar un **WAF** (Web Application Firewall) con reglas específicas anti-SQLi
- Realizar auditorías de código estáticas (SAST) para detectar patrones inseguros
- Establecer políticas de desarrollo seguro que incluyan revisión de código peer-to-peer
- Implementar sanitización y validación de entradas en todas las capas (cliente, servidor, base de datos)
- Configurar monitorización y alertas para detectar intentos de inyección SQL en tiempo real
- Establecer un programa de pruebas de seguridad periódicas (pentesting)

## Validación
Para verificar que la vulnerabilidad ha sido corregida:

1. Repetir los pasos de reproducción enviando el payload `q='`
2. Verificar que la aplicación devuelve una respuesta normal o un mensaje de error genérico (sin información SQL)
3. Probar payloads adicionales:
   - `q=' OR '1'='1`
   - `q=' UNION SELECT NULL--`
4. Confirmar que ninguno de estos payloads genera errores SQL ni comportamiento anómalo
5. Realizar revisión de código para confirmar el uso de prepared statements
6. Ejecutar herramientas automáticas (SQLMap) en modo de verificación
7. Validar con Burp Suite Scanner o similares que no se detectan vulnerabilidades SQLi en el endpoint

---

**Fecha del reporte:** 15 de enero de 2026  
**Auditor:** Nerea Candón Ramos
**Metodología:** OWASP Testing Guide
