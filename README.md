# Miroir

Sources XML-TEI de l’application Miroir des classiques (F. Duval)


## Publication DTS des sources, mode d’emploi

### 1. Capitainisation

La publication DTS repose sur la librairie [CapiTains](https://github.com/Capitains). Pour déployer les fichiers conformément aux [Guidelines CapiTains](https://github.com/Capitains/guidelines), utiliser le [Capitainizer](https://github.com/chartes/capitainizer).

NB. Pour ce projet, toutes les métadonnées sont inscrites dans les `teiHeader` (à l’exception des titres des collections) :

```
cd capitainizer
python capitainizer.py path/to/miroir/xml path/to/data/dts/data/miroir templates/__capitains_collection_miroir.xml 
```

NB. Penser à corriger manuellement les titres des collections (TODO CF : fichier de configuration pour gérer ces titres imprimés de collections).


### 2. Installation flask-dts

Structure de fichiers proposée pour ce qui suit.

```
srv/
	data/dts/data/miroir/
	transform/
	webapp/
		capitains/
			flask_app.py
			MyCapytain/
			Nautilus/
			requirements.txt
```


#### 2.1. DTS Resolver (MyCapytain)

[MyCapytain](https://github.com/chartes/MyCapytain/tree/EndpointDocumentDTSPleinText) (branche `EndpointDocumentDTSPleinText`)

```
git clone https://github.com/chartes/MyCapytain.git
cd MyCapytain
git checkout EndpointDocumentDTSPleinText
```

#### 2.2. API DTS (Nautilus)

Les fichiers sont servis par [Nautilus](https://github.com/chartes/Nautilus/tree/dtsdownload) (branche `dtsdownload`), extension Flask de MyCapitain.

```
git clone https://github.com/chartes/Nautilus.git
cd Nautilus
git checkout dtsdownload 
```

#### 2.3. Configuration (flask-app.py)

Renseigner le fichier de configuration (gestion cache, appel transformation HTML, etc.) : `srv/webapp/capitains/flask_app.py`


```
cd capitains
python3.8 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python flask_app.py
```

#### 2.4. Tester

```
http://0.0.0.0:5050/dts/collections?id=miroir
```



