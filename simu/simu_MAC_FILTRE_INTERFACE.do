# Fichier .do : script de simulation en langage tcl/tk

### Supprimer la bibliothèque work si elle existe
if {[file exists "work"]} {
    file delete -force work
}

vlib work

vcom -93 ../src/ADDC1.vhd
vcom -93 ../src/ADDCN.vhd
vcom -93 ../src/multiplier.vhd
vcom -93 ../src/MAC_OP.vhd
vcom -93 ../src/MAC_FILTRE_INTERFACE.vhd
vcom -93 MAC_FILTRE_INTERFACE_tb.vhd

vsim -voptargs="+acc" work.MAC_FILTRE_INTERFACE_tb


# pour visualiser tous les signaux du design :
view signals

add wave rst
add wave clk
add wave clk_en
add wave start
add wave -radix decimal dataa
add wave -radix decimal datab
add wave mac_done
add wave -radix decimal mac_result

### Lancer la simulation complète
run -all

### Fermer proprement la simulation
#quit -sim