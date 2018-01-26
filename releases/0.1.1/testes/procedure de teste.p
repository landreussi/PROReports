DEF VAR proreports AS HANDLE NO-UNDO.
RUN VALUE("D:\PROReports\PROReports.p") PERSISTENT SET proreports.
RUN inicia                       IN proreports(INPUT "D:\PROReports\testes", INPUT "Voce disse, pipoca?", INPUT "index", INPUT "spacelab").
RUN divisao-well                 IN proreports.
RUN divisao-container            IN proreports.
RUN divisao-col                  IN proreports(INPUT 3, INPUT "sm").
RUN imagem                       IN proreports(INPUT "D:\bocalon.jpg").
RUN fecha-divisao                IN proreports.
RUN divisao-col                  IN proreports(INPUT 3, INPUT "sm").
RUN h1                           IN proreports(INPUT "Hello World!").
RUN fecha-divisao                IN proreports.
RUN divisao-col                  IN proreports(INPUT 3, INPUT "sm").
RUN h1                           IN proreports(INPUT "PROReports :)").
RUN fecha-divisao                IN proreports.
RUN divisao-col                  IN proreports(INPUT 3, INPUT "sm").
RUN h1                           IN proreports(INPUT "Globo Usinagem").
RUN fecha-divisao                IN proreports.
RUN fecha-divisao                IN proreports.
RUN fecha-divisao                IN proreports.
RUN finaliza                     IN proreports.

