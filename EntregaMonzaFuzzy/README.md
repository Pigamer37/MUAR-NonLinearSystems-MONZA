# MONZA — Controlador difuso (Fuzzy Logic) — Delia Martínez

Entrega de la alternativa de control **fuzzy logic** del proyecto MONZA. Un mismo
controlador difuso (uno por dificultad) gobierna las **dos plantas**: la propia
(`MONZABlock`) y la suministrada por el profesor (`TFM_SIMULACI_N1`).

## Requisitos
- MATLAB + Simulink
- **Fuzzy Logic Toolbox**
- **Symbolic Math Toolbox** (solo para la planta del profe: `solver.m` usa `solve`)

## Cómo ejecutar
1. Abre uno de los modelos:
   - `MONZA_fuzzy_PROPIA.slx` → planta propia (`MONZABlock`).
   - `MONZA_fuzzy_delia_3.slx` → planta del profe (`TFM_SIMULACI_N1`).
2. Fija la **dificultad** en el bloque `Constant3` (valor 1–4).
3. Pulsa **Play**. El callback `InitFcn` llama a `cargar_fis`, que carga
   automáticamente el `.fis` de esa dificultad en la variable `fisController`.

> La señal de control (giro) se ve en el `Scope1` (salida del Fuzzy Logic Controller);
> el error en `Scope` y la velocidad en `Scope2`. La trayectoria inercial, en el `XY Graph`.

## Animaciones y vídeos
Desde la carpeta del proyecto, en MATLAB:
```matlab
anima_propia(d)       % planta propia, dificultad d (1..4)
anim_SIMULACI_N1(d)   % planta del profe, dificultad d (1..4)
```
Ambas reproducen la animación y **guardan un `.avi`**. Los vídeos ya generados y las
capturas (trayectorias XY, error, control, modelos Simulink y estructura del FIS) están
en la carpeta `GraficosYVideos/`.

## Archivos principales
| Archivo | Descripción |
|---|---|
| `MONZA_fuzzy_PROPIA.slx` | Modelo en lazo cerrado con la planta propia |
| `MONZA_fuzzy_delia_3.slx` | Modelo con la planta del profe (referencia `TFM_SIMULACI_N1.slx`) |
| `TFM_SIMULACI_N1.slx` | Planta suministrada (modelo referenciado) |
| `MONZABlock.m` | Planta propia (MATLAB System) |
| `calcPista.m`, `solver.m` | Geometría de puertas / cálculo del punto de choque |
| `cargar_fis.m` | `InitFcn`: carga el `.fis` según la dificultad |
| `fisController_simulink_dif{1..4}.fis` | Controlador difuso por dificultad |
| `anima_propia.m`, `anim_SIMULACI_N1.m`, `anim_giro_pistas.m` | Animaciones |
| `dificultad{1..4}.mat`, `circulos.mat` | Geometría de las pistas |
| `GraficosYVideos/` | Capturas y vídeos de resultados |
