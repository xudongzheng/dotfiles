" Set width to a really small value to always use a vertical split.
let g:termdebug_wide = 1

" Termdebug maps the K key to evaluate by default. Disable to retain the default
" behavior (repeat latest search in opposite direction).
let g:termdebug_map_K = v:false

" Set color for line where program is interrupted.
hi debugPC term=reverse ctermbg=magenta
