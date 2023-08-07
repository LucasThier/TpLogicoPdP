%comio(Personaje, Bicho) 
comio(pumba, vaquitaSanAntonio(gervasia,3)). 
comio(pumba, hormiga(federica)). 

comio(pumba, hormiga(tuNoEresLaReina)). 
comio(pumba, cucaracha(ginger,15,6)). 
comio(pumba, cucaracha(erikElRojo,25,70)). 

comio(timon, vaquitaSanAntonio(romualda,4)). 
comio(timon, cucaracha(gimeno,12,8)). 
comio(timon, cucaracha(cucurucha,12,5)). 

comio(simba, vaquitaSanAntonio(remeditos,4)). 
comio(simba, hormiga(schwartzenegger)). 
comio(simba, hormiga(niato)). 
comio(simba, hormiga(lula)). 

pesoHormiga(2). 

%peso(Personaje, Peso) 
peso(pumba, 100). 
peso(timon, 50). 
peso(simba, 200). 

persigue(scar, timon).
persigue(scar, pumba).
persigue(shenzi, simba).
persigue(shenzi, scar).
persigue(banzai, timon).
comio(shenzi, hormiga(conCaraDeSimba)).
persigue(scar, mufasa).

peso(scar, 300).
peso(shenzi, 400).
peso(banzai, 500).

% 1) A falta de pochoclos...
% a) ¿Qué cucaracha es jugosita?
jugosita(Cucaracha) :-
    comio(_, cucaracha(_, Tamaño, Peso1)),
    comio(_, Cucaracha),
    Cucaracha = cucaracha(_, Tamaño, Peso2),
    Peso2 > Peso1.

% b) ¿Si un personaje es hormigofílico?
hormigofilico(Personaje) :-
    comio(Personaje, hormiga(_)),
    comio(Personaje, OtraHormiga),
    OtraHormiga \= hormiga(_).

% c) ¿Si un personaje es cucarachofóbico?
cucarachofobico(Personaje) :-
    not(comio(Personaje, cucaracha(_, _, _))).

% d) Conocer al conjunto de los picarones.
picarones(ListaPicarones) :-
    findall(Personaje, esPicaron(Personaje), ListaPicarones).

esPicaron(pumba).
esPicaron(Personaje) :-
    comio(Personaje, Cucaracha),
    Cucaracha = cucaracha(_, _, _),
    jugosita(Cucaracha).
esPicaron(Personaje) :-
    comio(Personaje, vaquitaSanAntonio(remeditos, _)).

% 2) Pero yo quiero carne...
% a) ¿Cuánto engorda un personaje?
cuantoEngorda(Personaje, PesoTotal) :-
    peso(Personaje, PesoOriginal),
    findall(PesoComida, pesoComida(Personaje, PesoComida), PesosComida),
    sum_list(PesosComida, PesoComidas),
    PesoTotal is PesoOriginal + PesoComidas.

pesoComida(Personaje, PesoComida) :-
    comio(Personaje, Comida),
    pesoDeComida(Comida, PesoComida).

pesoDeComida(hormiga(_), 2).
pesoDeComida(cucaracha(_, _, Peso), Peso).
pesoDeComida(vaquitaSanAntonio(_, Peso), Peso).

% b) Cuanto engorda un personaje, considerando a los perseguidos.
cuantoEngordaConPerseguidos(Personaje, PesoTotal) :-
    peso(Personaje, PesoOriginal),
    findall(PesoComida, pesoComida(Personaje, PesoComida), PesosComida),
    findall(PesoPerseguido, pesoPerseguido(Personaje, PesoPerseguido), PesosPerseguidos),
    append(PesosComida, PesosPerseguidos, PesosTotales),
    sum_list(PesosTotales, PesoTotal).

pesoPerseguido(Personaje, PesoPerseguido) :-
    persigue(Personaje, Victima),
    peso(Victima, PesoPerseguido).

% c) Cuánto engorda un personaje, considerando lo comido por las víctimas.
cuantoEngordaConComida(Personaje, PesoTotal) :-
    peso(Personaje, PesoOriginal),
    findall(PesoComida, pesoComida(Personaje, PesoComida), PesosComida),
    findall(PesoPerseguido, pesoPerseguido(Personaje, PesoPerseguido), PesosPerseguidos),
    append(PesosComida, PesosPerseguidos, PesosTotales),
    sum_list(PesosTotales, PesoTotal).

pesoPerseguido(Personaje, PesoPerseguido) :-
    persigue(Personaje, Victima),
    cuantoEngorda(Victima, PesoPerseguido).

% 3) Combinaciones posibles de comidas de un personaje.
combinaComidas(Personaje, ListaComidas) :-
    findall(Comida, (comio(Personaje, Comida); persigue(Personaje, Victima), comio(Victima, Comida)), ListaComidas).

% 4) Buscando el rey...
rey(R) :-
    persigue(Persigue, R),
    not((persigue(OtroPersigue, R), OtroPersigue \= Persigue)),
    forall(adoran(Animal, R), Animal \= R).

adoran(Animal, R) :-
    not(persigue(R, Animal)),
    not(comio(R, Animal)).

% 5) Explicar en dónde se usaron y cómo fueron de utilidad los siguientes conceptos:
% a. Polimorfismo: Se utiliza polimorfismo al definir los predicados calcularPeso y cuantoEngordaConVictimas.
%    Estos predicados pueden manejar diferentes tipos de bichos (hormigas, cucarachas, vaquitas) y calcular sus pesos
%    correctamente según el tipo. Esto hace que los predicados sean más genéricos y reutilizables.

% b. Recursividad: La recursividad se utiliza en el predicado cuantoEngordaConVictimas, donde se calcula el peso
%    de un personaje considerando el peso de sus víctimas y las víctimas de sus víctimas, de manera recursiva.

% c. Inversibilidad: Los predicados definidos son inversibles, lo que significa que se pueden usar en ambos sentidos
%    (haciendo consultas y generando soluciones). Por ejemplo, se pueden hacer consultas como "cuantoEngorda(X, Peso)"
%    para encontrar qué personajes engordan cierta cantidad de peso, y también se pueden hacer consultas como
%    "cuantoEngorda(scar, 150)" para calcular cuánto engordaría Scar.