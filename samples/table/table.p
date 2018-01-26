DEFINE VARIABLE h AS HANDLE NO-UNDO.
RUN proreports.p PERSISTENT SET h.
RUN initialize IN h ("D:\PROReports\samples\table\src",
                     "Relat¢rio de itens", 
                     "itens", 
                     "cosmo", 
                     NO).
RUN HEADER IN h ("Itens implantados em 08/2011",
                 "D:\logo.png", 
                 1).
RUN insert-table IN h (INPUT "Item;Descri‡Æo;GE",
                       INPUT "table table-bordered table-responsive table-hover").
FOR EACH ITEM WHERE ITEM.data-implant >= 08/01/2011 AND ITEM.data-implant <= 08/31/2011 NO-LOCK:
     RUN add-row IN h (INPUT ITEM.it-codigo + ";" + ITEM.desc-item + ";" + string(ITEM.ge-codigo),
                       INPUT "").
END.
RUN close-table IN h.
RUN finish      IN h.
