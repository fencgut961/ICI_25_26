## ¿Qué es el Poison Null Byte?

El **Poison Null Byte** es una técnica de bypass que aprovecha **validaciones incompletas del nombre de un archivo** en una aplicación.

Algunas aplicaciones comprueban solo una parte del nombre del archivo, por ejemplo verificando que termine en `.md`. Sin embargo, el sistema o la librería que realmente abre el archivo puede interpretarlo de forma distinta.

El **Null Byte (`\x00`)** es un carácter especial que, en ciertos lenguajes y librerías (especialmente heredadas de C), indica el **fin de una cadena de texto**. Todo lo que aparece después de ese carácter se ignora.

Un atacante puede inyectar ese carácter usando codificación en la URL (por ejemplo `%00` o `%2500`). De este modo:
- La aplicación “ve” un archivo válido (`archivo.md`)
- El sistema interpreta solo `archivo` y accede a un recurso no permitido

El resultado es que se pueden **descargar o acceder a archivos que deberían estar bloqueados**, como configuraciones, código fuente o datos sensibles.

Este fallo no es un problema complejo, sino una consecuencia directa de **validar extensiones sin normalizar y decodificar correctamente la entrada del usuario**.


## Orientaciones para el alumno – Poison Null Byte

El objetivo de este ejercicio no es probar combinaciones al azar, sino **entender cómo se está validando el acceso a los archivos** y detectar incoherencias entre lo que comprueba la aplicación y lo que realmente se descarga.

### 1. Observa el comportamiento de la aplicación
- Fíjate en **qué enlaces existen** y **qué rutas aparecen en la URL** al navegar por la web.
- Analiza qué ocurre cuando modificas **ligeramente** la URL de forma manual.
- Pregúntate: ¿la aplicación valida rutas completas o solo partes del nombre del archivo?

### 2. Analiza las restricciones
- Comprueba **qué tipo de archivos están permitidos** y cuál es el patrón común entre ellos.
- Piensa si la validación se basa solo en el **nombre/extensión** o en algo más robusto.
- Reflexiona: ¿qué pasa si el nombre del archivo contiene algo inesperado?

### 3. Piensa en cómo funcionan internamente los sistemas
- Recuerda cómo los sistemas y lenguajes interpretan las **cadenas de texto**.
- No todo lo que ve el navegador se procesa igual en el backend.
- Algunas validaciones se hacen “antes” y otras “después” de interpretar la entrada.

### 4. Juega con la codificación, no con la fuerza bruta
- Las URLs no siempre se interpretan literalmente.
- Existen caracteres especiales que pueden **no verse a simple vista**, pero sí afectar al procesamiento.
- Investiga qué ocurre cuando un sistema recibe **datos codificados** y cómo los transforma.

Pista final:  
> Si una aplicación valida una cosa, pero el sistema interpreta otra… ahí suele estar la vulnerabilidad.