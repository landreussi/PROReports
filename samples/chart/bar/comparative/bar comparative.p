DEFINE VARIABLE h AS HANDLE                           NO-UNDO.
DEFINE VARIABLE i-items  AS INTEGER                   NO-UNDO.
DEFINE VARIABLE c-data   AS CHARACTER FORMAT "X(100)" NO-UNDO.
DEFINE VARIABLE c-qtd    AS CHARACTER FORMAT "X(50)"  NO-UNDO.
DEFINE VARIABLE c-qtd-1  AS CHARACTER FORMAT "X(50)"  NO-UNDO.
RUN proreports.p PERSISTENT SET h.
RUN initialize IN h ("D:\PROReports\samples\chart\bar\comparative\src",
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
               c-qtd-1 = c-qtd-1 + STRING(i-items + 2) + ";"
               c-data  = c-data + string(ITEM.data-implant) + ";"
               i-items = 0.
    END.
END.
ASSIGN c-qtd-1  = SUBSTR(c-qtd-1,1,LENGTH(c-qtd-1) - 1)
       c-data   = SUBSTR(c-data,1,LENGTH(c-data) - 1).
RUN chart IN h("bar", /* TIPO DE GRµFICO */
               c-data, /* DADOS A SEREM COLOCADOS NO GRµFICO X (SEPARADOS POR VIRGULA) */
               "#44A8C9;#3A9ABA;#5CB0CC;#4BA2BF;#EB4B36;#F5604C;#ED5440;#F73116", /* CORES USADAS NO GRAFICO */
               c-qtd + c-qtd-1, /* DADOS A SEREM COLOCADOS NO GRµFICO Y (SEPARADOS POR VIRGULA) */
               2000, /* TAMANHO DE X */
               800,  /* TAMANHO DE Y */
               "itens"). /* ID DO GRAFICO */
RUN finish IN h.
