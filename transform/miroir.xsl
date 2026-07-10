<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform   version="1.1"   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:rng="http://relaxng.org/ns/structure/1.0"
  xmlns:eg="http://www.tei-c.org/ns/Examples"
  xmlns:tei="http://www.tei-c.org/ns/1.0" 
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:epub="http://www.idpf.org/2007/ops"
  exclude-result-prefixes="eg html rng tei epub"
  xmlns:exslt="http://exslt.org/common"
  extension-element-prefixes="exslt"
  >
  <!-- xml view source -->
  <xsl:import href="../hteiml/tei2html.xsl"/>
  <!-- on garde les CSS par défaut -->
  <xsl:param name="theme">../../../teipub/theme/</xsl:param>
  <!-- on déclare une CSS custom (appel in tei2html.xsl) -->
  <xsl:param name="customCSS">../../miroir.css</xsl:param>
  
  <!-- des templates dédiés au catalogage -->
  <!--<xsl:template match="tei:street"/>-->
  
  <!-- PP. Cette règle permet de gérer correctement les notes qui sont dans des bibl. -->
  <xsl:template name="id" match="*" mode="id">
    <xsl:param name="prefix"/>
    <xsl:param name="suffix"/>
    <xsl:variable name="id0">, '"</xsl:variable>
    <xsl:variable name="id1">-_</xsl:variable>
    <xsl:value-of select="$prefix"/>
    <xsl:choose>
      <xsl:when test="@xml:id">
        <xsl:value-of select="translate(@xml:id, $id0, $id1)"/>
      </xsl:when>
      <xsl:when test="@id">
        <xsl:value-of select="translate(@id, $id0, $id1)"/>
      </xsl:when>
      <xsl:when test="ancestor-or-self::*:wrapper">
        <xsl:value-of select="local-name()"/>
        <xsl:if test="count(key('qname', local-name())) &gt; 1">
          <xsl:number level="any"/>
        </xsl:if>
      </xsl:when>
      <xsl:when test="not(ancestor::tei:group) and (self::tei:div or starts-with(local-name(), 'div'))">
        <!-- should I put file id as div id prefix ? -->
        <!--
        <xsl:if test="$docid != ''">
          <xsl:value-of select="translate($docid, $id0, $id1)"/>
          <xsl:text>_</xsl:text>        
        </xsl:if>
        -->
        <xsl:choose>
          <xsl:when test="ancestor::tei:body">body-</xsl:when>
          <xsl:when test="ancestor::tei:front">front-</xsl:when>
          <xsl:when test="ancestor::tei:back">back-</xsl:when>
        </xsl:choose>
        <xsl:number count="tei:div|tei:div1|tei:div2|tei:div3|tei:div4" level="multiple" format="1-1"/>
      </xsl:when>
      <!-- hiérarchie simple de div  -->
      <xsl:when test="self::tei:div and not(ancestor::tei:group)">
        <!-- should I put file id as div id prefix ? -->
        <!--
        <xsl:if test="$docid != ''">
          <xsl:value-of select="translate($docid, $id0, $id1)"/>
          <xsl:text>_</xsl:text>        
        </xsl:if>
        -->
        <xsl:number count="tei:div"  level="multiple" format="1-1"/>
      </xsl:when>
      <!-- find index -->
      <xsl:when test="/tei:TEI/tei:text and count(.|/tei:TEI/tei:text)=1">index</xsl:when>
      <xsl:when test="/tei:TEI/tei:text/tei:front and count(.|/tei:TEI/tei:text/tei:front)=1">index</xsl:when>
      <xsl:when test="not(/tei:TEI/tei:text/tei:front) and count(.|/tei:TEI/tei:text/tei:group|/tei:TEI/tei:text/tei:body)=1">index</xsl:when>
      <!-- éléments hauts -->
      <xsl:when test="count(.. | /*) = 1">
        <!-- should I put file id as div id prefix ? -->
        <!--
        <xsl:if test="$docid != ''">
          <xsl:value-of select="translate($docid, $id0, $id1)"/>
          <xsl:text>_</xsl:text>        
        </xsl:if>
        -->
        <xsl:value-of select="local-name()"/>
      </xsl:when>
      <!-- groupe de textes -->
      <xsl:when test="self::tei:group">
        <!-- should I put file id as div id prefix ? -->
        <!--
        <xsl:if test="$docid != ''">
          <xsl:value-of select="translate($docid, $id0, $id1)"/>
          <xsl:text>_</xsl:text>        
        </xsl:if>
        -->
        <xsl:value-of select="local-name()"/>
        <xsl:number level="multiple" from="/*/tei:text/tei:group" format="-1-1"/>
      </xsl:when>
      <!-- éléments uniques identifiables par leur nom -->
      <xsl:when test="contains($els-unique, concat(' ', local-name(), ' '))">
        <!-- should I put file id as div id prefix ? -->
        <!--
        <xsl:if test="$docid != ''">
          <xsl:value-of select="translate($docid, $id0, $id1)"/>
          <xsl:text>_</xsl:text>        
        </xsl:if>
        -->
        <xsl:value-of select="local-name()"/>
      </xsl:when>
      <xsl:when test="self::tei:pb">
        <xsl:choose>
          <xsl:when test="contains('0123456789IVXDCM', substring(@n,1,1))">
            <xsl:text>p</xsl:text>
            <xsl:value-of select="normalize-space(translate(@n, ' .', ''))"/>
          </xsl:when>
          <xsl:when test="@n != ''">
            <xsl:value-of select="normalize-space(translate(@n, ' .', ''))"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>p</xsl:text>
            <xsl:number level="any"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="self::tei:figure">
        <xsl:text>fig</xsl:text>
        <xsl:number level="any"/>
      </xsl:when>
      <xsl:when test="self::tei:graphic">
        <xsl:text>img</xsl:text>
        <xsl:number level="any"/>
      </xsl:when>
      <!-- Défaut -->
      <xsl:when test="true()">
        <!-- should I put file id as div id prefix ? -->
        <!--
        <xsl:if test="$docid != ''">
          <xsl:value-of select="translate($docid, $id0, $id1)"/>
          <xsl:text>_</xsl:text>
        </xsl:if>
        -->
        <xsl:value-of select="local-name()"/>
        <xsl:if test="count(key('qname', local-name())) &gt; 1">
          <xsl:number level="any"/>
        </xsl:if>
      </xsl:when>
      <!-- numérotation des notes, préfixées par la section -->
      <xsl:when test="self::tei:note or self::tei:app or self::tei:cit[@n]">
        <xsl:choose>
          <xsl:when test="ancestor::*[@xml:id]">
            <xsl:value-of select="ancestor::*[@xml:id][1]/@xml:id"/>
            <xsl:text>-</xsl:text>
          </xsl:when>
          <xsl:when test="ancestor::tei:text[parent::tei:group]">
            <xsl:for-each select="ancestor::tei:text[1]">
              <xsl:call-template name="n"/>
            </xsl:for-each>
            <xsl:text>-</xsl:text>
          </xsl:when>
          <xsl:when test="ancestor::*[key('split', generate-id())]">
            <xsl:for-each select="ancestor::*[key('split', generate-id())][1]">
              <xsl:call-template name="id"/>
            </xsl:for-each>
            <xsl:text>-</xsl:text>
          </xsl:when>
        </xsl:choose>        
        <xsl:text>fn</xsl:text>
        <xsl:variable name="n">
          <xsl:call-template name="n"/>
        </xsl:variable>
        <xsl:value-of select="translate($n, '()-', '')"/>
      </xsl:when>
      <!-- Où ?
      <xsl:when test="@n and ancestor::*[@xml:id][local-name() != local-name(/*)]">
        <xsl:value-of select="ancestor::*[@xml:id][1]/@xml:id"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="@n"/>
      </xsl:when>
      -->
      <!-- lien vers une ancre -->
      <xsl:when test="starts-with(@target, '#') and not(contains(@target, ' '))">
        <xsl:value-of select="substring(@target, 2)"/>
      </xsl:when>
      <!-- Mauvaise solution par défaut -->
      <xsl:otherwise>
        <xsl:value-of select="generate-id()"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$suffix"/>
  </xsl:template>
  
  <xsl:template name="note">
    <!-- identifiant de la note -->
    <xsl:variable name="id">
      <xsl:call-template name="id"/>
    </xsl:variable>
    <xsl:variable name="text">
      <xsl:for-each select="text()">
        <xsl:value-of select="normalize-space(.)"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="element">
      <xsl:choose>
        <xsl:when test="$format = $epub2">div</xsl:when>
        <xsl:otherwise>aside</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$element}" namespace="http://www.w3.org/1999/xhtml">
      <xsl:attribute name="class">
        <xsl:value-of select="normalize-space(concat(@rend, ' ', @resp, ' ', @type, ' ', @place, ' note'))"/>
      </xsl:attribute>
      <xsl:attribute name="id">
        <xsl:value-of select="$id"/>
      </xsl:attribute>
      <xsl:if test="$format = $epub3">
        <xsl:attribute name="epub:type">note</xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="parent::tei:noteStmt"/>
        <xsl:when test="$text='' and count(*)=1 and tei:p">
          <xsl:call-template name="noteback"/>
          <xsl:apply-templates select="*/node()"/>
        </xsl:when>
        <xsl:when test="$text='' and *[1][self::tei:p]">
          <p class="noindent">
            <xsl:call-template name="noteback"/>
            <xsl:apply-templates select="*[1]/node()"/>
          </p>
          <xsl:apply-templates select="*[position() &gt; 1]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="noteback"/>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
    <!-- TOTEST
      <xsl:choose>
        <xsl:when test="@ana">
          <xsl:text> </xsl:text>
          <i>
            <xsl:value-of select="@ana"/>
          </i>
          <xsl:text>. </xsl:text>
        </xsl:when>
      </xsl:choose>
      -->
  </xsl:template>
  
  <xsl:template match="tei:note">
    <xsl:choose>
      <xsl:when test="./@type = 'abstract'"/>
      <xsl:otherwise>
        <xsl:call-template name="noteref"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
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
  
  <xsl:template match="tei:noteStmt">
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
  <xsl:template match="tei:choice|tei:subst">
    <xsl:choose>
      <xsl:when test="tei:sic and tei:corr">
        <span>
          <xsl:call-template name="atts"/>
          <xsl:attribute name="title">
            <xsl:if test="*/@source">
              <xsl:value-of select="*/@source"/>
              <xsl:text> : </xsl:text>
            </xsl:if>
            <xsl:apply-templates select="tei:sic" mode="txt"/>
          </xsl:attribute>
          <b>
          <xsl:apply-templates select="tei:corr/node()"/>
          </b>
        </span>
      </xsl:when>
    </xsl:choose>
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
  

  <!--
    Cette règle empêche l'affichage des <div type='soustraduction'/> de la notice Ab urbe condita 
    -->
    <xsl:template match="tei:listBibl">
    <xsl:if test="not(./tei:head)">
      <xsl:choose>
        <xsl:when test="./tei:msDesc">
          <xsl:apply-templates></xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <div>
            <xsl:call-template name="atts"/>
            <h4 class="toto">Bibliographie : </h4>
            <xsl:apply-templates></xsl:apply-templates>
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
      <h4><xsl:attribute name="class">incipit</xsl:attribute><xsl:copy-of select="./tei:head/text()"/><xsl:text> </xsl:text><xsl:if test="./tei:p"><xsl:copy-of select="./tei:p/text()"/><xsl:text> </xsl:text></xsl:if><p><xsl:copy-of select="./tei:msDesc/tei:msIdentifier/tei:settlement/text()"/><xsl:text>, </xsl:text><xsl:copy-of select="./tei:msDesc/tei:msIdentifier/tei:repository/text()"/><xsl:text>, </xsl:text><xsl:copy-of select="./tei:msDesc/tei:msIdentifier/tei:idno/text()"/></p></h4>
      <table class="table is-bordered is-striped is-hoverable is-fullwidth">
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
  
  <xsl:template match="tei:eTree">
  </xsl:template>
  
  
</xsl:transform>
