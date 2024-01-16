Data Frames and Tibbles
================
Marco Malva
2023-05-11

- <a href="#create-classic-data-frame"
  id="toc-create-classic-data-frame">Create Classic Data Frame</a>
- <a href="#create-tibbles" id="toc-create-tibbles">Create Tibbles</a>
- <a href="#static-tables" id="toc-static-tables">Static Tables</a>
- <a href="#interactive-dt-tables"
  id="toc-interactive-dt-tables">Interactive DT Tables</a>

<!-- Setting HTML stype to allow for a wider HTML output, force it with !important, see <https://stackoverflow.com/a/69329334> -->
<style type="text/css">
.main-container {
  max-width: 2100px !important;
  margin-left: auto;
  margin-right: auto;
}
</style>

> Not all table output is available in the `github_document` output
> format which is why I had to enable `always_allow_html`. The output
> could be improved by installing webshot packages but that is currently
> beyond the scope of this document. For now, for best output, select
> `html_document`.

## Create Classic Data Frame

Creating a classic R data frame from a vector of values, renaming the
column and adding an index column:

``` r
df1 <- c('Spurs', 'Lakers', 'Pistons', 'Mavs') |> as.data.frame() |> dplyr::rename_with(.cols = 1, ~"team") |> tibble::rowid_to_column("idx")
df1
```

    ##   idx    team
    ## 1   1   Spurs
    ## 2   2  Lakers
    ## 3   3 Pistons
    ## 4   4    Mavs

## Create Tibbles

Same as the classic data frame but converting it to a tibble.

For tibbles refer to `vignette("tibble")` or read [10 Tibbles \| R for
Data Science](https://r4ds.had.co.nz/tibbles.html). for background on
HTML table with CSS to alternate table see: [CSS table with alternating
color
rows](https://www.textfixer.com/tutorials/css-table-alternating-rows.php)

``` r
df2 <- c('Spurs', 'Lakers', 'Pistons', 'Mavs') |> as.data.frame() |> dplyr::rename_with(.cols = 1, ~"team") |> tibble::rowid_to_column("idx") |> tibble::as_tibble() 
df2
```

    ## # A tibble: 4 × 2
    ##     idx team   
    ##   <int> <chr>  
    ## 1     1 Spurs  
    ## 2     2 Lakers 
    ## 3     3 Pistons
    ## 4     4 Mavs

## Static Tables

Converting the classic data frame and the tibble into HTML tables.

For more details refer to: [Create Awesome HTML Table with knitr::kable
and
kableExtra](https://cran.r-project.org/web/packages/kableExtra/vignettes/awesome_table_in_html.html).

First, with the classic data frame:

``` r
df1 %>%
  kbl() %>%
  kable_material(c("striped", "hover"))
```

<table class=" lightable-material lightable-striped lightable-hover" style="font-family: &quot;Source Sans Pro&quot;, helvetica, sans-serif; margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:right;">
idx
</th>
<th style="text-align:left;">
team
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Spurs
</td>
</tr>
<tr>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Lakers
</td>
</tr>
<tr>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
Pistons
</td>
</tr>
<tr>
<td style="text-align:right;">
4
</td>
<td style="text-align:left;">
Mavs
</td>
</tr>
</tbody>
</table>

And for the tibble data frame:

``` r
df2 %>%
  kbl() %>%
  kable_material(c("striped", "hover"))
```

<table class=" lightable-material lightable-striped lightable-hover" style="font-family: &quot;Source Sans Pro&quot;, helvetica, sans-serif; margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:right;">
idx
</th>
<th style="text-align:left;">
team
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Spurs
</td>
</tr>
<tr>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Lakers
</td>
</tr>
<tr>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
Pistons
</td>
</tr>
<tr>
<td style="text-align:right;">
4
</td>
<td style="text-align:left;">
Mavs
</td>
</tr>
</tbody>
</table>

## Interactive DT Tables

For interactive DT tables and other RMarkdown tricks see: [Pimp my RMD:
a few tips for R Markdown](https://holtzy.github.io/Pimp-my-rmd/)

First, with the classic data frame:

``` r
library(DT)
datatable(df1, rownames = FALSE, filter="top", options = list(pageLength = 5, scrollX=T) )
```

    ## PhantomJS not found. You can install it with webshot::install_phantomjs(). If it is installed, please make sure the phantomjs executable can be found via the PATH variable.

<div class="datatables html-widget html-fill-item-overflow-hidden html-fill-item" id="htmlwidget-4aace61605c4f9d7680c" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-4aace61605c4f9d7680c">{"x":{"filter":"top","vertical":false,"filterHTML":"<tr>\n  <td data-type=\"integer\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"1\" data-max=\"4\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n<\/tr>","data":[[1,2,3,4],["Spurs","Lakers","Pistons","Mavs"]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th>idx<\/th>\n      <th>team<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"pageLength":5,"scrollX":true,"columnDefs":[{"className":"dt-right","targets":0}],"order":[],"autoWidth":false,"orderClasses":false,"orderCellsTop":true,"lengthMenu":[5,10,25,50,100]}},"evals":[],"jsHooks":[]}</script>

And for the tibble data frame:

``` r
library(DT)
datatable(df2, rownames = FALSE, filter="top", options = list(pageLength = 5, scrollX=T) )
```

<div class="datatables html-widget html-fill-item-overflow-hidden html-fill-item" id="htmlwidget-0491d9b1d0210bcfd77f" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-0491d9b1d0210bcfd77f">{"x":{"filter":"top","vertical":false,"filterHTML":"<tr>\n  <td data-type=\"integer\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"1\" data-max=\"4\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n<\/tr>","data":[[1,2,3,4],["Spurs","Lakers","Pistons","Mavs"]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th>idx<\/th>\n      <th>team<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"pageLength":5,"scrollX":true,"columnDefs":[{"className":"dt-right","targets":0}],"order":[],"autoWidth":false,"orderClasses":false,"orderCellsTop":true,"lengthMenu":[5,10,25,50,100]}},"evals":[],"jsHooks":[]}</script>

Do DT table show columns different when they are factors?

``` r
library(DT)
df2fac <- df2
df2fac$team = as.factor(df2fac$team)
datatable(df2fac, rownames = FALSE, filter="top", options = list(pageLength = 5, scrollX=T) )
```

<div class="datatables html-widget html-fill-item-overflow-hidden html-fill-item" id="htmlwidget-fd690ecb6285661a6ca9" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-fd690ecb6285661a6ca9">{"x":{"filter":"top","vertical":false,"filterHTML":"<tr>\n  <td data-type=\"integer\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"display: none;position: absolute;width: 200px;opacity: 1\">\n      <div data-min=\"1\" data-max=\"4\"><\/div>\n      <span style=\"float: left;\"><\/span>\n      <span style=\"float: right;\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"factor\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\" data-options=\"[&quot;Lakers&quot;,&quot;Mavs&quot;,&quot;Pistons&quot;,&quot;Spurs&quot;]\"><\/select>\n    <\/div>\n  <\/td>\n<\/tr>","data":[[1,2,3,4],["Spurs","Lakers","Pistons","Mavs"]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th>idx<\/th>\n      <th>team<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"pageLength":5,"scrollX":true,"columnDefs":[{"className":"dt-right","targets":0}],"order":[],"autoWidth":false,"orderClasses":false,"orderCellsTop":true,"lengthMenu":[5,10,25,50,100]}},"evals":[],"jsHooks":[]}</script>
