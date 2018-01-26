{includes/dashboard.i}
DEFINE VARIABLE h AS HANDLE NO-UNDO.
RUN proreports.p PERSISTENT SET h.
RUN initialize IN h ("D:\PROReports\samples\dashboard\src",
                     "Dashboard de itens",
                     "index",
                     "cosmo",
                     NO,
                     NO,
                     YES).
RUN dashboard IN h ("Dashboard",
                    "D:/PROReports/samples/dashboard/linhas.p;D:/PROReports/samples/dashboard/barras.p",
                    YES,
                    YES).
run header in h ("Itens gerados entre 20/01 e 26/01", "", 2).
RUN insert-table IN h (INPUT "Item;Descri‡Æo;GE",
                       INPUT "table table-bordered table-responsive table-hover").
FOR EACH ITEM WHERE ITEM.data-implant >= 01/20/2018 and ITEM.data-implant <= 01/26/2018 NO-LOCK:
     RUN add-row IN h (INPUT ITEM.it-codigo + ";" + ITEM.desc-item + ";" + string(ITEM.ge-codigo),
                       INPUT "").
END.
RUN close-table IN h.
RUN finish IN h(YES).
