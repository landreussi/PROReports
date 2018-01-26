DEF NEW GLOBAL SHARED VAR c-caminho AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR c-nome AS CHAR NO-UNDO.
/* DEF VAR lc-html AS LONGCHAR NO-UNDO. */
PROCEDURE inicia:
DEF VAR c-arq AS CHAR NO-UNDO.
c-arq = REPLACE(ENTRY(1,PROPATH), "\", "\\").
DEF INPUT PARAMETER caminho AS CHAR NO-UNDO.
DEF INPUT PARAMETER titulo AS CHAR FORMAT "X(100)" NO-UNDO.
DEF INPUT PARAMETER nome AS CHAR NO-UNDO.
DEF INPUT PARAMETER tema AS CHAR NO-UNDO.
DEF VAR c-tema AS CHAR FORMAT "X(20)" NO-UNDO.
ASSIGN c-tema = tema + ".css"
       c-nome = nome.
/*IF SEARCH(caminho) = ? THEN
    MESSAGE "Coloque um caminho válido no primeiro parametro" VIEW-AS ALERT-BOX.
ELSE DO:*/
c-caminho = REPLACE(caminho, "\", "\\").
DOS SILENT VALUE ('copy "' + c-arq + '\\javascript" "' + c-caminho + '"').
IF search(entry(1,PROPATH) + '\themes\' + tema + '.css') = ? THEN DOS SILENT value('copy "' + c-arq + '\\themes\\default.css"' + '"' + c-caminho + '"').
ELSE DOS SILENT value('copy "' + c-arq + '\\themes\\' + tema + '.css" "' + c-caminho + '"').
OUTPUT TO VALUE(caminho + "\" + nome + ".html") NO-CONVERT.
    PUT '<html><head>
		<meta charset="UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
		<title>' titulo '</title>' FORMAT "X(400)".
IF search(entry(1,PROPATH) + '\themes\' + tema + '.css') = ? THEN PUT '<link href="default.css" rel="stylesheet">'.
ELSE PUT '<link href="' c-tema '" rel="stylesheet">'.
PUT '<script src="jquery-2.1.1.min.js"></script><script src="triggers.js"></script></head><body><div class="container">'.
/* END. */
END.

PROCEDURE divisao-col-md:
DEF INPUT PARAMETER tamanho AS INTEGER NO-UNDO.
IF tamanho <= 0 OR tamanho > 12 THEN MESSAGE "Para abrir um col-md o parametro do tamanho deverá ser maior ou igual a 1 e menor ou igual a 12" VIEW-AS ALERT-BOX.
ELSE PUT '<div class="col-md-' + string(tamanho) + '">'.
END.

PROCEDURE fecha-divisao:
PUT '</div>'.
END.

PROCEDURE divisao-well:
PUT '<div class="well">'.
END.

PROCEDURE h1:
DEF INPUT PARAMETER texto AS CHAR NO-UNDO.
PUT '<h1>' texto '</h1>'.
END.

PROCEDURE finaliza:
PUT '</div> </body>'.
PUT '<script>  </script> </html>'.
OUTPUT CLOSE.
DOS SILENT START VALUE(c-caminho + "\" + c-nome + ".html").
END.

