if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work /home/benja/Documentos/2026-1/procesamiento-paralelo/labo1/laboratorio/templates/datapath.vhd
vcom -93 -work work /home/benja/Documentos/2026-1/procesamiento-paralelo/labo1/laboratorio/templates/controlador.vhd
vcom -93 -work work /home/benja/Documentos/2026-1/procesamiento-paralelo/labo1/laboratorio/templates/sorter.vhd
vcom -93 -work work /home/benja/Documentos/2026-1/procesamiento-paralelo/labo1/laboratorio/solucion/simulacion/tb_sorter.vhd

vsim work.tb_sorter

vcd file /home/benja/Documentos/2026-1/procesamiento-paralelo/labo1/laboratorio/solucion/simulacion/ondas.vcd
vcd add /tb_sorter/clock
vcd add /tb_sorter/resetn
vcd add /tb_sorter/go
vcd add /tb_sorter/wrinit
vcd add /tb_sorter/datain
vcd add /tb_sorter/radd
vcd add /tb_sorter/dataout
vcd add /tb_sorter/done
vcd add /tb_sorter/uut/ctrl_signal
vcd add /tb_sorter/uut/i_signal
vcd add /tb_sorter/uut/j_signal
vcd add /tb_sorter/uut/control/estado_actual
vcd add /tb_sorter/uut/control/i_reg
vcd add /tb_sorter/uut/control/j_reg
vcd add /tb_sorter/uut/datos/R

run 1500ns
vcd flush
quit -f
