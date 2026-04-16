# Checklist - Laboratorio 1: Sorter (Bubble Sort) en VHDL
**Curso:** EE681M - Arquitectura de Computadores de Procesamiento Paralelo  
**Ciclo:** 2026-1 | UNI-FIEE  
**FPGA:** Cyclone V SoC 5CSEMA5F31C6 | **Reloj:** 12 ns | **Simulacion:** 1.5 us

---

## Fase 1: Codigo VHDL (Informe Parcial - 17/04/2026)

- [ ] **1.1** Completar `sorter.vhd` (archivo tope)
  - Senales internas de interconexion (ctrl_signal, i_signal, j_signal)
  - Port map de datapath y controlador
  - _Notas:_

- [ ] **1.2** Completar `datapath.vhd`
  - Arreglo de 8 registros de 4 bits (R0 a R7)
  - control="001": borrado sincrono de todos los registros
  - control="010": escritura de datain en R[radd] cuando wrinit='1'
  - control="100": comparar R[i] y R[j], intercambiar si R[i] > R[j]
  - Salida dataout no registrada (combinacional): R[radd]
  - _Notas:_

- [ ] **1.3** Completar `controlador.vhd`
  - FSM de dos procesos (modelo Moore)
  - Proceso 1: registro de estado (secuencial, con reset asincrono)
  - Proceso 2: logica de siguiente estado y salidas (combinacional)
  - Estados: S0 (reset/espera) -> S1 (borrado) -> S2 (inicializacion, go='1') -> S3..S8 (bubble sort) -> S9 (done)
  - Senales control[] codificadas segun estado (Moore)
  - Contadores i y j para los indices del arreglo
  - _Notas:_

- [ ] **1.4** Simulacion funcional preliminar de datapath (por separado)
  - _Notas:_

- [ ] **1.5** Simulacion funcional preliminar de controlador (por separado)
  - _Notas:_

---

## Fase 2: Quartus - Compilacion y Simulacion (Demo FPGA - 24/04/2026)

- [ ] **2.1** Crear proyecto en Quartus usando `sorter.qpf`
  - Copiar los 3 .vhd completados a la carpeta del proyecto
  - Verificar que el dispositivo sea Cyclone V SoC 5CSEMA5F31C6
  - _Notas:_

- [ ] **2.2** Compilacion exitosa (Analysis & Synthesis + Fitter + Assembler)
  - Verificar que ninguna categoria del reporte este en rojo
  - _Notas:_

- [ ] **2.3** Simulacion funcional con `Waveform.vwf`
  - Dispositivo: Cyclone V SoC 5CSEMA5F31C6
  - Periodo de reloj: 12 ns
  - Tiempo de simulacion: 1.5 us
  - Variedad de valores de ingreso (sin repetir)
  - Verificar secuencia de senales internas (estado FSM, registros)
  - _Notas:_

- [ ] **2.4** Timing Analyzer
  - Ejecutar: Tools > Timing Analyzer
  - En consola tcl> escribir: `source timing.tcl`
  - Revisar categorias en rojo en "Timing Analyzer GUI"
  - _Notas:_

- [ ] **2.5** Configuracion y demo en FPGA
  - _Notas:_

---

## Fase 3: Analisis y Preguntas (Informe Final - 01/05/2026)

- [ ] **3.1** Responder: valor de FMAX reportado por la herramienta
  - _Respuesta:_

- [ ] **3.2** Responder: del Datasheet Report, valores de Setup Times, Hold Times, Clock to Output Times
  - _Respuesta:_

- [ ] **3.3** Responder: del Report Timing I/O, menores valores de slack time para cada categoria
  - Inputs to Registers (Setup):
  - Inputs to Registers (Hold):
  - Inputs to Registers (Recovery):
  - Inputs to Registers (Removal):
  - Registers to Outputs (Setup):
  - Registers to Outputs (Hold):
  - Inputs to Outputs (Setup):
  - Inputs to Outputs (Hold):
  - _Nodos (From Node / To Node) para cada uno:_

- [ ] **3.4** Responder: es posible cumplir con las restricciones de tiempo? Si no, indicar donde y por que
  - _Respuesta:_

- [ ] **3.5** Expresion del tiempo de ordenamiento en funcion del periodo de reloj y cantidad de registros (peor caso: ordenados de mayor a menor)
  - _Respuesta:_

- [ ] **3.6** Observaciones y conclusiones
  - _Notas:_

- [ ] **3.7** Empaquetar todo en `Lab-01-Informe-Final-Grupo-W.zip`
  - Todos los archivos generados por Quartus Prime
  - Informe en formato Word o PDF
  - _Notas:_

---

## Registro de Avance

| Fecha | Tarea | Estado | Observaciones |
|-------|-------|--------|---------------|
| | | | |
