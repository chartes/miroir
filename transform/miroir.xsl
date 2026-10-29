<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform   version="1.1"   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:rng="http://relaxng.org/ns/structure/1.0"
  xmlns:eg="http://www.tei-c.org/ns/Examples"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:dts="https://w3id.org/dts/api#"
  xmlns:epub="http://www.idpf.org/2007/ops"
  xmlns:tf="urn:elec:tableau-filtrable"
  exclude-result-prefixes="eg html rng tei epub dts tf"
  xmlns:exslt="http://exslt.org/common"
  extension-element-prefixes="exslt"
  >
  <!-- xml view source -->
  <xsl:import href="../../renderers/hteiml/xsl/tei2html.xsl"/>
  <xsl:import href="bibliographie.xsl"/>
  <xsl:import href="tableau-filtrable.xsl"/>
  <!-- on garde les CSS par défaut -->
 
  <xsl:strip-space elements="tei:app tei:lem tei:rdg tei:rdgList tei:choice tei:sic tei:corr tei:abbr tei:expan tei:subst"/>

  <xsl:variable name="idResource">eneide_B</xsl:variable>
  <xsl:variable name="person">idx_persons</xsl:variable>
  <xsl:variable name="place">idx_places</xsl:variable>
  <!-- Reprise des templates historiques de Miroir -->

  <xsl:template match="tei:msDesc">
    <div>
      <xsl:call-template name="atts"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:publicationStmt">
  </xsl:template>
  
  <xsl:template match="tei:sponsor">
  </xsl:template>
  
  <xsl:template match="tei:sourceDesc">
  </xsl:template>
  
  <xsl:template match="tei:editionStmt">
  </xsl:template>
  
  <xsl:template match="//tei:lb">
    <br></br>
  </xsl:template>
  
  <xsl:template match="tei:history">
    <div>
      <xsl:call-template name="atts"/>
       <h4>Histoire du manuscrit : </h4>
      <xsl:apply-templates></xsl:apply-templates>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:cb" name="cb">
    
    <xsl:if test="@n and @n != ''">
      <i class="cb"> (f. <xsl:value-of select="@n"/>) </i>
    </xsl:if>
 
  </xsl:template>
  
  <xsl:template match="tei:history/tei:origin">
    <div>
      <xsl:call-template name="atts"/>
      <p>Origine du manuscrit :       <xsl:apply-templates></xsl:apply-templates></p>
    </div>
  </xsl:template>

  <xsl:template match="tei:msDesc/tei:msIdentifier">
    <xsl:if test="./tei:settlement/text()!= '' or ./tei:msName/text()!= ''">
      <h3>
        <xsl:call-template name="atts"/>
        <xsl:if test="./tei:settlement/text()!= ''"><xsl:copy-of select="./tei:settlement/text()"/><xsl:text>, </xsl:text><xsl:copy-of select="./tei:repository/text()"/><xsl:text>, </xsl:text><xsl:copy-of select="./tei:idno/text()"/></xsl:if><xsl:if test="./tei:msName/text()!= ''"><xsl:text> (</xsl:text><xsl:value-of select="./tei:msName/text()"/><xsl:if test="./tei:msName/@resp"><xsl:text> dans </xsl:text><xsl:value-of select="./tei:msName/@resp"/></xsl:if><xsl:text>)</xsl:text></xsl:if> 
        <!-- 
        <xsl:for-each select="./child::node()">
          <xsl:apply-templates></xsl:apply-templates>
          <xsl:text> </xsl:text>
        </xsl:for-each>
        -->
      </h3>
    </xsl:if>
  </xsl:template> 
  
  <xsl:template match="tei:listBibl/tei:msDesc">
    <div>
      <xsl:call-template name="atts"/>
      <xsl:apply-templates></xsl:apply-templates>
      <hr/>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:listBibl">
    <xsl:if test="not(./tei:head)">
      <xsl:choose>
        <xsl:when test="./tei:msDesc">
          <xsl:apply-templates></xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <div>
            <xsl:call-template name="atts"/>
            <h4>Bibliographie : </h4>
            <xsl:apply-imports/>
          </div>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:additional/tei:adminInfo//tei:source">
    <div>
      <span>Nota Bene : <xsl:apply-templates></xsl:apply-templates></span>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:msDesc/tei:msContents[not(child::tei:msItem)]">
    <div>
      <xsl:call-template name="atts"/>
      <h4>Contenu du manuscrit : </h4>
      <xsl:apply-templates></xsl:apply-templates>
    </div>
  </xsl:template>
  
  <!-- Créer une regle pour le head tradition direct et tradition indirect pour avoir un même affichage que manuscrit -->
  <!-- Vérifier que l'élément label soit un inline -->
  
  <xsl:template match="tei:msPart/tei:msContents">
    <div>
      <xsl:call-template name="atts"/>
      <h4>Contenu du manuscrit : </h4>
      <xsl:apply-templates></xsl:apply-templates>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:msPart/tei:msIdentifier">
    <div>
      <xsl:call-template name="atts"/>
      <h3>
      <span>Partie : </span>
      <xsl:apply-templates></xsl:apply-templates>
      </h3>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:physDesc/tei:objectDesc">
    <div>
      <h4>Description matérielle :</h4>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:physDesc/tei:handDesc">
    <div>
      <h4>Scription :</h4>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:decoDesc">
    <div>
      <h4>Structure et décors :</h4>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:handDesc">
    <div>
      <h4>Description physique du recueil :</h4>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  
  
 
  <xsl:template match="tei:div[@type='incipit']">
    <div>
      <xsl:call-template name="atts"/>
      <!-- Tester dans César Paris Bibl. nat. de Fr. fr. 280 quand il y a plusieurs p pour ajouter l'espace entre chaque p, Ajouter un saut de ligne avant le msDesc/tei:msIdentifier-->
      <h4>
        <xsl:attribute name="class">incipit</xsl:attribute>
        <xsl:copy-of select="./tei:head/text()"/><xsl:text> </xsl:text>
        <xsl:if test="./tei:p">
          <xsl:copy-of select="./tei:p/text()"/><xsl:text> </xsl:text>
        </xsl:if>
        <p>
          <xsl:if test="./tei:msDesc/tei:msIdentifier/tei:settlement/text()"><xsl:copy-of select="./tei:msDesc/tei:msIdentifier/tei:settlement/text()"/><xsl:text>, </xsl:text></xsl:if>
          <xsl:if test="./tei:msDesc/tei:msIdentifier/tei:repository/text()"><xsl:copy-of select="./tei:msDesc/tei:msIdentifier/tei:repository/text()"/><xsl:text>, </xsl:text></xsl:if>
          <xsl:copy-of select="./tei:msDesc/tei:msIdentifier/tei:idno/text()"/>
        </p></h4>
      <xsl:if test="./tei:bibl"><xsl:apply-templates select="tei:bibl"/></xsl:if>
      <table>
        <thead>
          <tr>
            <th><xsl:attribute name="class">locus</xsl:attribute>Locus</th>
            <th><xsl:attribute name="class">incipit</xsl:attribute>Incipit</th>
            <th><xsl:attribute name="class">explicit</xsl:attribute>Explicit</th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select=".//tei:msItem">
          <tr>
            <xsl:call-template name="atts"/>
            <td><cite><xsl:attribute name="class">title</xsl:attribute><xsl:copy-of select="./tei:title/text()"/></cite><br></br><span><xsl:attribute name="class">locus</xsl:attribute><xsl:copy-of select="./tei:locus/text()"/></span></td>
            <td><xsl:copy-of select="./tei:incipit/text()"/></td>
            <td><xsl:copy-of select="./tei:explicit/text()"/></td>
          </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:div[not(@type='incipit')]//tei:msItem[@xml:id]">
    <div>
      <xsl:call-template name="atts"/>
       <xsl:for-each select=".//tei:msItem[@xml:id]">
        <p><h5><xsl:attribute name="class">titleMsPart</xsl:attribute><xsl:copy-of select="./tei:title/text()"/><xsl:text> : </xsl:text></h5><br></br>
          <p><span  style="font-weight:bold">Incipit :</span> <xsl:copy-of select="./tei:incipit/text()"/></p>
          <p><span  style="font-weight:bold">Explicit :</span> <xsl:copy-of select="./tei:explicit/text()"/></p>
        </p>
        <table>
          <thead>
            <tr>
              <th><xsl:attribute name="class">locus</xsl:attribute>Locus</th>
              <th><xsl:attribute name="class">incipit</xsl:attribute>Incipit</th>
            </tr>
          </thead>
          <tbody>
            <xsl:for-each select=".//tei:msItem[not(@xml:id)]">
              <tr>
                <xsl:call-template name="atts"/>
                <td><cite><xsl:attribute name="class">title</xsl:attribute><xsl:copy-of select="./tei:title/node()"/></cite><br></br><span><xsl:attribute name="class">locus</xsl:attribute><xsl:copy-of select="./tei:locus/node()"/></span></td>
                <td><xsl:if test="./tei:explicit"><xsl:text>Incipit: </xsl:text></xsl:if><xsl:copy-of select="./tei:incipit/node()"/>
                  <xsl:if test="./tei:explicit"><br></br><xsl:text>Explicit: </xsl:text><xsl:copy-of select="./tei:explicit/node()"/>
                 </xsl:if></td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
      </xsl:for-each>
    </div>
  </xsl:template>
  
  <xsl:template match="//tei:div[contains(@type, 'edition') or contains(@type, 'dedicace')]">
    <div>
      <xsl:call-template name="atts"/>
      <xsl:choose>
        <xsl:when test="./tei:msDesc">
        <h4><xsl:attribute name="class">edition</xsl:attribute><xsl:copy-of select="./tei:head/text()"/><xsl:text> </xsl:text><xsl:if test="./tei:p"><xsl:copy-of select="./tei:p/text()"/><xsl:text>, </xsl:text></xsl:if><xsl:value-of select="./tei:msDesc/tei:msIdentifier/tei:settlement/text()"/><xsl:text>, </xsl:text><xsl:copy-of select="./tei:msDesc/tei:msIdentifier/tei:repository/text()"/><xsl:text>, </xsl:text><xsl:copy-of select="./tei:msDesc/tei:msIdentifier/tei:idno/text()"/></h4>
          <xsl:apply-templates select=".//tei:msContents"></xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates></xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </div>  
  </xsl:template>
  
  <xsl:template match="//tei:div[contains(@type, 'edition')]">
    <div>
      <xsl:call-template name="atts"/>
      <xsl:choose>
        <xsl:when test="./tei:msDesc">
          <h4><xsl:attribute name="class">edition</xsl:attribute><xsl:copy-of select="./tei:head/text()"/><xsl:text> </xsl:text><xsl:if test="./tei:p"><xsl:copy-of select="./tei:p/text()"/><xsl:text> </xsl:text></xsl:if><xsl:copy-of select="./tei:msDesc/tei:msIdentifier/tei:settlement/text()"/><xsl:text> </xsl:text><xsl:copy-of select="./tei:msDesc/tei:msIdentifier/tei:repository/text()"/><xsl:text> </xsl:text><xsl:copy-of select="./tei:msDesc/tei:msIdentifier/tei:idno/text()"/></h4>
          <xsl:apply-templates select=".//tei:msContents"></xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates></xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </div>  
  </xsl:template>
  
  <xsl:template match="tei:div[@type='traduction']/tei:dateline">
    <div>
      <xsl:call-template name="atts"/>
      <span>Date du texte : </span>
      <xsl:apply-templates></xsl:apply-templates>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:div[@type='soustraduction']/tei:dateline">
    <div>
      <xsl:call-template name="atts"/>
      <span>Date du texte </span>
      <xsl:apply-templates></xsl:apply-templates>
    </div>
  </xsl:template>
  
  
  <xsl:template match="tei:msContents">
    <div>
      <xsl:call-template name="atts"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:msItem">
    <div>
      <xsl:call-template name="atts"/>
      <xsl:apply-templates/>
      <hr/><!-- vue de travail ; améliorer le rendu HTML5 -->
    </div>
  </xsl:template>
  
  <xsl:template match="tei:msName">
    <span>
      <xsl:apply-templates/>
      <!-- vue de travail ; améliorer le rendu HTML5 -->
    </span>
  </xsl:template>
  
  <xsl:template match="tei:incipit|tei:explicit">
    <p>
      <xsl:call-template name="atts"/>
      <b><xsl:value-of select="name(.)"/> : </b>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="tei:decoNote">
      <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="tei:lang">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="tei:summary">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="tei:material">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="tei:rdgGrp">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="tei:graphic">
    <xsl:variable name="id">
      <xsl:call-template name="id"/>
    </xsl:variable>
    <a id="{$id}" href="#{$id}">
      <img src="https://raw.githubusercontent.com/chartes/miroir/master/xml/manuscrits_juridiques/{@url}" alt="{normalize-space(.)}">
        <xsl:if test="@rend">
          <xsl:attribute name="align">
            <xsl:copy-of select="@rend"/>
          </xsl:attribute>
        </xsl:if>
      </img>
    </a>
  </xsl:template>
  
<!-- Surcharges ajoutées lors de la migration DoTS -->
  <xsl:template match="dts:wrapper">
    <xsl:apply-imports/>
    <xsl:call-template name="footnotes">
      <xsl:with-param name="cont" select="."/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="tei:lg">
    <xsl:variable name="corresp">
      <xsl:choose>
        <xsl:when test="contains(@corresp, '-')">
          <xsl:value-of select="concat('vers latin ', substring-before(@corresp, '-'), ' à ', substring-after(@corresp, '-'))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('vers latin ', @corresp)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <div>
      <xsl:call-template name="atts"/>
      <xsl:call-template name="breaks"/>
      <small class="lg-n">
        <xsl:value-of select="$corresp"/>
      </small>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template name="footnotes">
    <xsl:param name="cont" select="*"/>
    <xsl:param name="pb" select="$cont//tei:pb[@n][not(@ed)]"/>
    <xsl:variable name="notes">
      <xsl:if test="$app">
        <xsl:variable name="apparatus">
          <xsl:for-each select="$cont//tei:app">
            <xsl:choose>
              <xsl:when test="tei:lem/tei:l">
                <xsl:call-template name="note-app-bloc"/>
              </xsl:when>
              <xsl:when test="not(tei:lem)">
                <xsl:call-template name="app-no-lem"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="note-inline"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:variable>
        <xsl:if test="$apparatus != ''">
          <p class="apparatus">
            <xsl:copy-of select="$apparatus"/>
          </p>
        </xsl:if>
      </xsl:if>
      <xsl:choose>
        <xsl:when test=" $pb">
          <!-- MODIF : filtre sur les notes avant le premier pb -->
          <xsl:variable name="notes1"
            select="key('note-pb', '')[not(@place='inline' or ancestor::tei:bibl or parent::tei:choice or ancestor::tei:app)]"/>
          <xsl:if test="$notes1">
            <div class="page">
              <xsl:for-each select="$notes1[@resp = 'author'][not(@place = 'margin')]">
                <xsl:call-template name="note"/>
              </xsl:for-each>
              <xsl:for-each select="$notes1[@resp = 'editor'][not(@place = 'margin')]">
                <xsl:call-template name="note"/>
              </xsl:for-each>
              <xsl:for-each select="$notes1[not(@resp) or (@resp != 'editor' and @resp != 'author')][not(@place = 'margin')]">
                <xsl:call-template name="note"/>
              </xsl:for-each>
            </div>
          </xsl:if>
          <xsl:for-each select="$pb">
            <!-- MODIF 3 : filtre sur les notes de chaque page -->
            <xsl:variable name="pbnotes"
              select="key('note-pb', generate-id())[not(@place='inline' or ancestor::tei:bibl or parent::tei:choice or ancestor::tei:app)]"/>
            <xsl:variable name="notes4page">
              <xsl:for-each select="$pbnotes[@resp = 'author'][not(@place = 'margin')]">
                <xsl:call-template name="note"/>
              </xsl:for-each>
              <xsl:for-each select="$pbnotes[@resp = 'editor'][not(@place = 'margin')]">
                <xsl:call-template name="note"/>
              </xsl:for-each>
              <xsl:for-each select="$pbnotes[not(@resp) or (@resp != 'editor' and @resp != 'author')][not(@place = 'margin')]">
                <xsl:call-template name="note"/>
              </xsl:for-each>
            </xsl:variable>
            <xsl:if test="$notes4page != ''">
              <div class="page">
                <div class="b note-page">
                  <xsl:call-template name="a"/>
                </div>
                <xsl:copy-of select="$notes4page"/>
              </div>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="$cont and function-available('exslt:node-set')">
          <xsl:apply-templates select="exslt:node-set($cont)" mode="fn">
            <xsl:with-param name="resp">author</xsl:with-param>
          </xsl:apply-templates>
          <xsl:apply-templates select="exslt:node-set($cont)" mode="fn">
            <xsl:with-param name="resp">editor</xsl:with-param>
          </xsl:apply-templates>
          <xsl:apply-templates select="exslt:node-set($cont)" mode="fn"/>
        </xsl:when>
        <xsl:when test="$cont">
          <!-- MODIF 4 : filtre sur la branche « peu efficace » -->
          <xsl:for-each select="$cont //tei:note[not(parent::tei:choice or ancestor::tei:app)]">
            <xsl:sort select="@place|@resp"/>
            <xsl:call-template name="fn"/>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="key('id', 'note-footseq')">
          <xsl:apply-templates select="*" mode="fn"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="*" mode="fn">
            <xsl:with-param name="resp">author</xsl:with-param>
          </xsl:apply-templates>
          <xsl:apply-templates select="*" mode="fn">
            <xsl:with-param name="resp">editor</xsl:with-param>
          </xsl:apply-templates>
          <xsl:apply-templates select="*" mode="fn"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$notes != ''">
      <xsl:variable name="el">
        <xsl:choose>
          <xsl:when test="$format=$epub2">div</xsl:when>
          <xsl:otherwise>section</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:element name="{$el}" namespace="http://www.w3.org/1999/xhtml">
        <xsl:attribute name="class">footnotes</xsl:attribute>
        <xsl:if test="$format = $epub3">
          <xsl:attribute name="epub:type">footnotes</xsl:attribute>
        </xsl:if>
        <xsl:copy-of select="$notes"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:note[contains(@place,'inline')]"
    mode="fn" priority="10"/>
  
  <!-- Glossaire : une suite d'entry voisines devient un tableau triable et filtrable -->
  
  <xsl:template match="tei:div[@type='entries']">
    <xsl:variable name="entrees" select="tei:entry"/>
    <xsl:variable name="liste-cat" select="'tf-cat-' || generate-id()"/>
    <div class="tf-cadre">
      <xsl:call-template name="tf-barre">
        <xsl:with-param name="total" select="count(tei:entry)"/>
        <xsl:with-param name="unite" select="'entrées'"/>
      </xsl:call-template>
      <table class="tf-tableau" data-csv-nom="glossaire" data-csv-entetes="Forme|Définition">
        <caption class="tf-legende">Cliquer sur un en-tête de colonne pour trier (un second clic inverse l’ordre).</caption>
        <thead>
          <tr>
            <xsl:call-template name="tf-th">
            <xsl:with-param name="classe" select="'tf-form'"/>
            <xsl:with-param name="libelle" select="'Forme'"/>
          </xsl:call-template>
          <xsl:call-template name="tf-th">
            <xsl:with-param name="classe" select="'tf-cat'"/>
            <xsl:with-param name="libelle" select="'Catégorie'"/>
          </xsl:call-template>
          <xsl:call-template name="tf-th">
            <xsl:with-param name="classe" select="'tf-def'"/>
            <xsl:with-param name="libelle" select="'Définition'"/>
          </xsl:call-template>
          </tr>
          <tr class="tf-filtres">
            <xsl:call-template name="tf-filtre">
              <xsl:with-param name="col" select="0"/>
              <xsl:with-param name="libelle" select="'Forme'"/>
            </xsl:call-template>
            <xsl:call-template name="tf-filtre">
              <xsl:with-param name="col" select="1"/>
              <xsl:with-param name="libelle" select="'Catégorie'"/>
              <xsl:with-param name="type" select="'liste'"/>
              <xsl:with-param name="options"
                select="sort(distinct-values(tei:entry/tei:gramGrp/tei:pos ! replace(normalize-space(.), '\.(\p{L})', '. $1')))"/>
              <xsl:with-param name="liste" select="$liste-cat"/>
            </xsl:call-template>
            <xsl:call-template name="tf-filtre">
              <xsl:with-param name="col" select="2"/>
              <xsl:with-param name="libelle" select="'Définition'"/>
            </xsl:call-template>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="$entrees">
            <!-- tri et filtre sur la forme sans le # ou le @ initial -->
            <xsl:variable name="cle-forme"
              select="tf:plat(replace(string((tei:form)[1]), '^\s*[#@]\s*', ''))"/>
            <!-- s.m. et s.f. sont ramenés à s. m. et s. f. -->
            <xsl:variable name="cat"
              select="replace(normalize-space(string-join(tei:gramGrp/tei:pos, ' ')), '\.(\p{L})', '. $1')"/>
            <xsl:variable name="cle-def" select="tf:plat(string(tei:def))"/>
            <tr data-o="{position()}" class="mf-ligne">
              <xsl:if test="@xml:id"><xsl:attribute name="id" select="@xml:id"/></xsl:if>
              <td data-sort="{$cle-forme}" data-f="{$cle-forme}" class="mf-c-nom">
                <xsl:apply-templates select="tei:form/node()"/>
              </td>
              <td data-sort="{tf:plat($cat)}" data-f="{tf:plat($cat)}" class="mf-c-nom">
                <xsl:choose>
                  <xsl:when test="$cat != ''"><xsl:value-of select="$cat"/></xsl:when>
                  <xsl:otherwise><span class="tf-vide">–</span></xsl:otherwise>
                </xsl:choose>
              </td>
              <td data-sort="{$cle-def}" data-f="{$cle-def}" class="mf-c-nom">
                <xsl:apply-templates select="tei:def/node()"/>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </div>
  </xsl:template>
  
  <!-- Les autres entrées de la suite sont déjà dans le tableau -->
  <xsl:template match="tei:entry"/>
  
  <xsl:template match="tei:ref[ancestor::tei:list[@type='index']]">
    <xsl:variable name="livre" select="substring-before(./@target, '_')"/>
    <a href="{concat($idResource, '?refId=', substring-after($livre, '#'), @target)}"><xsl:apply-templates/></a>
  </xsl:template>
  
  <xsl:template match="tei:placeName | tei:persName">
    <xsl:choose>
      <!-- On est dans le document courant ET l'élément a un @key -->
      <xsl:when test="@key">
        <xsl:variable name="refId">
          <xsl:choose>
            <xsl:when test="self::tei:persName and not(ancestor::tei:div/@type = 'traduction') and ancestor::tei:div/starts-with(@xml:id, 'l')">
              <xsl:value-of select="$person"/>
            </xsl:when>
            <xsl:when test="self::tei:placeName and ancestor::tei:div/starts-with(@xml:id, 'l')">
              <xsl:value-of select="$place"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <a href="{concat($idResource, '?refId=', $refId, '#', @key)}">
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="tei:app[tei:lem/tei:l]" priority="2">
    <xsl:variable name="n" select="@n"/>  
    <!-- renvoi de note : même code que dans ton template tei:app actuel -->
    <xsl:for-each select="tei:lem/tei:l">
      <xsl:variable name="id" select="./@xml:id"/>
      <div xml:id="{$id}" class="l">
        <xsl:value-of select="."/>
        <xsl:if test="position() = last()">
          <a id="{$n}_" class="noteref" href="#{$n}">
            <sup><xsl:value-of select="$n"/></sup>
          </a>
        </xsl:if>
      </div>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="note-app-bloc">
    <!-- contexte : tei:app -->
    <xsl:variable name="id" select="@n"/>
    <span class="note" id="{$id}">
      <a href="#{$id}_"><xsl:value-of select="$id"/></a>
      <span class="lem">
        <xsl:for-each select="tei:lem/tei:l">
          <xsl:value-of select="."/><xsl:text> </xsl:text>
        </xsl:for-each>
      </span>
      <span class="rdg"><xsl:value-of select="./tei:rdg"/><xsl:text> </xsl:text><i class="wit"><xsl:value-of select="./tei:rdg/substring-after(@wit, '#')"/></i></span>
    </span>
  </xsl:template>
  
  <xsl:template match="tei:app[tei:lem/tei:l]" mode="app-note" priority="2">
    <xsl:apply-templates select="node()"/>
    <xsl:if test="following-sibling::tei:l"><xsl:text> / </xsl:text></xsl:if>
  </xsl:template>
  
  <xsl:template name="app-no-lem">
    <xsl:variable name="id" select="@n"/>
    <span class="note" id="app{$id}">
      <a href="#app{$id}_"><xsl:value-of select="$id"/></a>
      <span class="lem">Omis</span>
      <xsl:apply-templates select="./tei:rdg"/>
    </span>
  </xsl:template>
  
  <xsl:template match="tei:lem/tei:note | tei:app/tei:note">
    <span class="note-inline-app"> <xsl:apply-templates/> </span>
  </xsl:template>
  
</xsl:transform>
