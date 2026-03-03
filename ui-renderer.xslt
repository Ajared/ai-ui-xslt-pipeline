<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/">
    <html>
      <head>
        <title><xsl:value-of select="Screen/@title"/></title>
        <style>
          @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&amp;display=swap');
          
          :root {
            --color-bg: #ffffff;
            --color-ink: #6b7280; --color-ink-dark: #374151; --color-ink-darkest: #111827;
            --color-terra: #3b82f6; /* Modern Blue */
            --font-primary: 'Inter', system-ui, -apple-system, sans-serif;
            --font-mono: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
          }
          * { box-sizing: border-box; }
          body { 
            font-family: var(--font-primary); background: #f3f4f6; color: var(--color-ink-dark); 
            margin: 0; padding: 2rem; -webkit-font-smoothing: antialiased; 
            display: flex; justify-content: center;
          }
          .screen { 
            width: 100%; max-width: 400px; border: 1px solid #e5e7eb; 
            border-radius: 16px; overflow: hidden; background: var(--color-bg); 
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
          }
          .avatar-row { 
            display: flex; gap: 1.2rem; padding: 1.5rem; overflow-x: auto; 
            border-bottom: 1px solid #f3f4f6; background: var(--color-bg); 
            scrollbar-width: none;
          }
          .avatar-row::-webkit-scrollbar { display: none; }
          .user { display: flex; flex-direction: column; align-items: center; gap: 0.6rem; position: relative; flex-shrink: 0; }
          .avatar { width: 56px; height: 56px; border-radius: 50%; border: 2px solid var(--color-terra); object-fit: cover; }
          .dot { position: absolute; top: 0px; right: 0px; width: 14px; height: 14px; border-radius: 50%; background: #ef4444; border: 2px solid #fff; }
          .name { font-family: var(--font-mono); font-size: 0.72rem; text-transform: uppercase; letter-spacing: 0.05em; color: var(--color-ink); font-weight: 600; }
          .section { padding: 1.5rem; border-bottom: 1px solid #f3f4f6; }
          .section-header { display: flex; justify-content: space-between; align-items: baseline; margin-bottom: 1.2rem; }
          .section-title { font-size: 1.25rem; font-weight: 700; letter-spacing: -0.02em; color: var(--color-ink-darkest); margin: 0; }
          .section-action { font-family: var(--font-mono); font-size: 0.75rem; color: var(--color-terra); text-decoration: none; text-transform: uppercase; letter-spacing: 0.05em; font-weight: 600; }
          .section-action:hover { color: var(--color-ink-darkest); }
          .card-list { display: flex; flex-direction: column; gap: 1rem; }
          .card { background: var(--color-bg); border: 1px solid #e5e7eb; padding: 1.2rem; border-radius: 8px; border-left: 4px solid var(--color-terra); box-shadow: 0 1px 3px rgba(0,0,0,0.02); }
          .card-time { font-family: var(--font-mono); font-size: 0.7rem; color: var(--color-terra); margin-bottom: 0.4rem; display: block; letter-spacing: 0.05em; font-weight: 600; }
          .card-title { font-size: 1.05rem; font-weight: 600; color: var(--color-ink-darkest); margin: 0 0 0.3rem 0; letter-spacing: -0.01em; }
          .card-location { font-size: 0.85rem; color: var(--color-ink); margin: 0; }
        </style>
      </head>
      <body>
        <div class="screen">
          <xsl:apply-templates select="Screen"/>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="Screen">
    <xsl:apply-templates select="AvatarRow"/>
    <xsl:apply-templates select="Section"/>
  </xsl:template>

  <xsl:template match="AvatarRow">
    <div class="avatar-row">
      <xsl:apply-templates select="User"/>
    </div>
  </xsl:template>

  <xsl:template match="User">
    <div class="user">
      <img class="avatar" src="{@avatarUrl}" alt="{@name}" />
      <xsl:if test="@notification = 'true'">
        <div class="dot"></div>
      </xsl:if>
      <span class="name"><xsl:value-of select="@name"/></span>
    </div>
  </xsl:template>

  <xsl:template match="Section">
    <div class="section">
      <div class="section-header">
        <h2 class="section-title"><xsl:value-of select="@title"/></h2>
        <xsl:if test="@action">
          <a href="#" class="section-action"><xsl:value-of select="@action"/></a>
        </xsl:if>
      </div>
      <xsl:apply-templates select="CardList"/>
    </div>
  </xsl:template>

  <xsl:template match="CardList">
    <div class="card-list">
      <xsl:apply-templates select="Card"/>
    </div>
  </xsl:template>

  <xsl:template match="Card">
    <div class="card">
      <span class="card-time"><xsl:value-of select="@time"/></span>
      <h3 class="card-title"><xsl:value-of select="@title"/></h3>
      <p class="card-location"><xsl:value-of select="@location"/></p>
    </div>
  </xsl:template>
</xsl:stylesheet>
