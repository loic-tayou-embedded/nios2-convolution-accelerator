# Accélérateur Nios II – Convolution 3×3 & filtre moyenneur (Custom Instruction)

Projet personnel d’accélération matérielle sur processeur **Nios II** via des
**instructions personnalisées (Custom Instruction – interface extended)**.

Le projet met en œuvre deux traitements :

- une **convolution 3×3** de type gaussienne sur une petite image (4×4),  
- un **filtre moyenneur 1D** sur une ligne de données,

chacun implémenté sous deux formes : **version software en C** et **version hardware via une Custom Instruction**.

L’objectif est de mesurer le **speedup** apporté par le matériel à l’aide du **timestamp timer** de la HAL Nios II.


## 🎯 Objectifs du projet

- Concevoir et implémenter **deux Custom Instructions différentes** :
  - une instruction **multi-cycle** `MAC_OP` pour la convolution 3×3,
  - une instruction **combinatoire** `FILTRE_MOYENNEUR` pour un filtre moyenneur 1D.
- Intégrer ces instructions dans un système Nios II via **Platform Designer (Qsys)**.
- Développer les versions **C** des mêmes traitements pour servir de référence.
- Mesurer les temps d’exécution avec le **timestamp timer** et comparer HW vs SW.


## 🧱 Architecture globale

### Plateforme matérielle

- FPGA (type Cyclone II sur carte DE1 dans ce projet),
- Processeur **Nios II** (système généré avec Platform Designer),
- Périphériques principaux :
  - Custom Instruction extended (port vers `MAC_FILTRE_INTERFACE`),
  - Timer de timestamp (utilisé via `alt_timestamp`),
  - JTAG UART (pour logs / traces éventuelles).


## 🔧 Blocs matériels (VHDL)

Les fichiers VHDL sont dans le dossier `src/`.

### `MAC_OP.vhd` – Instruction multi-cycle : convolution 3×3

- Réalise une opération de type **MAC (Multiply–Accumulate)** sur plusieurs produits valeur × coefficient.
- Utilisée pour calculer un pixel de la **convolution 3×3 gaussienne** sur une image 4×4.
- Fonctionnement typique :
  - accumulation des produits sur plusieurs cycles,
  - signal de “done” vers le Nios II une fois l’accumulation terminée.

### `FILTRE_MOYENNEUR.vhd` – Instruction combinatoire : filtre 1D

- Implémente un **filtre moyenneur 1D** de type :

  ```text
  y[i] = (3 · x[i] + 1 · x[i+1]) >> 2
  ```
- Logique purement combinatoire (résultat en un cycle de clock côté Nios II).

### `MAC_FILTRE_INTERFACE.vhd - Interface extended entre le Nios II et les deux instructions`

- Décodage du champ de sélection d’instruction `n` pour choisir entre MAC_OP et FILTRE_MOYENNEUR,
- Multiplexage des signaux de données.

### Blocs auxiliaires

- ADDC1.vhd, ADDCN.vhd : blocs d’addition sur un ou plusieurs opérandes,
- multiplier.vhd       : bloc de multiplication,
- TOP_LEVEL.vhd        : intégration des blocs dans le système global.

### 🧠 Architecture logicielle (C embarqué)

Code C : voir `software/main.c`.
- Macro pour facilité l'utilisation des instruction dans le code : `custom_mac_op()` et `filtre_moyenneur_custom()`,
- Implementations des versions software de la convolution 3×3 et du filtre moyenneur 1D,
- Mesures de performances avec `alt_timestamp()`, calcul de l’accélération.

## 🛠 Outils & environnement

- Carte FPGA (type DE1 Cyclone II).
- Intel Quartus Prime pour la synthèse et l’implantation FPGA,
- Platform Designer / Qsys pour l’intégration Nios II + Custom Instruction,
- Altera monitor programme pour la compilation et le debug C,
_ ModelSim pour simuler les blocs VHDL,

## ⚙️ Mise en route

1. Synthèse FPGA

	- Ouvrir le projet Quartus dans le dossier fit/.
	- Vérifier le mapping de la Custom Instruction dans le système Nios II.
	- Lancer : `Start Compilation`
	- Programmer la carte avec le fichier .sof généré.

2. Build logiciel Nios II

	- Créer une `BSP` à partir de nios_system.sopcinfo.
	- Créer un projet d’application C et y ajouter software/main.c.
	- Régénérer la `BSP` si nécessaire.
	- Compiler, puis télécharger le `.elf` sur la carte.
	- Observer les résultats (temps d’exécution SW vs HW) via la console série.

## 📂 Organisation du dépôt
```text
src/        # VHDL : MAC_OP, FILTRE_MOYENNEUR, interface extended, additions, top-level…
fit/        # Projet Quartus / Qsys (Nios II + Custom Instruction)
software/   # Code C embarqué (HAL Nios II) pour tester et mesurer les performances
simu/       # Testbenches & scripts ModelSim
