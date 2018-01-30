# Les manuscrits juridiques
* `//emph` : voir les valeurs des `@rend` et `@n` pour normalisation
* pourquoi des `div`pour les `list[@type='listMs']` ?
* inversement, inscrire des `div`pour `list[@type="temoins"]`
* appel des images assez baroque dans l’XSLT… (`oeuvre_2.xsl`) -> on appelle les images directement dans les XML ?
* NB: le `eTree` n’est pas sorti.
* liste des ms: reprendre pour les ark `@ref` pour `@corresp`
* `lang`: biblissima -> avoir la source et la dest pour la traduction: `derivation[@type="translation"][@xml:lang][@sync]``
  * `@xml:lang`: langue cible (*target*)
  * `@sync`: langue source (*source*)
* NB: output HTML: pour `msIdentifier`ne pas sortir `country`
* authenticu.xml: revoir avec FD la structuration des éditions (des subdivisions en fonction des parties éditées ?)
* bazar total pour les notes
* revoir l’identification des paragraphes dans les transcriptions (`label`)
* `codex_justinianus.xml`: revoir les `label` des éditions.
* revoir les espacements entre les `supplied`
* dans les éditions : `label` = référence du paragraphe transcrit

# articulation Notice / content. ex. du ms BnF fr. 263
`//msDesc[contains(msIdentifier/idno, '263')]`
-> des msDesc pour le même manuscrit => physDesc, etc. / msContents (comment réordonner les msContents ?)
-> objectif: ramasser les infos sur un manuscrit pour produire une notice exhautive
-> poser une clé: @source
NB. On ne peut pas garantir la pose de @source => il faut poser des @xml:id

on a souvent 2 msDesc pour un même manuscrit :
* listBibl/msDesc : la liste des ms avec leur descriptif physique (physDesc, etc.)
* msDesc/msContents : l’édition des parties du manuscrit (édition des contenus)

Proposition :
* listBibl/msDesc a un `@type="main"`: c’est le msDesc de référence
* msDesc/msContents doit pouvoir être agrégé -> `@type="contents"` : pour générer la notice complète, on fait un indclude dans le `msDesc[@type='main']`

Pour les références bibliographiques: `bibl[@type='ms']/msIdentifier` + `settlement, repository et idno`

NB. les @type="bibilissima" sont déportés en commentaire


# TODO
* `div/@xml:id`: un peu le bazar, notamment pour les traductions…
* `title/title`
* revoir les `tei:note` pour les imprimés (inline)
* `lb`
* les `div[@type="edition"]`: sont divisées en sections typées (prologue, épilogue, etc.) => problème quand nous n’avons qu’une seule sous-division… Voir sir le @type édition est utile ; doit-on garder @type="edition" ET @subtype="prologue|epilogue|etc." ?
* diag de la structure de `//div[@type="edition"]`: les sous-divisions sont-elles systématiquement typées (prologue, épilogue, etc.): peiut-on extraire les seuls prologues par ex. ? Faire petit CR pour FD
* diag sur les `@corresp`: idée: permet de lier une division ou une référence courte à un ms à sa notice plus détaillée => voir si on garde (compter) / comment on normalise.
* voir le sort des collections privées: compter les cas et faire une proposition d’identification (@xml:id) de ces manuscrits.
* **XSLT: prévoir une vue de travail/contrôle des `msDesc`**
* revoir la logique de présentation des ms in `stratagemata_frontinus.xml` : des lisBibl ou des div ?

# DONE
* valider la structure des textes (TOC)
  * `//div[not(head)]`
  * `//div[count(div)=1]`
* `div/@corresp` : pourquoi ? non exploité dans les XSLT…
* normalisation des titres "collections privées" (et non plus particulières)
* suppression des `@corresp` sur `persName`

# Schéma – choix à revoir / valider
* faut-il prévoir des alignements textuels ?
* autoriser `//msContents/msItem/msItem`?
  * combien d’occurrences ?
  * a-t-on besoin de construire la table des `msItem` ? cf:
    * ab_urbe_condita_cxlii_titus-livius.xml
    * comediae_terentius.xml
    * de_bello_gallico_julius_caesar.xml
    * de_consolatione_philosophiae_boethius.xml
    * epitoma_rei_militaris_vegetius.xml
    * factorum_dictorum_memorabilium_libri_ix_valerius_maximus.xml
    * historia_alexandri_magni_quintus_curtius.xml
    * stratagemata_frontinus.xml

# XSLT
* `tei:decoDesc`

# IIIF
Les cotes des ms BnF: `//msIdentifier[contains(repository, 'Fr')]/concat(settlement, ' ', repository, ' ', idno)`

# Memo sur l’encodage initial

## `div/@corresp` (Diag pour FD 2017-11-29)
* 2 occs in de de_bello_gallico_julius_caesar : renvoi à 2 bibl  
* 1 occ in ab_urbe_condita_cxlii_titus : idem
  * DONE –  les liens se font en fait de notice à notice (bibl) -> voir si on crée un lien sur le bibl
* 20 //@corresp dans les latins
  * 1 msIdentifier/@corresp : renvoi à une notice  
    Pourquoi conserver un unique renvoi ?  
    Question : quelle est la logique d’affichage d’une notice complète : pourquoi à tel endroit plutôt qu’à tel autre ?
  * 2 `msDesc` => sur msIdentifier OU ms Desc – logique ?
  * 14 persName/@corresp : mais sans `#`… Une clé pour le tri ?  
    Dresser la liste des entités personnes pour avoir ne référentiel commun à l’édition (et pas seulement au fichier) -> déporter les définitions dans un fichier dédié.
  * 3 div

## `div/@xml:id` (Diag pour FD 2017-11-29)
* 78 div avec `xml:id` (NB. QUE SUR des @type traduction, soustraduction)
* in presque tous les fichiers
* motif d’identifiant non normalisé ("version longue" "perdue", etc.)  
  DEVRAIT ÊTRE LA RÉFÉRENCE DU MANUSCRIT ? (CF ars_minor_aelius_donatus.xml)
* OBJECTIF ?
-> ne sert à rien en l’état : voir si on pose @resp pour identifier les présentations des traductions d’auteurs identifiés.

## collection “privée" et collection "particulière"
* 8 mentions en `head` pour les 2 termes
* Pourquoi les 2 termes ? on assimile ?
* problème du modèle du msIdentifier – vraiment utile ?
* revoir la liste avec FD.

-> on passe tout en collection privée  
-> essayer de poser un xml:id sur toutes les notices (détaillées) de manuscrits (pouvoir dresser la liste des manuscrits présentés)  
-> voir comment on procède pour les manuscrits des collections privées (comment poser un @xml:id ? ; FD: choix de spécifier "collection privée" en `repository`)  
-> faire un petit point sur la liste des ms : `distinct-values(//msDesc/@xml:id)`

## `//div[@type="edition"]`
* 19 `//div[not(@type)]` : peut-être les valider avec FD
* 11 `div[@type="edition"]`
* 17 sous-divisions typées :
  * 1 avertissement
  * 2 dedicace
  * 1 dedicace prologue
  * 2 epilogue
  * 1 explicit
  * 1 premier_chapitre
  * 1 privilege
  * 8 prologue (au final la seule clé de regroupement qui semble utile)
* 5 div (`//div[@type='edition'][not(descendant::div)]`) sans sous-division (dont 1 prologue…)
* 1 unique sous-division non typées (`//div[@type='edition']//div[not(@type)]`)

## trancher `//msContents/msItem/msItem`
On autorise ? Pourquoi ?
* 98 `//msItem/msItem` pour 406 `msItem`…

## TODO
* extraire les `persName` avec le type pour construire un index commun déporté ET voir le lien avec le référentiel Biblissima, au moins pour les possesseurs.
* virer les @corresp
* contruire dans un fichier déporté la liste des persName => construire les liens
* revenir à la question des div[@type] => à quoi ça sert ? faire le diag dans les XSLT
* FD tient à `msItem/msItem…`
  * reprendre le schéma TEI de manière à rendre possible l’identification (`title` doit permettre d’identifier l’item)
  * voir le mapping EAD => ead permet-il l’imbrication des item ? le schéma doit favoriser l’export EAD

# Classiques latins

| cote Paris Bibl. nat. de Fr. | classiques latins occs | url Gallica |
|------------------------------|------------------------|-------------|
| fr. 881 | 4 | http://gallica.bnf.fr/ark:/12148/btv1b8449041w |
| fr. 821 | 4 | http://gallica.bnf.fr/ark:/12148/btv1b9007157m |
| fr. 282 | 4 |  |
| nouv. acq. fr. 1982 | 3 |  |
| fr. 728 | 3 |  |
| fr. 576 | 3 |  |
| fr. 38 | 3 |  |
| fr. 280 | 3 |  |
| fr. 25418 | 3 |  |
| fr. 24257 | 3 |  |
| fr. 2118 | 3 |  |
| fr. 1641 | 3 |  |
| fr. 1543 | 3 |  |
| fr. 12459 | 3 |  |
| fr. 1234 | 3 |  |
| nouv. acq. fr. 4804 | 2 |  |
| nouv. acq. fr. 4690 | 2 |  |
| nouv. acq. fr. 4531 | 2 |  |
| nouv. acq. fr. 1120 | 2 |  |
| lat. 14095 | 2 |  |
| fr. 926 | 2 |  |
| fr. 874 | 2 |  |
| fr. 287 | 2 |  |
| fr. 264-266 | 2 |  |
| fr. 263 | 2 |  |
| fr. 24307 | 2 |  |
| fr. 2327 | 2 |  |
| fr. 22547 | 2 |  |
| fr. 2125 | 2 |  |
| fr. 19138 | 2 |  |
| fr. 1604 | 2 |  |
| fr. 1593 | 2 |  |
| fr. 1563 | 2 |  |
| fr. 1235 | 2 |  |
| fr. 1233 | 2 |  |
| fr. 12239 | 2 |  |
| fr. 12238 | 2 |  |
| fr. 1097 | 2 |  |
| fr. 1096 | 2 |  |
| fr 12478 | 2 |  |
| Paris bibl. de l’Institut de France 264 | 1 |  |
| nouv. acq. lat. 2381 | 1 |  |
| nouv. acq. fr. 6535 | 1 |  |
| nouv. acq. fr. 6367 | 1 |  |
| nouv. acq. fr. 5094 | 1 |  |
| nouv. acq. fr. 27401 | 1 |  |
| nouv. acq. fr. 21471 | 1 |  |
| nouv. acq. fr. 20233 (ancien Phillipps 4355) | 1 |  |
| nouv. acq. fr. 20001 | 1 |  |
| nouv. acq. fr. 15987 | 1 |  |
| nouv. acq. fr. 11675 | 1 |  |
| nouv. acq. fr. 11198, f. 42 | 1 |  |
| lat. 6643 | 1 |  |
| lat. 18424 | 1 |  |
| fr. 9749 | 1 |  |
| fr. 9738 | 1 |  |
| fr. 9186 | 1 |  |
| fr. 876-877 | 1 |  |
| fr. 875 | 1 |  |
| fr. 873 | 1 |  |
| fr. 822 | 1 |  |
| fr. 813 | 1 |  |
| fr. 812 | 1 |  |
| fr. 809 | 1 |  |
| fr. 738 | 1 |  |
| fr. 737 | 1 |  |
| fr. 727 | 1 |  |
| fr. 720-721 | 1 |  |
| fr. 716-719 | 1 |  |
| fr. 708-711 | 1 |  |
| fr. 681-683 | 1 |  |
| fr. 6445 | 1 |  |
| fr. 6441 | 1 |  |
| fr. 6440 | 1 |  |
| fr. 6185 | 1 |  |
| fr. 578 | 1 |  |
| fr. 577 | 1 |  |
| fr. 575 | 1 |  |
| fr. 55-57 | 1 |  |
| fr. 54 | 1 |  |
| fr. 53 | 1 |  |
| fr. 47-49 | 1 |  |
| fr. 45-46 | 1 |  |
| fr. 44 | 1 |  |
| fr. 42-43 | 1 |  |
| fr. 41 | 1 |  |
| fr. 36-37 | 1 |  |
| fr. 35 | 1 |  |
| fr. 34 | 1 |  |
| fr. 33 | 1 |  |
| fr. 31-32 | 1 |  |
| fr. 302 | 1 |  |
| fr. 301 | 1 |  |
| fr. 30 | 1 |  |
| fr. 296-299 | 1 |  |
| fr. 292 | 1 |  |
| fr. 291 | 1 |  |
| fr. 290 | 1 |  |
| fr. 288-289 | 1 |  |
| fr. 286 | 1 |  |
| fr. 283-285 | 1 |  |
| fr. 277-278 | 1 |  |
| fr. 276 | 1 |  |
| fr. 275 | 1 |  |
| fr. 273-274 | 1 |  |
| fr. 269-272 | 1 |  |
| fr. 268 | 1 |  |
| fr. 267 | 1 |  |
| fr. 260-262 | 1 |  |
| fr. 259 | 1 |  |
| fr. 258 | 1 |  |
| fr. 257 | 1 |  |
| fr. 25545 | 1 |  |
| fr. 25417 | 1 |  |
| fr. 25416 | 1 |  |
| fr. 254 | 1 |  |
| fr. 25397 | 1 |  |
| fr. 24396 | 1 |  |
| fr. 24309 | 1 |  |
| fr. 24308 | 1 |  |
| fr. 24231 | 1 |  |
| fr. 24230 | 1 |  |
| fr. 23090-91 | 1 |  |
| fr. 22554 | 1 |  |
| fr. 2063 | 1 |  |
| fr. 20320 | 1 |  |
| fr. 20319 | 1 |  |
| fr. 20318 | 1 |  |
| fr. 20316 | 1 |  |
| fr. 20315 | 1 |  |
| fr. 20313-20314 | 1 |  |
| fr. 20312 ter | 1 |  |
| fr. 20311 | 1 |  |
| fr. 20071-20072 | 1 |  |
| fr. 20018 | 1 |  |
| fr. 1949 | 1 |  |
| fr. 1948 | 1 |  |
| fr. 1947 | 1 |  |
| fr. 1946 | 1 |  |
| fr. 19152 | 1 |  |
| fr. 19137 | 1 |  |
| fr. 19104 | 1 |  |
| fr. 1728 | 1 |  |
| fr. 17272 | 1 |  |
| fr. 17080 | 1 |  |
| fr. 1652 | 1 |  |
| fr. 1651 | 1 |  |
| fr. 15471 | 1 |  |
| fr. 15470 | 1 |  |
| fr. 15469 | 1 |  |
| fr. 15455 | 1 |  |
| fr. 1542 | 1 |  |
| fr. 1541 | 1 |  |
| fr. 1540 | 1 |  |
| fr. 1392 | 1 |  |
| fr. 12787 | 1 |  |
| fr. 12478 | 1 |  |
| fr. 12360 | 1 |  |
| fr. 1232 | 1 |  |
| fr. 1231 | 1 |  |
| fr. 1230 | 1 |  |
| fr. 1229 | 1 |  |
| fr. 12240 | 1 |  |
| fr. 12237 | 1 |  |
| fr. 1102 | 1 |  |
| fr. 1100-1101 | 1 |  |
| fr. 1099 | 1 |  |
| fr. 1098 | 1 |  |
| fr. 1095 | 1 |  |
| fr. 1094 | 1 |  |
| fr. 1093 | 1 |  |
| fr. 1092 | 1 |  |
| fr 19152 | 1 |  |
| Rés. 4° Lb28. 15α | 1 |  |
| Rothschild IV.2.67 (2753) | 1 |  |

## Manuscrits juridiques
| cote Paris Bibl. nat. de Fr. | ms juridiques occs | url Gallica |
|------------------------------|--------------------|-------------|
| fr. 498 | 3 |  |
| fr. 22970 | 3 |  |
| nouv. acq. fr. 10046 | 2 |  |
| fr. 497 | 2 |  |
| fr. 496 | 2 |  |
| fr. 495 | 2 |  |
| fr. 25546 | 2 |  |
| fr. 20121 | 2 |  |
| fr. 20120 | 2 |  |
| fr. 20119 | 2 |  |
| fr. 20118 | 2 |  |
| fr. 200 | 2 |  |
| fr. 198 | 2 |  |
| fr. 1934 | 2 |  |
| fr. 1933 | 2 |  |
| fr. 1928 | 2 |  |
| fr. 1075 | 2 |  |
| fr. 1074 | 2 |  |
| fr. 1073 | 2 |  |
| fr. 1070 | 2 |  |
| fr. 1069 | 2 |  |
| fr. 1065 | 2 |  |
| fr. 1064 | 2 |  |
| fr. 1063 | 2 |  |
| nouv. acq. fr. 4504 | 1 |  |
| nouv. acq. fr. 4138 | 1 |  |
| fr. 5245 | 1 |  |
| fr. 2844 | 1 |  |
| fr. 2426 | 1 |  |
| fr. 22969 | 1 |  |
| fr. 197 | 1 |  |
| fr. 1932 | 1 |  |
| Rés. F. 35 | 1 |  |

# Les manuscrits juridiques
Objectif: déterminer le nombre de traduction pour chaque texte jurdique.  
Déterminer les relations entre traductions et décrire les manuscrits de chaque traduction.  
Critique textuelle : définir les relations textuelles entre manuscrits (tradition) -> des transcriptions assez longues. Certains "titres" sont transcrits intégralement, leur variante également.

Un fichier par texte.
