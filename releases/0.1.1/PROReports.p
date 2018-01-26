DEF NEW GLOBAL SHARED VAR c-html AS CHAR FORMAT "X(1000)" NO-UNDO.
DEF NEW GLOBAL SHARED VAR c-caminho AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR c-nome AS CHAR NO-UNDO.
PROCEDURE inicia:
DEF VAR c-arq AS CHAR NO-UNDO.
c-arq = REPLACE("D:\PROReports", "\", "\\").
DEF INPUT PARAMETER caminho AS CHAR NO-UNDO.
DEF INPUT PARAMETER titulo AS CHAR FORMAT "X(100)" NO-UNDO.
DEF INPUT PARAMETER nome AS CHAR NO-UNDO.
DEF INPUT PARAMETER tema AS CHAR NO-UNDO.
OS-DELETE VALUE(caminho + nome + ".html").  
DEF VAR c-tema AS CHAR FORMAT "X(20)" NO-UNDO.
ASSIGN c-tema = tema + ".css"
       c-nome = nome.
c-caminho = REPLACE(caminho, "\", "\\").
DOS SILENT VALUE ('copy "' + c-arq + '\\javascript" "' + c-caminho + '"').
IF search("D:\PROReports" + '\themes\' + tema + '.css') = ? THEN DOS SILENT value('copy "' + c-arq + '\\themes\\default.css"' + '"' + c-caminho + '"').
ELSE DOS SILENT value('copy "' + c-arq + '\\themes\\' + tema + '.css" "' + c-caminho + '"').
    ASSIGN c-html = c-html + '<html><head>
		<meta charset="UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
		<title>' + titulo + '</title>'.
IF search("D:\PROReports" + '\themes\' + tema + '.css') = ? THEN ASSIGN c-html = c-html + '<link href="default.css" rel="stylesheet">'.
ELSE ASSIGN c-html = c-html + '<link href="' + c-tema + '" rel="stylesheet">'.
ASSIGN c-html = c-html + '<script src="jquery-2.1.1.min.js"></script><script src="triggers.js"></script></head><body>'.
/* END. */
END.

PROCEDURE divisao-container:
   ASSIGN c-html = c-html + '<div class="container">'.
END.

PROCEDURE imagem:
   DEF INPUT PARAM caminho AS CHAR NO-UNDO.
   IF SEARCH(caminho) <> ? THEN
   ASSIGN c-html = c-html + '<img src="' + caminho + '"/>'.
   ELSE
       MESSAGE "O caminho da imagem " caminho " n∆o Ç valida."
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
END.

PROCEDURE divisao-col:
DEF INPUT PARAMETER tamanho AS INTEGER NO-UNDO.
DEF INPUT PARAMETER tipo AS CHAR NO-UNDO.
IF tamanho <= 0 OR tamanho > 12 THEN MESSAGE "Para abrir um col-md o parametro do tamanho dever· ser maior ou igual a 1 e menor ou igual a 12" VIEW-AS ALERT-BOX.
ELSE DO:
    IF tipo = "xs" OR tipo = "sm" OR tipo = "md" OR tipo = "lg" THEN
    ASSIGN c-html = c-html + '<div class="col-' + tipo + '-' + string(tamanho) + '">'.
    ELSE 
        MESSAGE "O tipo do col '" tipo + "' Ç inexistente"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
END.
END.

PROCEDURE fecha-divisao:
ASSIGN c-html = c-html + '</div>'.
END.

PROCEDURE divisao-well:
ASSIGN c-html = c-html + '<div class="well">'.
END.

PROCEDURE h1:
DEF INPUT PARAMETER texto AS CHAR NO-UNDO.
ASSIGN c-html = c-html + '<h1>' + texto + '</h1>'.
END.

PROCEDURE finaliza:
ASSIGN c-html = c-html + '</div> </body>'.
ASSIGN c-html = c-html + '<script>  </script> </html>'.
OUTPUT TO VALUE(c-caminho + "\" + c-nome + ".html") NO-CONVERT.
PUT c-html.
OUTPUT CLOSE.
/* MESSAGE c-html                         */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK. */
DOS SILENT START VALUE(c-caminho + "\" + c-nome + ".html").
ASSIGN c-html = "".
END.

