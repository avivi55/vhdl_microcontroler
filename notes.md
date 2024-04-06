# UAL (ALU)
- 16 fonctions(instructions): avec 2 entrées(4b): sortie 8b
    - bitwise shift, deux sorties `SR_OUT_L`(1b) et `SR_OUT_R`(1b) 
    - combinatoire
- choix des op => `SEL_FCT`(4b)
- entrées signés
- 3 buffer d'entrées (pour la stabilité)

calcul en ~ 3 période

## entité
### entrées
- A(4)
- B(4)
- SR_IN_L(1)
- SR_IN_R(1)
- SEL_FCT(4)
  
### sorties
- S(8)
- SR_OUT_L(1)
- SR_OUT_R(1)

### architecture
#### algo général

`match case` de la table de vérité.

#### processus
sensibilité: (`A`,`B`, `SR_IN_L`, `SR_IN_R`, `SEL_FCT`)
**case**: `default` <- cas `nop`



# DBus
Système d'interconnexion

`SEL_ROUTE` = choisir la route des entrées
`SEL_OUT` = choisir la route de la sortie

# Cache
cache en 8b


# Exemple addition

1. A_in -> Buf_B, NOP, Res_out=0
2. B_in -> Buf_B, Buf_A+Buf_B, Res_out=0
3. S -> MEM1, NOP, REs_out=MEM1