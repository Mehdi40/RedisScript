# **English version :**

The main goal was to implement two new commands to Redis : zAddAll, that would add all items of a sorted set in the same time (during the creation of a cache, for exempe), and zEdit, that would manage the inners changes linked to the adding, the deletion or the change of an item's position.

_Those commands are personnal scripts. To run them on Redis, you have to go with the command, thinked for, EVAL._

## zEdit :

To run the zEdit script : 
`EVAL zEdit.lua KEY ACTION MEMBER ARGS`

This script can be used for severals actions, represented in the code by the variable `action`.

1. **Change :** 
The `ARGS` inside the command becomes `place`, which corresponds to the place, in the ranking, we want to set our item.

`EVAL zEdit.lua TestScript change 3 6` 
This command will take the third item of the list and will put it in the sixth place.
Meanwhile, every item placed between the third and the sixth place will see their position adapted.
The fourth item will go to the third place, the fifth one will go to the fourth place, and the sixth item will finally go to the fifth place.


![zEdit](http://image.noelshack.com/fichiers/2017/09/1488469972-zchange1.png)
_The third item in the sixth place_
![zEdit](http://image.noelshack.com/fichiers/2017/09/1488469972-zchange2.png)
_The sixth item in the third place_

1. **Add :** 
The `ARGS` inside the command becomes `data`, which corresponds to the data we want to include inside the sorted set (in our example, that corresponds to the name of a number). Be careful, the variable we pass to the command must be either a `str` or a `int` (in our case, a `str`).

`EVAL zEdit.lua TestScript add 3 1547855` 
This command will add `1547855` as a set, in the third place. The script automatically manage the shifting of all following items. For example, with a 10-items list, having added this item to the third place, the seven following items will see their ranking increases by one.

![zEdit](http://image.noelshack.com/fichiers/2017/09/1488469972-zadd.png)
_Adding an item to the third place_

1. **Del :** 
`EVAL zEdit.lua TestScript del 3` 
This command will delete an item from the list. Of course, the script will automatically manage position shifting, as we saw it earlier, but this time, it will decrease by one (instead of increasing by one).

![zEdit](http://image.noelshack.com/fichiers/2017/09/1488469973-zdel.png)
_Deletion of the precedent item, from the third place._

## zAddAll : 

To launch the zAddAll script :
`EVAL zAddAll.lua KEY DATA`

The variable `DATA` corresponds to all the items we want to add to a list (sorted set). This must be a JSON array.

For example, if we want to create a new sorted set, named 'TestScript', with three members, we will be running this command : 
`EVAL zAddAll.lua TestScript {'1': '1456551', '2': '1599876', '3': '58514'}`


# **French version :**

L'objectif était d'implémenter deux nouvelles commandes à Redis : zAddAll, qui ajouterait tous les items d'un sorted set en même temps (lors de la création du cache, par exemple), et zEdit, qui devrait gérer les changements de positions internes liés à l'ajout, suppression et la modification de la position d'un item.

_Ces commandes sont des scripts personnels, pour les lancer sur Redis, il faut passer par la commande, prévue pour, EVAL._

## zEdit :

Pour lancer le script zEdit : 
`EVAL zEdit.lua KEY ACTION MEMBER ARGS`

Ce script se divise en plusieurs parties, représentées dans le code par la variable `action`.

1. **Change :** 
Le `ARGS` de la commande devient la variable `place`, qui correspond à la place qu'on veut donner, dans le classement, au membre (du sorted set) sélectionné.

`EVAL zEdit.lua TestScript change 3 6` 
Cette commande changera le troisième item de la liste et le fera passer à la sixième place.
Dans le même temps, tous les items qui se situent entre le troisième et le sixième verront leur position s'adapter automatiquement.
Le 4° item passera à la 3° place, le 5° à la 4°, et le 6° à la 5°.


![zEdit](http://image.noelshack.com/fichiers/2017/09/1488469972-zchange1.png)
_Le troisième item à la sixième place_
![zEdit](http://image.noelshack.com/fichiers/2017/09/1488469972-zchange2.png)
_Le sixième item à la troisième place_

1. **Add :** 
Le `ARGS` de la commande devient la variable `data`, qui correspond à la donnée qu'on veut inclure dans le sorted set (en l'occurrence, ça correspond au nom d'un chiffre). Attention, la variable passée doit obligatoirement être une `str` ou un `int` (dans notre cas, une `str`).

`EVAL zEdit.lua TestScript add 3 1547855` 
Cette commande va ajouter `1547855` comme set, à la 3° place. Le script gère automatiquement le déplacement de tous les items qui le suivent. Par exemple, pour une liste de 10 items, en ayant ajouté cet item à la troisième place, les 7 suivants verront leur classement augmenter d'un point.

![zEdit](http://image.noelshack.com/fichiers/2017/09/1488469972-zadd.png)
_Ajout d'un item à la troisième place_

1. **Del :** 
`EVAL zEdit.lua TestScript del 3` 
Cette commande va supprimer un membre de la liste. Bien entendu, le script va gérer automatiquement les changements de positions, exactement de la même manière que précédemment, mais en enlevant un point à chaque fois.

![zEdit](http://image.noelshack.com/fichiers/2017/09/1488469973-zdel.png)
_Suppression de l'item précédent, de la troisième place_

## zAddAll : 

Pour lancer le script zAddAll :
`EVAL zAddAll.lua KEY DATA`

La variable `DATA` correspond à la liste des items qu'on veut ajouter dans une nouvelle liste, vide. Cette liste d'items doit obligatoirement être au format JSON.

Par exemple, si on veut créer un nouveau sorted set "TestScript" avec trois éléments, on entrera cette commande : 
`EVAL zAddAll.lua TestScript {'1': '1456551', '2': '1599876', '3': '58514'}`