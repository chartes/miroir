# Les manuscrits juridiques


* `lang`: biblissima -> avoir la source et la dest pour la traduction: `derivation[@type="translation"][@xml:lang][@sync]``
  * `@xml:lang`: langue cible (*target*)
  * `@sync`: langue source (*source*)
* NB: output HTML: pour `msIdentifier`ne pas sortir `country`

* revoir les espacements entre les `supplied`

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
* virer les @corresp
* revenir à la question des div[@type] => à quoi ça sert ? faire le diag dans les XSLT
* FD tient à `msItem/msItem…`
  * reprendre le schéma TEI de manière à rendre possible l’identification (`title` doit permettre d’identifier l’item)
  * voir le mapping EAD => ead permet-il l’imbrication des item ? le schéma doit favoriser l’export EAD


# Les manuscrits juridiques
Objectif: déterminer le nombre de traduction pour chaque texte jurdique.  
Déterminer les relations entre traductions et décrire les manuscrits de chaque traduction.  
Critique textuelle : définir les relations textuelles entre manuscrits (tradition) -> des transcriptions assez longues. Certains "titres" sont transcrits intégralement, leur variante également.

Un fichier par texte.

# Biblissima, 31 janvier 2019
Besoin : mettre en relation une œuvre et son auteur
Privilégier les ark BAM: https://archivesetmanuscrits.bnf.fr/ark:/12148/cc510707 pour https://gallica.bnf.fr/ark:/12148/btv1b9007157m
Idée: biblissima inscrit les identifiants des ms et on les réinscrits dans les XML/TEI
Pour les imprimés: ISTC (https://data.cerl.org/istc/_search) et USTC (https://www.ustc.ac.uk/)
Pour les ms, voir http://medium.irht.cnrs.fr/

Notice personne
* label
* birth
* death
* sexe
* une attestation
* une note
* floruit: date d’activité connue (fl.)

Institution
* label
* ville: forme française

IIIF
https://medusa-project.github.io/cantaloupe/
