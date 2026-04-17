#!/bin/bash
MODELSIM=~/intelFPGA_lite/18.1/modelsim_ase
SIM_DIR=/home/benja/Documentos/2026-1/procesamiento-paralelo/labo1/laboratorio/templates/simulation/modelsim
DO_FILE=/home/benja/Documentos/2026-1/procesamiento-paralelo/labo1/laboratorio/solucion/simulacion/sim_sorter.do
OUTPUT=/home/benja/Documentos/2026-1/procesamiento-paralelo/labo1/laboratorio/solucion/simulacion/ondas.vcd

cd $SIM_DIR

if [ ! -f modelsim.ini ]; then
    cp $MODELSIM/modelsim.ini .
    chmod u+w modelsim.ini
fi

$MODELSIM/bin/vsim -c -do "do $DO_FILE"

echo ""
echo "=== Simulacion completada ==="
echo "Para visualizar: gtkwave $OUTPUT"
