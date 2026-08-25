<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:functx="http://www.functx.com"
  xmlns:dts="https://w3id.org/dts/api#"
  xmlns:exslt="http://exslt.org/common"
  extension-element-prefixes="exslt"
  exclude-result-prefixes="tei"
>
  <!-- Keep this import order  -->
  <xsl:import href="../hteiml/tei2html.xsl"/>
  <!-- Dossier où retrouver des ressources de thème -->
  
  <xsl:param name="app" select="boolean(//tei:app) or boolean(//tei:choice)"/>
  <xsl:key name="qname-filtered" match="*[not(parent::choice)][not(parent::app)]" use="local-name()"/>
  
  <!-- Métas spécifiques au corpus -->
  <xsl:template match="tei:item/tei:ref">
    <xsl:variable name="idResource" select="ancestor::tei:TEI/@xml:id"/>
    <xsl:variable name="livre" select="substring-before(./@target, '_')"/>
    <a href="{concat($idResource, '?refId=', substring-after($livre, '#'), @target)}"><xsl:apply-templates/></a>
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
  
  <!-- Apparat critique désormais rendu par la feuille générique : lemme et
       appel dans le texte, rdg dans la rubrique finale. -->
  <xsl:template match="tei:app[tei:lem][false()]">
    <xsl:variable name="id">
      <xsl:call-template name="id"/>
    </xsl:variable>
    <span class="app">
      <xsl:attribute name="title">
        <xsl:text> </xsl:text>
        <xsl:value-of select="normalize-space(tei:rdg)"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="substring-after(tei:rdg/@wit, '#')"/>
        <xsl:if test="./tei:note">
          <xsl:text>. </xsl:text>
          <xsl:value-of select="tei:note"/>
        </xsl:if>
      </xsl:attribute>
      <a id="{$id}_" href="#{$id}">
        <xsl:apply-templates select="tei:lem" mode="inline"/></a>
        <xsl:if test="./tei:note"/>
    </span>
  </xsl:template>
  
  <xsl:template match="tei:choice[false()]">
    <xsl:variable name="id">
      <xsl:call-template name="id"/>
    </xsl:variable>
    <span class="choice">
      <xsl:attribute name="title">
        <xsl:text> </xsl:text>
        <xsl:choose>
          <xsl:when test="tei:corr/@source">
            <xsl:text>corr. d'après </xsl:text>
            <xsl:value-of select="substring-after(tei:corr/@source, '#')"/>
            <xsl:text> : </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>corr. par le copiste : </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="normalize-space(tei:sic)"/>
        <xsl:if test="./tei:note">
          <xsl:text>. </xsl:text>
          <xsl:value-of select="tei:note"/>
        </xsl:if>
      </xsl:attribute>
      <a id="{$id}_" href="#{$id}">
        <i class="corr"><xsl:apply-templates select="tei:corr"/></i>
      </a>
      <xsl:if test="./tei:note"/>
    </span>
  </xsl:template>
  
 <xsl:template match="tei:corr[not(ancestor::tei:choice)]">
    <span class="corr">
      <xsl:attribute name="title">
        <xsl:text>corr. par le copiste</xsl:text>
      </xsl:attribute>
      <i><xsl:apply-templates/></i>
    </span>
  </xsl:template>
  
  <xsl:template match="tei:lem">
    <span>
      <xsl:call-template name="atts"/>
      <xsl:text> </xsl:text>
      <xsl:apply-templates/>
    </span>
    <xsl:text>] </xsl:text>
  </xsl:template>
  
  <xsl:template match="tei:lem" mode="inline">
    <span>
      <xsl:call-template name="atts"/>
      <xsl:text> </xsl:text>
      <xsl:apply-templates/>
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <!-- Page break, add a space, hyphenation supposed to be resolved -->
  <xsl:template match="tei:pb" name="pb">
    <xsl:variable name="norm" select="normalize-space(@n)"/>
    <xsl:variable name="text">
      {f. <xsl:value-of select="@n"/>}
    </xsl:variable>
    <xsl:variable name="class">
      <xsl:text>pb</xsl:text>
    </xsl:variable>
    <xsl:variable name="id">
      <xsl:call-template name="id"/>
    </xsl:variable>
    <!-- test if inside mixed content, before adding a space, to keep automatic indent  -->
    <xsl:variable name="mixed" select="../text()[normalize-space(.) != '']"/>
    <a class="{normalize-space($class)}">
      <xsl:choose>
        <!-- @xml:base ? -->
        <xsl:when test="@facs">
          <xsl:attribute name="href">
            <xsl:if test="not(starts-with(@facs, 'http')) and /*/@xml:base">
              <xsl:value-of select="/*/@xml:base"/>
            </xsl:if>
            <xsl:value-of select="@facs"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="$id != ''">
          <xsl:attribute name="href">
            <xsl:text>#</xsl:text>
            <xsl:value-of select="$id"/>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:if test="$id != ''">
        <xsl:attribute name="id">
          <xsl:value-of select="$id"/>
        </xsl:attribute>
      </xsl:if>
      <!-- TODO by js
          <xsl:if test="not(@ed)">
            <xsl:attribute name="onclick">if(window.pb) pb(this, '<xsl:value-of select="$docid"/>', '<xsl:value-of select="@n"/>');</xsl:attribute>
          </xsl:if>
          -->
      <xsl:value-of select="$text"/>
    </a>
  </xsl:template>
  
  <xsl:template name="footnotes">
    <xsl:param name="cont" select="*"/>
    <xsl:param name="l" select="$cont//tei:l[@xml:id]"/>
    <xsl:variable name="apparatus">
      <xsl:if test="$app">
        <xsl:choose>
          <xsl:when test="$cont">
            <xsl:for-each select="$cont//tei:app | $cont//tei:choice">
              <xsl:call-template name="note-inline"/>
            </xsl:for-each>
          </xsl:when>
        </xsl:choose>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="note">
      <xsl:for-each select="$cont//tei:note[not(parent::tei:app)][not(parent::tei:choice)]">
        <div class="note-page">
          <xsl:call-template name="fn"/>
        </div>
      </xsl:for-each>
    </xsl:variable>
    <xsl:if test="$app != ''">
      <hr/>
      <h3>Apparat critique</h3>
      <p class="apparatus">
        <xsl:copy-of select="$apparatus"/>
      </p>
    </xsl:if>
    <xsl:if test="$note != ''">
      <hr/>
      <section class="footnotes">
        <h3 class="head notes">Notes</h3>
        <xsl:copy-of select="$note"/>
      </section>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="choice">
    <xsl:text> </xsl:text>
    <xsl:choose>
      <xsl:when test="tei:corr/@source">
        <xsl:apply-templates select="tei:sic" mode="apparatus"/>
        <xsl:text> corr. en </xsl:text>
        <xsl:apply-templates select="tei:corr" mode="apparatus"/>
        <xsl:text> d'après </xsl:text>
        <xsl:value-of select="substring-after(tei:corr/@source, '#')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="tei:sic" mode="apparatus"/>
        <xsl:text>corr. en </xsl:text>
        <xsl:apply-templates select="tei:corr" mode="apparatus"/>
        <xsl:text> par le copiste</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="./tei:note">
      <xsl:text>. </xsl:text>
      <xsl:value-of select="tei:note"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="note-inline">
    <!-- identifiant de la note -->
    <xsl:variable name="id">
      <xsl:call-template name="id"/>
    </xsl:variable>
    <xsl:variable name="verse" select="./parent::tei:l/@xml:id"/>
    <span class="note" id="{$id}">
    <a href="#{$verse}"><xsl:value-of select="substring-after($verse, '_')"/></a>
    <xsl:choose>
      <xsl:when test="self::tei:app">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="choice"/>
      </xsl:otherwise>
    </xsl:choose>
      <xsl:text> </xsl:text>
    </span>
  </xsl:template>

</xsl:transform>












