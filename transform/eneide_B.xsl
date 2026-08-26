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
  

</xsl:transform>











