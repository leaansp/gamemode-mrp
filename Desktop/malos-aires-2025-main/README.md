Para correr el servidor se necesita:

XAMPP (MySQL y Apache)
sampctl

Con esto y una vez descargado el repositorio, sobre la carpeta ejecutar el siguiente comando:

sampctl ensure

Esto descargará las dependencias necesarias. Existe un conflicto entre las dependencias de OMP y SAMP que no logré descubrir como solucionar definitivamente,
el arreglo "rápido" es entrar en la carpeta dependencies >> omp-stdlib y allí borrar todo su contenido (pero no la carpeta, dejarla vacía).

Una vez hecho esto, ejecutar el comando:

sampctl build

Esto compilará el marp_core. Con esto ya podemos correr el servidor de test o prod según corresponda, previa carga de la db que se encuentra en
database.

Para ejecutar el servidor podemos utilizar:

sampctl run test
sampctl run prod
