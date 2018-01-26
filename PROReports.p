{includes/dashboard.i}

DEFINE VARIABLE c-caminho   AS CHAR NO-UNDO.
DEFINE VARIABLE c-nome      AS CHAR NO-UNDO.
DEFINE VARIABLE c-js        AS CHARACTER INIT "" NO-UNDO.
DEFINE VARIABLE l-pdf       AS LOGICAL           NO-UNDO.
DEFINE VARIABLE l-acomp     AS LOGICAL           NO-UNDO.
DEFINE VARIABLE i-propath   AS INTEGER           NO-UNDO.
DEFINE VARIABLE h-acomp     AS HANDLE            NO-UNDO.
DEFINE VARIABLE l-container AS LOGICAL           NO-UNDO.
DEFINE VARIABLE i-start     AS INTEGER           NO-UNDO.
DEFINE VARIABLE i-file      AS INTEGER INIT 0    NO-UNDO.
DEFINE VARIABLE c-tema      AS CHARACTER FORMAT "X(20)"   NO-UNDO.
DEFINE STREAM strHtml.

/* FUN��ES */
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
DEFINE INPUT  PARAMETER caminho AS CHAR NO-UNDO.
DEFINE INPUT  PARAMETER titulo AS CHAR FORMAT "X(100)" NO-UNDO.
DEFINE INPUT  PARAMETER nome AS CHAR NO-UNDO.
DEFINE INPUT  PARAMETER tema AS CHAR NO-UNDO.
DEFINE INPUT  PARAMETER pdf AS LOGICAL     NO-UNDO.
DEFINE INPUT  PARAMETER container AS LOGICAL     NO-UNDO.
DEFINE INPUT  PARAMETER acomp AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-arq  AS CHARACTER                  NO-UNDO.

/* DOS SILENT VALUE('DEL /F /Q /S ' + caminho + '*.*') */

ASSIGN i-start = TIME.

IF acomp THEN DO:
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp("Running PROReports...").
    RUN pi-acompanhar IN h-acomp ("Procedure: initialize").
END.
ASSIGN i-propath = fn-find-propath("PROReports")
       c-arq     = ENTRY(i-propath, PROPATH)
       c-tema    = tema + ".css"
       c-caminho = caminho
       c-nome    = nome
       l-pdf     = pdf
       l-acomp   = acomp.

OUTPUT STREAM strHtml TO VALUE(caminho + "\" + c-nome + ".html") NO-CONVERT NO-ECHO.
RUN puts('<html><head>
        <meta charset="ISO-8859-1">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
		<title>' + titulo + '</title>').
DOS SILENT VALUE (' copy "' + c-arq + '\javascript" "' + caminho + '" ').

IF search(ENTRY(i-propath, PROPATH) + '\themes\' + tema + '.css') = ? THEN DO:
    DOS SILENT value(' copy "' + c-arq + '\themes\default.css"' + '"' + caminho + '" ').
    RUN puts( '<link href="default.css" rel="stylesheet">').
END.
ELSE DO:
    DOS SILENT value(' copy "' + c-arq + '\themes\' + tema + '.css" "' + caminho + '" ').
    RUN puts( '<link href="' + c-tema + '" rel="stylesheet">').
END.
RUN puts( "<script src='jquery-2.1.1.min.js'></script><script src='bootstrap.js'></script><script src='Chart.js'></script>").
IF l-pdf THEN RUN puts ('<script src="jspdf.js"><script src="html2pdf.js"></script>').
RUN puts('</head><body>').
IF container THEN
    RUN puts('<div class="container">').
ASSIGN l-container = container.

END PROCEDURE.

PROCEDURE script:
    DEFINE INPUT  PARAMETER cscript AS CHARACTER   NO-UNDO.
    IF l-acomp THEN
        RUN pi-acompanhar IN h-acomp ("Procedure: script").
    ASSIGN c-js = c-js + cscript.
END PROCEDURE.

PROCEDURE finish:
    DEFINE INPUT  PARAMETER l-open AS LOGICAL     NO-UNDO.

    IF l-pdf THEN ASSIGN c-js = c-js + "var pdf = new jsPDF('p', 'pt', 'letter'); source = $('body')[0]; specialElementHandlers = " + chr(123) + "'#bypassme': function (element, renderer) " + chr(123) + "return true;" + chr(125) + "" + chr(125) + "; margins = " + chr(123) + "top: 20, bottom: 20, left: 40, width: 720" + chr(125) + "; pdf.fromHTML(source, margins.left, margins.top, " + chr(123) + "'width': margins.width, 'elementHandlers': specialElementHandlers" + chr(125) + ", function (dispose) " + chr(123) + " pdf.save('" + c-nome + "'); " + chr(125) + ", margins);".
    IF l-container THEN RUN puts('</div>').
    RUN puts('</body><script>' + c-js + '</script></html>').
    OUTPUT STREAM strHtml CLOSE.
    IF l-acomp THEN
        RUN pi-finalizar IN h-acomp.
    IF l-open THEN
    DOS SILENT VALUE(c-caminho + "\" + c-nome + ".html").
END PROCEDURE.

PROCEDURE custom-tag:
DEFINE INPUT  PARAMETER tag AS CHARACTER   NO-UNDO.
IF l-acomp THEN
    RUN pi-acompanhar IN h-acomp ("Procedure: custom-tag").
RUN puts( '<' + tag + '>').

END PROCEDURE.

PROCEDURE close-tag:
DEFINE INPUT  PARAMETER tag AS CHARACTER   NO-UNDO.
IF l-acomp THEN
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
IF l-acomp THEN
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
IF l-acomp THEN
    RUN pi-acompanhar IN h-acomp ("Procedure: add-row").
DO i-loop = 1 TO NUM-ENTRIES(p-c-csv, ";"):
    RUN puts("<td>" + ENTRY(i-loop, p-c-csv, ";") + "</td>").
END.
RUN puts("</tr>").
END PROCEDURE.

PROCEDURE close-table:
IF l-acomp THEN
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
IF p-c-path <> "" THEN
RUN img(p-c-path).
RUN puts ("</div><div class='col-xs-8'>").
RUN big-text(p-c-string, p-i-size).
RUN puts ("</div></div><br><br>").
END PROCEDURE.

PROCEDURE text-input:
RUN puts("<input type='text' class='form-control'></input>").
END.

PROCEDURE radio-input:
DEFINE INPUT PARAMETER p-c-labels AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-c-name   AS CHARACTER NO-UNDO.
/* RUN puts("") */
END.

PROCEDURE chart:
DEFINE INPUT  PARAMETER p-c-type    AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-c-labels  AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-c-colors  AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-c-data    AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-de-width  AS DECIMAL     NO-UNDO.
DEFINE INPUT  PARAMETER p-de-height AS DECIMAL     NO-UNDO.
DEFINE INPUT  PARAMETER p-c-id      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-default     AS CHARACTER FORMAT "X(90)"   NO-UNDO.
DEFINE VARIABLE c-capitalize  AS CHARACTER FORMAT "X(15)"   NO-UNDO.
DEFINE VARIABLE c-labels      AS CHARACTER FORMAT "X(70)"   NO-UNDO.
DEFINE VARIABLE c-colors      AS CHARACTER FORMAT "X(70)"   NO-UNDO.
DEFINE VARIABLE c-chart       AS CHARACTER FORMAT "X(400)"  NO-UNDO.
DEFINE VARIABLE i-loop        AS INTEGER           NO-UNDO.
DEFINE VARIABLE i-loop2       AS INTEGER           NO-UNDO.
DEFINE VARIABLE i-do-colors   AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE i-do-data     AS INTEGER INITIAL 1 NO-UNDO.

IF l-acomp THEN
    RUN pi-acompanhar IN h-acomp ("Procedure: chart").

RUN puts("<div style='width: " + string(p-de-width / 20) + "%'><canvas id='cnv" + p-c-id + "' width='" + STRING(p-de-width) + "' height='" + STRING(p-de-height) + "'></canvas></div>").

ASSIGN c-capitalize = fn-capitalize(p-c-type).

DO i-loop = 1 TO NUM-ENTRIES(p-c-labels, ";"):
    IF i-loop < NUM-ENTRIES(p-c-labels, ";") THEN
        ASSIGN c-labels = c-labels + '"' + ENTRY(i-loop, p-c-labels, ";") + '",'.
    ELSE
        ASSIGN c-labels = c-labels + '"' + ENTRY(i-loop, p-c-labels, ";") + '"'.
END.

DO i-loop = 1 TO NUM-ENTRIES(p-c-colors, ";"):
    IF i-loop < NUM-ENTRIES(p-c-colors, ";") THEN
        ASSIGN c-colors = c-colors + '"' + ENTRY(i-loop, p-c-colors, ";") + '";'.
    ELSE
        ASSIGN c-colors = c-colors + '"' + ENTRY(i-loop, p-c-colors, ";") + '"'.
END.

IF p-c-type = "bar" OR p-c-type = "radar" OR p-c-type = "line" THEN DO:
    IF p-c-type = "bar" THEN ASSIGN c-default = "fillColor,strokeColor,highlightFill,highlightStroke".
    ELSE IF p-c-type = "radar" OR p-c-type = "line" THEN ASSIGN c-default = "fillColor,strokeColor,pointColor,pointStrokeColor,pointHighlightFill,pointHighlightStroke".
    DO i-loop2 = 1 TO NUM-ENTRIES(p-c-data, ";") / NUM-ENTRIES(c-labels):
       ASSIGN c-chart = c-chart + CHR(123).
       DO i-loop = 1 TO NUM-ENTRIES(c-default):
          ASSIGN c-chart = c-chart + ENTRY(i-loop, c-default) + " : " + ENTRY(i-do-colors, c-colors, ";") + ","
                 i-do-colors = i-do-colors + 1.
       END.
       ASSIGN c-chart = c-chart + "data : [".
       DO i-loop = 1 TO NUM-ENTRIES(c-labels):
           ASSIGN c-chart = c-chart + ENTRY(i-do-data, p-c-data, ";")
                  i-do-data = i-do-data + 1.
           IF i-loop <> NUM-ENTRIES(c-labels) THEN ASSIGN c-chart = c-chart + ",".
       END.
       ASSIGN c-chart = c-chart + "]" + CHR(125).
       IF i-loop2 <> (NUM-ENTRIES(p-c-data) / NUM-ENTRIES(c-labels)) THEN ASSIGN c-chart = c-chart + ",".
    END.
    RUN script("var " + p-c-id + "ChartData = " + CHR(123) + "labels : [" + c-labels + "],datasets : [" + c-chart + "]" + CHR(125) + CHR(10) + "window.onload = function() " + CHR(123) + CHR(10) + "var ctx" + p-c-id + " = document.getElementById('cnv" + p-c-id + "').getContext('2d'); window.my" + fn-capitalize(p-c-type) + " = new Chart(ctx" + p-c-id + ")." + fn-capitalize(p-c-type) + "(" + p-c-id + "ChartData, " + CHR(123) + "responsive : true" + CHR(125) + " )" + CHR(125) + ";" + CHR(10)).
END.
ELSE DO:
    DO i-loop = 1 TO NUM-ENTRIES(c-labels):
        ASSIGN c-chart = c-chart + CHR(123) + "value : " + ENTRY(i-loop, p-c-data, ";") + ", color : " + CHR(34) + ENTRY(1, ENTRY(i-loop, p-c-colors, ";"), "/") + CHR(34) + ", highlight : " + CHR(34) + ENTRY(2, ENTRY(i-loop, p-c-colors, ";"), "/") + CHR(34) + ", label : " + ENTRY(i-loop, c-labels) + CHR(125).
        IF i-loop <> NUM-ENTRIES(c-labels) THEN ASSIGN c-chart = c-chart + ",".
    END.
    IF c-capitalize = "Polar" THEN ASSIGN c-capitalize = c-capitalize + "Area".
    RUN script("var " + p-c-id + "Data = [" + c-chart + "]" + CHR(10) + "window.onload = function() " + CHR(123) + CHR(10) + "var ctx" + p-c-id + " = document.getElementById('cnv" + p-c-id + "').getContext('2d'); window.my" + c-capitalize + " = new Chart(ctx" + p-c-id + ")." + c-capitalize + "(" + p-c-id + "Data, " + CHR(123) + "responsive : true" + CHR(125) + " )" + CHR(125) + ";" + CHR(10)).
END.
END PROCEDURE.

PROCEDURE nav:
DEFINE INPUT  PARAMETER p-c-brand     AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-c-csv       AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-l-inverse   AS LOGICAL     NO-UNDO.
DEFINE INPUT  PARAMETER p-l-container AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-loop       AS INTEGER     NO-UNDO.

RUN puts ('<nav class="navbar navbar-').
IF p-l-inverse THEN
    RUN puts('inverse').
ELSE
    RUN puts('default').
RUN puts('" role="navigation"><div class="navbar-header"><button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse"><span class="sr-only">Toggle navigation</span><span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></button><a class="navbar-brand" href="index.html">').
    IF SEARCH(p-c-brand) = ? THEN
        RUN puts(p-c-brand).
    ELSE
        RUN img(p-c-brand).
RUN puts ('</a></div><div class="collapse navbar-collapse navbar-ex1-collapse"><ul class="nav navbar-nav">').
DO i-loop = 1 TO NUM-ENTRIES(p-c-csv, ";"):
    RUN puts('<li').
    IF c-nome = ENTRY(i-loop, p-c-csv, ";") THEN
        RUN puts(' class="active"').
    RUN puts('><a href="' + ENTRY(i-loop, p-c-csv, ";") + '.html">' + fn-capitalize(ENTRY(i-loop, p-c-csv, ";")) + '</a></li>').
END.
RUN puts ('</ul></div></nav>').
IF p-l-container THEN DO:
    RUN puts('<div class="container">').
    ASSIGN l-container = YES.
END.
END PROCEDURE.

PROCEDURE dashboard:
DEFINE INPUT  PARAMETER p-c-brand     AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-c-paths     AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-l-inverse   AS LOGICAL     NO-UNDO.
DEFINE INPUT  PARAMETER p-l-container AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-nav   AS CHARACTER format "X(70)"  NO-UNDO.
DEFINE VARIABLE i-loop  AS INTEGER                   NO-UNDO.
DEFINE VARIABLE c-paths AS CHARACTER format "X(500)" NO-UNDO.
ASSIGN c-paths = REPLACE(p-c-paths, "/", "\").
EMPTY TEMP-TABLE tt-dashboard.
DO i-loop = 1 TO NUM-ENTRIES(c-paths, ";"):
    ASSIGN c-nav = c-nav + ENTRY(1, ENTRY(NUM-ENTRIES(ENTRY(i-loop, c-paths, ";"), "\"), ENTRY(i-loop, c-paths, ";"), "\"), ".").
    IF i-loop < NUM-ENTRIES(c-paths, ";") THEN ASSIGN c-nav = c-nav + ";".
END.
DO i-loop = 1 TO NUM-ENTRIES(c-nav, ";"):
    CREATE tt-dashboard.
    ASSIGN tt-dashboard.NAME           = ENTRY(1, ENTRY(NUM-ENTRIES(ENTRY(i-loop, c-paths, ";"), "\"), ENTRY(i-loop, c-paths, ";"), "\"), ".")
           tt-dashboard.path           = c-caminho
           tt-dashboard.brand          = p-c-brand
           tt-dashboard.theme          = entry(1, c-tema, ".")
           tt-dashboard.container-page = l-container
           tt-dashboard.container-nav  = p-l-container
           tt-dashboard.nav            = c-nav
           tt-dashboard.inverse        = p-l-inverse
           tt-dashboard.acomp          = l-acomp.
END.

DO i-loop = 1 TO NUM-ENTRIES(c-paths, ";"):
    RUN VALUE(ENTRY(i-loop, c-paths, ";")).
END.

RUN nav (p-c-brand,
         c-nav,
         p-l-inverse,
         p-l-container).
END PROCEDURE.
