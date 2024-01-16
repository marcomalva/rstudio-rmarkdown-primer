# Install Add-In

## Splitting Code Chunks

I set that add-in to use `CTRL-ALT-/`, best used on an empty line,
see: [splitChunk – RStudio addin for splitting code chunks in R Markdown | R-bloggers](https://www.r-bloggers.com/2017/02/splitchunk-rstudio-addin-for-splitting-code-chunks-in-r-markdown/)

```r
install.packages("devtools")
devtools::install_github("LudvigOlsen/splitChunk")
```

Then one must go into _Tools > Addins > Browse Addins > Keyboard Shortcuts_ to configure it.

> The add-in does not copy all the code block flags so that is not ideal.

## Vim Mode

I enabled Vim Mode in "Code | Keybindings" in _Tools > Global opitons_ but I had to disable the `chrome vimium` plug-in 
for the browser as it does catch the `ESC` to enter command mode. My first impressions after disabling `vimium` are that
the Vim Mode works fine.
