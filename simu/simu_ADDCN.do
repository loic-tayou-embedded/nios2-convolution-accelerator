# Fichier .do : script de simulation en langage tcl/tk

### Supprimer la bibliothèque work si elle existe
if {[file exists "work"]} {
    file delete -force work
}

vlib work

vcom -93 ../src/ADDC1.vhd
vcom -93 ../src/ADDCN.vhd
vcom -93 ADDCN_tb.vhd

vsim -voptargs="+acc" work.ADDCN_tb


# pour visualiser tous les signaux du design :
view signals
add wave *

### Lancer la simulation complète
run -all

### Fermer proprement la simulation
#quit -sim