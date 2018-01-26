{includes/dashboard.i}
DEFINE VARIABLE h AS HANDLE                           NO-UNDO.
DEFINE VARIABLE i-items  AS INTEGER                   NO-UNDO.
DEFINE VARIABLE c-data   AS CHARACTER FORMAT "X(100)" NO-UNDO.
DEFINE VARIABLE c-qtd    AS CHARACTER FORMAT "X(50)"  NO-UNDO.
DEFINE VARIABLE c-qtd-1  AS CHARACTER FORMAT "X(50)"  NO-UNDO.
DEFINE VARIABLE c-nome   AS CHARACTER INIT "barras"  NO-UNDO.
RUN proreports.p PERSISTENT SET h.
FIND FIRST tt-dashboard WHERE tt-dashboard.NAME = c-nome NO-LOCK NO-ERROR.
  IF AVAIL tt-dashboard THEN DO:  
    RUN initialize IN h (tt-dashboard.path,
                         "Grafico Itens Barra", 
                         tt-dashboard.NAME, 
                         tt-dashboard.theme, 
                         NO,
                         tt-dashboard.container-page,
                         tt-dashboard.acomp).
    RUN nav IN h (tt-dashboard.brand,
                  tt-dashboard.nav,
                  tt-dashboard.inverse,
                  tt-dashboard.container-nav).
    FOR EACH ITEM WHERE ITEM.ge-codigo = 30 NO-LOCK BREAK BY ITEM.data-implant:
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
    RUN chart IN h("bar", 
                   c-data, 
                   "#44A8C9;#3A9ABA;#5CB0CC;#4BA2BF;#EB4B36;#F5604C;#ED5440;#F73116",
                   c-qtd + c-qtd-1,
                   2000, 
                   800,  
                   "itens").
    RUN finish IN h(NO).
END.
