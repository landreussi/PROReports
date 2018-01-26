{includes/dashboard.i}
DEFINE VARIABLE h AS HANDLE                           NO-UNDO.
DEFINE VARIABLE i-items  AS INTEGER                   NO-UNDO.
DEFINE VARIABLE c-data   AS CHARACTER FORMAT "X(100)" NO-UNDO.
DEFINE VARIABLE c-qtd    AS CHARACTER FORMAT "X(50)"  NO-UNDO.
DEFINE VARIABLE c-qtd-1  AS CHARACTER FORMAT "X(50)"  NO-UNDO.
DEFINE VARIABLE c-nome   AS CHARACTER INIT "linhas"  NO-UNDO.
RUN proreports.p PERSISTENT SET h.
FIND FIRST tt-dashboard WHERE tt-dashboard.NAME = c-nome NO-LOCK NO-ERROR.
  IF AVAIL tt-dashboard THEN DO:
    RUN initialize IN h (tt-dashboard.path,
                         "Grafico Itens Linha",
                         tt-dashboard.NAME,
                         tt-dashboard.theme,
                         NO,
                         tt-dashboard.container-page,
                         tt-dashboard.acomp).
    RUN nav IN h (tt-dashboard.brand,
                  tt-dashboard.nav,
                  tt-dashboard.inverse,
                  tt-dashboard.container-nav).
    run header in h ("Quantidade de itens gerados entre 20/01 e 26/01", "", 2).
    FOR EACH ITEM WHERE ITEM.data-implant >= 01/20/2018 and ITEM.data-implant <= 01/26/2018 NO-LOCK BREAK BY ITEM.data-implant:
        ASSIGN i-items = i-items + 1.
        IF FIRST-OF(ITEM.data-implant) THEN do:
            ASSIGN c-qtd   = c-qtd + STRING(i-items) + ";"
                   c-qtd-1 = c-qtd-1 + STRING(i-items + 2) + ";"
                   c-data  = c-data + string(ITEM.data-implant) + ";"
                   i-items = 0.
        END.
    END.
    ASSIGN c-qtd-1  = SUBSTR(c-qtd-1,1,LENGTH(c-qtd-1) - 1)
           c-data   = SUBSTR(c-data,1,LENGTH(c-data) - 1).
    RUN chart IN h("line", /* TIPO DE GR�FICO */
                   c-data, /* DADOS A SEREM COLOCADOS NO GR�FICO X (SEPARADOS POR VIRGULA) */
                   "rgba(151,187,205,0.2);rgba(151,187,205,1);rgba(151,187,205,1);#fff;#fff;rgba(151,187,205,1);rgba(220,220,220,0.2);rgba(220,220,220,1);rgba(220,220,220,1);#fff;#fff;rgba(220,220,220,1)", /* CORES USADAS NO GRAFICO */
                   c-qtd + c-qtd-1, /* DADOS A SEREM COLOCADOS NO GR�FICO Y (SEPARADOS POR VIRGULA) */
                   2000, /* TAMANHO DE X */
                   800,  /* TAMANHO DE Y */
                   "itens"). /* ID DO GRAFICO */
    RUN finish IN h(NO).
END.
