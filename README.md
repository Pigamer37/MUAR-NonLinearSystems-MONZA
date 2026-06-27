# Simulador Monza y controladores

Este repositorio contiene el simulador propio y controladores desarrollados en MatLab en el contexto de la asignatura "Sistemas no Lineales" del Master Universitario en Automática y Robótica.

### ¡Importante!
> [!IMPORTANT]
> Algunos de los archivos de Simulink requieren un bloque llamado TFM_SIMULACI_N (o TFM_SIMULACIÓN), y ficheros .mat definiendo la geometría del juego monza (dificultad1.mat, etc), que no se incluyen en este repositorio ya que es código/software de terceros; estos archivos se proveen en el contexto de la asignatura en una carpeta llamada MONZA_SIMULACIÓN. Esta carpeta debe añadirse al path de MatLab para que todo funcione correctamente.

## Non Linear Model Predictive Controller (NLMPC)
Este controlador funciona en dos simuladores (el propio y el provisto en la asignatura). Para elegir en cuál, se debe cambiar la variable `mdl` del script simulacion_monza_tfm.m y abrir el modelo de Simulink (.slx) del mismo nombre:

- `'MONZA'`: Simulador propio
- `'Monza_simulacion_NLMPC'`: Simulador provisto

Cabe destacar que para el simulador provisto funcionara correctamente, hubo que modificarlo de dos formas:

1. Exponer la variable `piso` como salida para alimentar el setpoint del controlador
2. Cambiar de
```matlab
if xo>=(x7i) || xo<(x7d)
```
a
```matlab
if xo<=(x7i) || xo>(x7d)
```
para que funcionara el piso 7 en todos los niveles de dificultad

El NLMPC es capaz de superar los 4 niveles de dificultad del simulador propio, aunque de forma un poco extraña porque no tiene fricción. En el caso del simulador provisto, las dificultades 1 y 2 son exitosas, pero la 3 y la 4 fallan en el piso 7 (que sin el arreglo antes descrito hubiera sido el final de la simulación, por otro lado).
Como el script genera vídeos de las simulaciones, se han añadido vídeos de los mejores resultados al repositorio con el formato `{Nombre_del_modelo}{dificultad}.avi`.
