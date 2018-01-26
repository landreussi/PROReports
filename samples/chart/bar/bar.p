DEFINE VARIABLE h AS HANDLE                          NO-UNDO.
DEFINE VARIABLE i-items  AS INTEGER                   NO-UNDO.
DEFINE VARIABLE c-data   AS CHARACTER FORMAT "X(100)" NO-UNDO.
DEFINE VARIABLE c-qtd    AS CHARACTER FORMAT "X(50)"  NO-UNDO.
RUN proreports.p PERSISTENT SET h.
RUN initialize IN h ("D:\PROReports\samples\chart\bar\src",
                     "Relatorio de itens", 
                     "itens", 
                     "united", 
                     NO).
RUN HEADER IN h ("Itens implantados em 08/2011",
                 "D:\logo.png", 
                 1).
FOR EACH ITEM WHERE ITEM.data-implant >= 08/01/2011 AND ITEM.data-implant <= 08/31/2011 NO-LOCK BREAK BY ITEM.data-implant:
    ASSIGN i-items = i-items + 1.
    IF FIRST-OF(ITEM.data-implant) THEN do:
        ASSIGN c-qtd   = c-qtd + STRING(i-items) + ";"
               c-data  = c-data + string(ITEM.data-implant) + ";"
               i-items = 0.
    END.
END.
ASSIGN c-qtd  = SUBSTR(c-qtd,1,LENGTH(c-qtd) - 1)
       c-data = SUBSTR(c-data,1,LENGTH(c-data) - 1).
RUN chart IN h("bar", /* TIPO DE GRµFICO */
               c-data, /* DADOS A SEREM COLOCADOS NO GRµFICO X (SEPARADOS POR VIRGULA) */
               "#44A8C9;#3A9ABA;#5CB0CC;#4BA2BF", /* CORES USADAS NO GRAFICO */
               c-qtd, /* DADOS A SEREM COLOCADOS NO GRµFICO Y (SEPARADOS POR VIRGULA) */
               1700, /* TAMANHO DE X */
               800,  /* TAMANHO DE Y */
               "itens"). /* ID DO GRAFICO */

RUN finish IN h.
