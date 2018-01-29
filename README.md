# PROReports
API para gerar páginas baseadas em bootstrap para Openedge Progress

![print](https://image.ibb.co/mkc69G/pro.png)

## Começando a usar
- Para começar a usar, adicione a pasta PROReports em seu **propath**
- Depois é só persisti-lo em sua aplicação: `RUN PROReports.p PERSISTENT SET h-variavel.` e usar as **procedures internas**

## Procedures Internas

### initialize (obrigatória para inicializar o resto da aplicação):
**Parâmetros de entrada:**
* CHARACTER Caminho: o caminho onde a página e seus recursos vão ficar
* CHARACTER Titulo: correspondente a tag `<title> ` do HTML
* CHARACTER Nome: nome do arquivo HTML
* CHARACTER Tema: tema do [Bootswatch](https://bootswatch.com/) que será usado na página
* LOGICAL PDF: converte para PDF? (s/n)
* LOGICAL Container: containerizar o conteúdo da página? (s/n)
* LOGICAL Acompanhar: usar tela de acompanhamento padrão? (s/n) **somente disponível se estiver utilizando o Datasul**

### insert-table (inicializa uma tabela):
**Parâmetros de entrada:**
* CHARACTER CSV: o cabeçalho de sua tabela separado por ';'
* CHARACTER Classe: as [classes do bootstrap](https://getbootstrap.com/docs/3.3/css/#tables) que será inserido na tabela *(e.g "table-striped table-responsive table-bordered")*

### add-row (requere insert-table):
**Parâmetros de entrada:**
* CHARACTER CSV: os campos de sua linha separado por ';'
* CHARACTER Classe: as [classes do bootstrap](https://getbootstrap.com/docs/3.3/css/#tables-contextual-classes) que será inserido na linha *(e.g "success", "info", "warning", "danger"),*

### close-table (requere insert-table):
**Sem parâmetros de entrada, fecha a tabela aberta pelo insert-table**

### header (cria um cabeçalho com logo e título):
**Parâmetros de entrada:**
* CHARACTER String: o título do seu cabeçalho
* CHARACTER Caminho: o caminho da sua imagem
* INTEGER Tamanho: o tamanho do título (1 para `<h1>` e assim sucessivamente)

### nav (cria barra de navegação):
**Parâmetros de entrada:**
* CHARACTER Brand: o título do seu projeto
* CHARACTER CSV: as opções da sua barra de navegação dividido por ';'
* LOGICAL Invertido: se a cor da sua barra será invertida a partir da documentação do [Bootswatch](https://bootswatch.com/) (s/n)
* LOGICAL Container: inicializa container? (s/n)

### chart (cria gráfico do [ChartJS](http://www.chartjs.org/)):
**Parâmetros de entrada:**
* CHARACTER Tipo: tipo do gráfico do [ChartJS](http://www.chartjs.org/docs/latest/charts/)
* CHARACTER Labels do eixo X: separados por vírgula
* CHARACTER Cores: separados por ';' e deve ser múltiplo da quantidade de dados comparados no gráfico (para o caso de ser um gráfico comparativo) *Suporta hexadecimais e cores com [rgba](https://www.w3schools.com/cssref/tryit.asp?filename=trycss_color_rgba)*
* CHARACTER Labels do eixo Y: separados por vírgula
* INTEGER Tamanho de X
* INTEGER Tamanho de Y
* CHARACTER ID da tabela

### dashboard (gera dashboard usando os comandos acima):
**Parâmetros de entrada:**
* CHARACTER Brand do navbar
* CHARACTER Caminhos dos programas filho baseados no PROReports que gerarão gráficos ou tabelas e estarão disponíveis no navbar
* LOGICAL inverte navbar? (s/n)
* LOGICAL containeriza conteúdo? (s/n)

### finish (finaliza execução e gera o arquivo):
**Parâmetros de entrada:**
* LOGICAL abrir arquivo gerado(pdf/html)? (s/n)

**Não entendeu nada ou possui dificuldade?**
*Todos os exemplos estão disponíveis na pasta `samples` deste repositório!*

## Libs de terceiros utilizadas no projeto:
* JQuery 2.1.1
* Bootstrap 3.2
* ChartJS 1.0.1 - beta
* JSPDF 1.1.135
