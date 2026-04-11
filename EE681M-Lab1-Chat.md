# EE681M – Lab 1 – Resumen completo del chat
**UNI-FIEE 2026-1 | Arquitectura de Computadores de Procesamiento Paralelo**

---

## 1. ¿De qué trata el informe?

El laboratorio consiste en diseñar, simular e implementar un **circuito sorter (ordenador)** usando el modelo FSM+D en VHDL, implementado sobre una FPGA Cyclone V SoC.

1. **Objetivo:** Ordenar 8 números de 4 bits (k=8, n=4) en forma ascendente usando el algoritmo de burbuja, almacenados en registros R0 a R7.
2. **Arquitectura jerárquica:** Tres archivos VHDL: `sorter.vhd` (tope), `datapath.vhd` y `controlador.vhd`.
3. **Modos de operación:**
   - *Modo inicialización* (`go=1`): se cargan valores en los registros vía `datain` y `radd`.
   - *Modo procesamiento* (`go=0`): se ejecuta el ordenamiento burbuja; al finalizar, `done=1`.
4. **Controlador:** FSM con estado inicial S0 (reset asíncrono activo bajo). Genera 3 señales de control hacia el datapath, más los índices `i[2..0]` y `j[2..0]`.
5. **Datapath:** 8 registros de 4 bits, implementados con flip-flops tipo D, activados por flanco de subida de `clock`.
6. **Simulación:** Dispositivo Cyclone V SoC 5CSEMA5F31C6, período de reloj 12 ns, tiempo de simulación 1.5 µs en Quartus Prime Lite 18.1.
7. **Análisis de tiempos:** Ejecutar Timing Analyzer con `timing.tcl` para verificar setup/hold times. Categorías en rojo = violaciones de timing.
8. **Entregables y fechas:**
   - Informe parcial: 17/04/2026
   - Demostración en FPGA: 24/04/2026
   - Informe final (VHDL + simulaciones): 01/05/2026
9. **Preguntas del informe final:** FMAX, setup/hold times del datasheet, valores de slack time por categoría en el Timing Analyzer, expresión del tiempo de ordenamiento.
10. **Calificación total:** 20 puntos distribuidos entre asistencia, test, informe parcial, demostración en FPGA e informe final.

---

## 2. División del trabajo entre 2 personas

### Informe Parcial (entrega: 17/04/2026)

**Persona A → Módulo DATAPATH (`datapath.vhd`)**
1. Diseñar los 8 registros de 4 bits con flip-flops tipo D
2. Implementar la lógica de lectura/escritura con `wrinit`, `radd` y `datain`
3. Implementar la lógica de comparación e intercambio usando índices i y j
4. Escribir el código VHDL del datapath
5. Realizar simulación funcional preliminar del datapath solo

**Persona B → Módulo CONTROLADOR (`controlador.vhd`)**
1. Diseñar el diagrama de estados de la FSM (S0, S1, S2...)
2. Definir la codificación de las 3 señales de control
3. Implementar la lógica de transición entre modos (inicialización → procesamiento)
4. Escribir el código VHDL del controlador
5. Realizar simulación funcional preliminar del controlador solo

### Informe Final (entrega: 01/05/2026)

**Persona A → Integración y simulación**
1. Integrar datapath y controlador en `sorter.vhd` (archivo tope)
2. Ejecutar simulación funcional completa con el archivo `Waveform.vwf`
3. Documentar resultados de simulación (variedad de valores, señales internas, estados FSM)
4. Preparar las figuras de simulación para el informe

**Persona B → Timing y redacción del informe**
1. Ejecutar el Timing Analyzer con `timing.tcl`
2. Responder las preguntas de FMAX, setup/hold times, slack times por categoría
3. Analizar si se cumplen las restricciones de tiempo y justificar incumplimientos
4. Calcular la expresión del tiempo de ordenamiento en función del período y cantidad de registros
5. Redactar observaciones y conclusiones

**Tareas compartidas (ambos):**
- Revisión cruzada del código VHDL del otro antes de integrar
- Asistencia a las sesiones presenciales (obligatorio para los 2)
- Demostración en FPGA el 24/04 (deben estar los 2)
- Preparar el zip final con la nomenclatura correcta

---

## 3. ¿Se puede usar VS Code y migrar a Quartus?

**Sí.** VS Code es solo un editor de texto — Quartus no le importa dónde escribiste el código, solo necesita los archivos `.vhd`.

No es posible ejecutar Quartus de forma remota — solo se puede generar el código VHDL. Tú debes compilar, simular y programar la FPGA desde tu laptop con Quartus Prime Lite 18.1 instalado.

---

## 4. Pasos: desde VS Code hasta simulación en Quartus

### Fase 1 — Escribir el código en VS Code
1. Instala la extensión **"VHDL LS"** en VS Code para resaltado de sintaxis
2. Crea una carpeta para el proyecto, por ejemplo `Lab01-Sorter/`
3. Dentro crea los tres archivos: `datapath.vhd`, `controlador.vhd`, `sorter.vhd`
4. Escribe o pega el código VHDL en cada archivo
5. Revisa la sintaxis visualmente con la extensión instalada

### Fase 2 — Importar a Quartus Prime Lite 18.1
6. Abre Quartus Prime Lite 18.1
7. Ve a **File → Open Project** y abre el archivo `.qpf` del `templates.zip`
8. Haz clic derecho sobre **"Files"** → **Add/Remove Files in Project**
9. Agrega tus tres archivos `.vhd`
10. Ve a **Assignments → Settings → General** y verifica que el archivo tope sea `sorter.vhd`
11. Verifica que el dispositivo sea **5CSEMA5F31C6** (Cyclone V SoC)

### Fase 3 — Compilar
12. Ve a **Processing → Start Compilation** (o presiona Ctrl+L)
13. Espera a que termine y revisa el **Compilation Report**
14. Si hay errores en rojo, corrígelos en VS Code, guarda, y vuelve a compilar
15. Si hay advertencias amarillas de timing, anótalas para el análisis posterior

### Fase 4 — Simulación funcional
16. Abre el archivo `Waveform.vwf` desde **File → Open**
17. Configura las señales de entrada:
    - Aplica `resetn = 0` al inicio
    - Luego `resetn = 1`, `go = 1`, `wrinit = 1`
    - Escribe 8 valores distintos de 4 bits en `datain`, cambiando `radd` de 0 a 7
    - Cambia `go = 0` para iniciar el ordenamiento
    - Espera hasta que `done = 1`
18. Ve a **Simulation → Run Functional Simulation**
19. Observa señales internas: estado FSM, índices i y j, contenido de registros, señales de control
20. Captura pantallas de la simulación para el informe

### Fase 5 — Análisis de Timing
21. Ve a **Tools → Timing Analyzer**
22. En la consola Tcl escribe: `source timing.tcl` y presiona Enter
23. Revisa las categorías en rojo en el panel izquierdo
24. Para cada categoría en rojo, anota el valor del **slack** y los nodos **From/To**
25. Documenta FMAX, setup times, hold times y clock-to-output times del **Datasheet Report**

---

## 5. Glosario de tecnicismos

| Término | Significado simple |
|---|---|
| **VHDL** | Lenguaje para describir hardware digital, como si fuera código pero que describe circuitos físicos |
| **FPGA** | Chip reprogramable — puedes cargarle cualquier circuito digital que diseñes |
| **FSM** | Máquina de estados finitos — circuito que avanza entre estados según condiciones, como un semáforo |
| **FSM+D** | Modelo que separa la lógica de control (FSM) del procesamiento de datos (Datapath) |
| **Datapath** | La parte del circuito que manipula los datos: registros, comparadores, multiplexores |
| **Flip-flop tipo D** | Elemento de memoria básico que guarda 1 bit y se actualiza con el flanco del reloj |
| **Flanco de subida** | El instante exacto en que la señal de reloj pasa de 0 a 1 — ahí se actualizan los registros |
| **Clock (reloj)** | Señal periódica que sincroniza todo el circuito — aquí es de 12 ns de período |
| **Reset asíncrono** | Reinicio del circuito que ocurre inmediatamente, sin esperar al reloj |
| **Compilación** | Proceso por el que Quartus traduce tu código VHDL a un circuito real para la FPGA |
| **Simulación funcional** | Prueba virtual del circuito para verificar que funciona lógicamente, sin considerar tiempos físicos |
| **Simulación de tiempos** | Prueba que considera los retardos físicos reales del chip — no disponible con Cyclone V SoC |
| **Timing Analyzer** | Herramienta de Quartus que mide si el circuito puede operar a la velocidad de reloj especificada |
| **Slack** | Margen de tiempo sobrante — si es negativo, el circuito falla a esa frecuencia |
| **Setup time** | Tiempo mínimo que una señal debe estar estable **antes** del flanco de reloj |
| **Hold time** | Tiempo mínimo que una señal debe mantenerse estable **después** del flanco de reloj |
| **FMAX** | Frecuencia máxima a la que puede operar el circuito sin errores de timing |
| **Clock-to-output** | Retardo entre el flanco de reloj y el momento en que la salida del circuito cambia |
| **Slack negativo** | Indica violación de timing — el circuito no alcanza a procesar antes del siguiente ciclo |
| **radd** | Dirección del registro al que quieres leer o escribir (de 0 a 7 en este caso) |
| **wrinit** | Señal que habilita la escritura en los registros durante la inicialización |
| **done** | Señal que indica que el ordenamiento terminó |
| **Método burbuja** | Algoritmo que compara pares de elementos adyacentes y los intercambia si están desordenados |
| **.qpf** | Archivo de proyecto de Quartus |
| **.qsf** | Archivo de configuración de Quartus (pines, dispositivo, restricciones) |
| **.sdc** | Archivo de restricciones de timing (define la frecuencia esperada del reloj) |
| **.vwf** | Archivo de formas de onda para simulación en Quartus |
| **.tcl** | Script de comandos que automatiza tareas dentro de Quartus |

---

## 6. Código VHDL completo

### `datapath.vhd`

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ===========================================================
--  DATAPATH del Sorter - EE681M UNI-FIEE 2026-1
--  8 registros de 4 bits, algoritmo burbuja
--
--  Señales de control (codificacion Moore desde controlador):
--    control = "001" => limpiar (clear) todos los registros
--    control = "010" => escribir datain en R[radd] (inicializacion)
--    control = "100" => intercambiar R[i] y R[j] si R[i] > R[j]
-- ===========================================================

entity datapath is
    port (clock   : in  std_logic;
          wrinit  : in  std_logic;
          control : in  std_logic_vector (2 downto 0);
          i, j    : in  std_logic_vector (2 downto 0);
          datain  : in  std_logic_vector (3 downto 0);
          radd    : in  std_logic_vector (2 downto 0);
          dataout : out std_logic_vector (3 downto 0)
         );
end datapath;

architecture behav of datapath is
    type file_register is array(0 to 7) of std_logic_vector(3 downto 0);
    signal R : file_register;

    signal i_int : integer range 0 to 7;
    signal j_int : integer range 0 to 7;
    signal r_int : integer range 0 to 7;

begin
    i_int <= to_integer(unsigned(i));
    j_int <= to_integer(unsigned(j));
    r_int <= to_integer(unsigned(radd));

    process (clock)
    begin
        if (clock'event and clock = '1') then

            if control = "001" then
                R(0) <= "0000";
                R(1) <= "0000";
                R(2) <= "0000";
                R(3) <= "0000";
                R(4) <= "0000";
                R(5) <= "0000";
                R(6) <= "0000";
                R(7) <= "0000";

            elsif control = "010" then
                if wrinit = '1' then
                    R(r_int) <= datain;
                end if;

            elsif control = "100" then
                if unsigned(R(i_int)) > unsigned(R(j_int)) then
                    R(i_int) <= R(j_int);
                    R(j_int) <= R(i_int);
                end if;

            end if;
        end if;
    end process;

    dataout <= R(r_int);

end behav;
```

---

### `controlador.vhd`

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ===========================================================
--  CONTROLADOR del Sorter - EE681M UNI-FIEE 2026-1
--  FSM de dos procesos (modelo Moore)
--
--  Estados:
--    S0 : reset / espera
--    S1 : borrado sincrono de registros
--    S2 : espera de go='0' para iniciar ordenamiento
--    S3 : iniciar iteracion (i=0, j=i+1)
--    S4 : comparar e intercambiar R[i] y R[j]
--    S5 : incrementar j
--    S6 : verificar si j llego al limite (j=7)
--    S7 : incrementar i
--    S8 : verificar si i llego al limite (i=6)
--    S9 : ordenamiento terminado (done='1')
-- ===========================================================

entity controlador is
    port (clock   : in  std_logic;
          resetn  : in  std_logic;
          go      : in  std_logic;
          i, j    : out std_logic_vector (2 downto 0);
          control : out std_logic_vector (2 downto 0);
          done    : out std_logic
         );
end controlador;

architecture behav of controlador is

    type state_type is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9);
    signal estado_actual : state_type;
    signal estado_sig    : state_type;

    signal i_reg  : unsigned(2 downto 0);
    signal j_reg  : unsigned(2 downto 0);
    signal i_next : unsigned(2 downto 0);
    signal j_next : unsigned(2 downto 0);

begin

    -- PROCESO 1: Registro de estado y contadores (secuencial)
    process (clock, resetn)
    begin
        if resetn = '0' then
            estado_actual <= S0;
            i_reg <= (others => '0');
            j_reg <= (others => '0');
        elsif (clock'event and clock = '1') then
            estado_actual <= estado_sig;
            i_reg <= i_next;
            j_reg <= j_next;
        end if;
    end process;

    -- PROCESO 2: Logica de siguiente estado y salidas (combinacional)
    process (estado_actual, go, i_reg, j_reg)
    begin
        estado_sig <= estado_actual;
        i_next     <= i_reg;
        j_next     <= j_reg;
        control    <= "000";
        done       <= '0';
        i          <= std_logic_vector(i_reg);
        j          <= std_logic_vector(j_reg);

        case estado_actual is

            when S0 =>
                control <= "000";
                if go = '1' then
                    estado_sig <= S1;
                else
                    estado_sig <= S0;
                end if;

            when S1 =>
                control    <= "001";
                i_next     <= (others => '0');
                j_next     <= (others => '0');
                estado_sig <= S2;

            when S2 =>
                control <= "010";
                if go = '0' then
                    i_next     <= (others => '0');
                    j_next     <= to_unsigned(1, 3);
                    estado_sig <= S3;
                else
                    estado_sig <= S2;
                end if;

            when S3 =>
                control    <= "000";
                j_next     <= i_reg + 1;
                estado_sig <= S4;

            when S4 =>
                control    <= "100";
                estado_sig <= S5;

            when S5 =>
                control    <= "000";
                j_next     <= j_reg + 1;
                estado_sig <= S6;

            when S6 =>
                control <= "000";
                if j_reg = "111" then
                    estado_sig <= S7;
                else
                    estado_sig <= S4;
                end if;

            when S7 =>
                control    <= "000";
                i_next     <= i_reg + 1;
                estado_sig <= S8;

            when S8 =>
                control <= "000";
                if i_reg = "110" then
                    estado_sig <= S9;
                else
                    j_next     <= i_reg + 2;
                    estado_sig <= S3;
                end if;

            when S9 =>
                control    <= "000";
                done       <= '1';
                estado_sig <= S9;

            when others =>
                estado_sig <= S0;

        end case;
    end process;

end behav;
```

---

### `sorter.vhd`

```vhdl
library ieee;
use ieee.std_logic_1164.all;

-- ===========================================================
--  SORTER (archivo tope) - EE681M UNI-FIEE 2026-1
--  Conecta el datapath y el controlador
-- ===========================================================

entity sorter is
    port (clock   : in  std_logic;
          resetn  : in  std_logic;
          go      : in  std_logic;
          wrinit  : in  std_logic;
          datain  : in  std_logic_vector (3 downto 0);
          radd    : in  std_logic_vector (2 downto 0);
          dataout : out std_logic_vector (3 downto 0);
          done    : out std_logic
         );
end sorter;

architecture estruct of sorter is

    component datapath
        port (clock   : in  std_logic;
              wrinit  : in  std_logic;
              control : in  std_logic_vector (2 downto 0);
              i, j    : in  std_logic_vector (2 downto 0);
              datain  : in  std_logic_vector (3 downto 0);
              radd    : in  std_logic_vector (2 downto 0);
              dataout : out std_logic_vector (3 downto 0)
              );
    end component;

    component controlador
        port (clock   : in  std_logic;
              resetn  : in  std_logic;
              go      : in  std_logic;
              i, j    : out std_logic_vector (2 downto 0);
              control : out std_logic_vector (2 downto 0);
              done    : out std_logic
              );
    end component;

    signal ctrl_signal : std_logic_vector (2 downto 0);
    signal i_signal    : std_logic_vector (2 downto 0);
    signal j_signal    : std_logic_vector (2 downto 0);

begin

    datos: datapath
    port map (clock   => clock,
              wrinit  => wrinit,
              control => ctrl_signal,
              i       => i_signal,
              j       => j_signal,
              datain  => datain,
              radd    => radd,
              dataout => dataout
              );

    control: controlador
    port map (clock   => clock,
              resetn  => resetn,
              go      => go,
              i       => i_signal,
              j       => j_signal,
              control => ctrl_signal,
              done    => done
              );

end estruct;
```

---

## 7. Resumen de la codificación de control

| Valor `control` | Operación en Datapath | Estado FSM |
|---|---|---|
| `"001"` | Borrar todos los registros a `0000` | S1 |
| `"010"` | Escribir `datain` en `R[radd]` (si `wrinit='1'`) | S2 |
| `"100"` | Comparar `R[i]` y `R[j]`, intercambiar si `R[i] > R[j]` | S4 |
| `"000"` | Sin operación | S0, S3, S5, S6, S7, S8, S9 |

## 8. Diagrama de estados de la FSM

```
resetn='0'
   │
  [S0] ──go='1'──► [S1] ──► [S2] ──go='0'──► [S3]
                              │                  │
                           go='1'             j=i+1
                           (loop)               │
                                               [S4] ◄────────┐
                                                │             │
                                               [S5]        j < 7
                                                │             │
                                               [S6] ─────────┘
                                                │
                                             j = 7
                                                │
                                               [S7]
                                                │
                                               [S8] ──i<6──► [S3]
                                                │
                                             i = 6
                                                │
                                               [S9] done='1' (loop)
```

---

*Documento generado a partir del chat de consulta | EE681M UNI-FIEE 2026-1*
