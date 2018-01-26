/* ************** PROReports ***************** */
/* Criado e idealizado por:                    */
/*     Lucas Andreussi Simerdel                */
/*     Alisson Andreussi de Oliveira.          */

/* ******** VARIAVEIS GLOBAIS ********* */

/* ******** VARIAVEIS LOCAIS ********* */
DEFINE VARIABLE c-caminho AS CHAR NO-UNDO.
DEFINE VARIABLE c-nome AS CHAR NO-UNDO.
DEFINE VARIABLE c-js   AS CHARACTER INIT "" NO-UNDO.
DEFINE VARIABLE l-pdf AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-propath AS INTEGER     NO-UNDO.
DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED STREAM strHtml.

/* FUN€åES */

/* FUN€ÇO PARA RETORNAR A LOCALIZA€ÇO DO PROREPORTS NO PROPATH */
FUNCTION fn-find-propath RETURNS INTEGER (INPUT p-c-propath AS CHARACTER):
DEFINE VARIABLE i-loop AS INTEGER     NO-UNDO.

DO i-loop = 1 TO NUM-ENTRIES(PROPATH):
    IF ENTRY(i-loop, PROPATH) MATCHES "*" + p-c-propath + "*" THEN RETURN i-loop.
END.

END FUNCTION.

FUNCTION fn-capitalize RETURNS CHARACTER(INPUT p-c-string AS CHARACTER):
RETURN CAPS(SUBSTR(p-c-string,1,1)) + SUBSTR(p-c-string,2,LENGTH(p-c-string)).
END FUNCTION.

/* PROCEDURES */
PROCEDURE initialize:
DEF INPUT PARAMETER caminho AS CHAR NO-UNDO.
DEF INPUT PARAMETER titulo AS CHAR FORMAT "X(100)" NO-UNDO.
DEF INPUT PARAMETER nome AS CHAR NO-UNDO.
DEF INPUT PARAMETER tema AS CHAR NO-UNDO.
DEFINE INPUT  PARAMETER pdf AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-arq  AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-tema AS CHARACTER FORMAT "X(20)"   NO-UNDO.
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp("Running PROReports...").
RUN pi-acompanhar IN h-acomp ("Procedure: initialize").
ASSIGN i-propath = fn-find-propath("PROReports")
       c-arq     = IF ENTRY(i-propath, PROPATH) MATCHES "*" + "/" + "*" then REPLACE(ENTRY(i-propath, PROPATH), "/", "\\") ELSE REPLACE(ENTRY(i-propath, PROPATH), "\", "\\")
       c-tema    = tema + ".css"
       c-caminho = IF caminho MATCHES "*" + "/" + "*" then REPLACE(caminho, "/", "\\") ELSE REPLACE(caminho, "\", "\\")
       c-nome    = nome
       l-pdf     = pdf.

OUTPUT STREAM strHtml TO VALUE(c-caminho + "\" + c-nome + ".html") NO-CONVERT NO-ECHO.
RUN puts('<html><head>
        <meta charset="ISO-8859-1">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
		<title>' + titulo + '</title>').
DOS SILENT VALUE (' copy "' + c-arq + '\\javascript" "' + c-caminho + '" ').

IF search(ENTRY(i-propath, PROPATH) + '\themes\' + tema + '.css') = ? THEN DO: 
    DOS SILENT value(' copy "' + c-arq + '\\themes\\default.css"' + '"' + c-caminho + '" ').   
    RUN puts( '<link href="default.css" rel="stylesheet">').
END.
ELSE DO: 
    DOS SILENT value(' copy "' + c-arq + '\\themes\\' + tema + '.css" "' + c-caminho + '" ').
    RUN puts( '<link href="' + c-tema + '" rel="stylesheet">').
END.
RUN puts( "<script src='jquery-2.1.1.min.js'></script><script src='bootstrap.js'></script><script src='Chart.js'></script>").
IF l-pdf THEN RUN puts ('<script src="jspdf.js"><script src="html2pdf.js"></script>').
RUN puts('</head><body><div class="container">').
END PROCEDURE.

PROCEDURE script:
    DEFINE INPUT  PARAMETER cscript AS CHARACTER   NO-UNDO.
    RUN pi-acompanhar IN h-acomp ("Procedure: script").
    ASSIGN c-js = c-js + cscript.
END PROCEDURE.

PROCEDURE finish:
    IF l-pdf THEN ASSIGN c-js = c-js + "var pdf = new jsPDF('p', 'pt', 'letter'); source = $('body')[0]; specialElementHandlers = " + chr(123) + "'#bypassme': function (element, renderer) " + chr(123) + "return true;" + chr(125) + "" + chr(125) + "; margins = " + chr(123) + "top: 20, bottom: 20, left: 40, width: 720" + chr(125) + "; pdf.fromHTML(source, margins.left, margins.top, " + chr(123) + "'width': margins.width, 'elementHandlers': specialElementHandlers" + chr(125) + ", function (dispose) " + chr(123) + " pdf.save('" + c-nome + "'); " + chr(125) + ", margins);".
    RUN puts( '</div></body><script>' + c-js + '</script></html>').
    OUTPUT STREAM strHtml CLOSE.
    RUN pi-finalizar IN h-acomp.
    DOS SILENT VALUE(c-caminho + "\" + c-nome + ".html").
END PROCEDURE.

PROCEDURE custom-tag:
DEFINE INPUT  PARAMETER tag AS CHARACTER   NO-UNDO.
RUN pi-acompanhar IN h-acomp ("Procedure: custom-tag").
RUN puts( '<' + tag + '>').

END PROCEDURE.

PROCEDURE close-tag:
DEFINE INPUT  PARAMETER tag AS CHARACTER   NO-UNDO.
RUN pi-acompanhar IN h-acomp ("Procedure: close-tag").
RUN puts( '</' + tag + '>').

END PROCEDURE.

PROCEDURE puts:
DEFINE INPUT  PARAMETER chrPut AS CHARACTER   NO-UNDO.
PUT STREAM strHtml UNFORMATTED chrPut.

END PROCEDURE.

PROCEDURE insert-table:
DEFINE INPUT  PARAMETER p-c-csv   AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-c-class AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-loop AS INTEGER     NO-UNDO.
/* DEFINE INPUT  PARAMETER p-c-name  AS CHARACTER   NO-UNDO. */
/* DEFINE INPUT  PARAMETER p-c-id    AS CHARACTER   NO-UNDO. */
RUN puts("<table class='table " + p-c-class + "'><thead>").
RUN pi-acompanhar IN h-acomp ("Procedure: insert-table").
DO i-loop = 1 TO NUM-ENTRIES(p-c-csv, ";"):
    RUN puts("<th>" + ENTRY(i-loop, p-c-csv, ";") + "</th>").
END.
RUN puts("</thead><tbody>").
END PROCEDURE.

PROCEDURE add-row:
DEFINE INPUT  PARAMETER p-c-csv   AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-c-class AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-loop AS INTEGER     NO-UNDO.
RUN puts("<tr").
IF p-c-class <> "" THEN RUN puts(" class='" + p-c-class + "'").
RUN puts(">").
RUN pi-acompanhar IN h-acomp ("Procedure: add-row").
DO i-loop = 1 TO NUM-ENTRIES(p-c-csv, ";"):
    RUN puts("<td>" + ENTRY(i-loop, p-c-csv, ";") + "</td>").
END.
RUN puts("</tr>").
END PROCEDURE.

PROCEDURE close-table:
RUN pi-acompanhar IN h-acomp ("Procedure: close-table").
RUN puts("</tbody></table>").
END PROCEDURE.

PROCEDURE img:
DEFINE INPUT  PARAMETER p-c-path AS CHARACTER   NO-UNDO.
RUN puts("<img class='img-responsive' src='" + p-c-path + "'>").
END PROCEDURE.

PROCEDURE big-text:
DEFINE INPUT  PARAMETER p-c-string AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-i-size AS INTEGER     NO-UNDO.
RUN puts("<h" + STRING(p-i-size) + ">" + p-c-string + "</h" + STRING(p-i-size) + ">").
END PROCEDURE.

PROCEDURE header:
DEFINE INPUT  PARAMETER p-c-string AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-c-path AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-i-size AS INTEGER     NO-UNDO.
RUN puts("<br><div class='row'><div class='col-xs-4'>").
RUN img(p-c-path).
RUN puts ("</div><div class='col-xs-8'>").
RUN big-text(p-c-string, p-i-size).
RUN puts ("</div></div><br><br>").
END PROCEDURE.

PROCEDURE chart:
DEFINE INPUT  PARAMETER p-c-type    AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-c-labels  AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-c-colors  AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-c-data    AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-de-width  AS DECIMAL     NO-UNDO.
DEFINE INPUT  PARAMETER p-de-height AS DECIMAL     NO-UNDO.
DEFINE INPUT  PARAMETER p-c-id      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-color-type  AS CHARACTER FORMAT "X(90)"   NO-UNDO.
DEFINE VARIABLE c-labels      AS CHARACTER FORMAT "X(70)"   NO-UNDO.
DEFINE VARIABLE c-colors      AS CHARACTER FORMAT "X(70)"   NO-UNDO.
DEFINE VARIABLE c-chart       AS CHARACTER FORMAT "X(400)"  NO-UNDO.
DEFINE VARIABLE i-loop        AS INTEGER           NO-UNDO.
DEFINE VARIABLE i-loop2       AS INTEGER           NO-UNDO.
DEFINE VARIABLE i-do-colors   AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE i-do-data     AS INTEGER INITIAL 1 NO-UNDO.

RUN pi-acompanhar IN h-acomp ("Procedure: chart").

RUN puts("<div style='width: " + string(p-de-width / 20) + "%'><canvas id='cnv" + p-c-id + "' width='" + STRING(p-de-width) + "' height='" + STRING(p-de-height) + "'></canvas></div>").

DO i-loop = 1 TO NUM-ENTRIES(p-c-labels):
    IF i-loop < NUM-ENTRIES(p-c-labels) THEN
        ASSIGN c-labels = c-labels + '"' + ENTRY(i-loop, p-c-labels) + '",'.
    ELSE 
        ASSIGN c-labels = c-labels + '"' + ENTRY(i-loop, p-c-labels) + '"'.
END.

DO i-loop = 1 TO NUM-ENTRIES(p-c-colors):
    IF i-loop < NUM-ENTRIES(p-c-colors) THEN
        ASSIGN c-colors = c-colors + '"' + ENTRY(i-loop, p-c-colors) + '",'.
    ELSE
        ASSIGN c-colors = c-colors + '"' + ENTRY(i-loop, p-c-colors) + '"'.
END.

IF p-c-type = "bar" OR p-c-type = "radar" OR p-c-type = "line" THEN DO:
    IF p-c-type = "bar" THEN ASSIGN c-color-type = "fillColor,strokeColor,highlightFill,highlightStroke".
    ELSE IF p-c-type = "radar" OR p-c-type = "line" THEN ASSIGN c-color-type = "fillColor,strokeColor,pointColor,pointStrokeColor,pointHighlightFill,pointHighlightStroke".

    DO i-loop2 = 1 TO NUM-ENTRIES(p-c-data) / NUM-ENTRIES(p-c-labels):
       ASSIGN c-chart = c-chart + CHR(123).
       DO i-loop = 1 TO NUM-ENTRIES(c-color-type):
          ASSIGN c-chart = c-chart + ENTRY(i-loop, c-color-type) + " : " + ENTRY(i-do-colors, c-colors) + ","
                 i-do-colors = i-do-colors + 1.    
       END.
       ASSIGN c-chart = c-chart + "data : [".
       DO i-loop = 1 TO NUM-ENTRIES(p-c-labels):
           ASSIGN c-chart = c-chart + ENTRY(i-do-data, p-c-data)
                  i-do-data = i-do-data + 1.
           IF i-loop <> NUM-ENTRIES(p-c-labels) THEN ASSIGN c-chart = c-chart + ",".
       END.
       ASSIGN c-chart = c-chart + "]" + CHR(125).
       IF i-loop2 <> (NUM-ENTRIES(p-c-data) / NUM-ENTRIES(p-c-labels)) THEN ASSIGN c-chart = c-chart + ",".
    END.
    RUN script("var " + p-c-type + "ChartData = " + CHR(123) + "labels : [" + c-labels + "],datasets : [" + c-chart + "]" + CHR(125) + CHR(10) + "window.onload = function() " + CHR(123) + CHR(10) + "var ctx" + p-c-id + " = document.getElementById('cnv" + p-c-id + "').getContext('2d'); window.my" + fn-capitalize(p-c-type) + " = new Chart(ctx" + p-c-id + ")." + fn-capitalize(p-c-type) + "(" + p-c-type + "ChartData, " + CHR(123) + "responsive : true" + CHR(125) + " )" + CHR(125) + ";" + CHR(10)).
END.
ELSE DO: /* DOUGHNUT, PIE, POLAR  */
END.
END PROCEDURE.
