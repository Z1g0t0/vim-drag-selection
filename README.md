# vim-drag-selection

Simple visual mode selection dragging.

## Installation

[vim-plug](https://github.com/junegunn/vim-plug):
```vim
Plug 'Z1g0t0/vim-drag-selection'
```
[packer.nvim](https://github.com/wbthomason/packer.nvim):
```lua
use 'Z1g0t0/vim-drag-selection'
```
[lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{ 'Z1g0t0/vim-drag-selection' }
```

## Usage
 - Select text in Visual mode (v or V). 
 - Press <leader>v to toggle *Drag Mode ON*.
 - Drag the selection with:
    - j : Move selection down.
    - J : Move selection down half a page.
    - k : Move selection up.
    - K : Move selection up half a page.
    - h : Dedent block(<).
    - l : Indent block(>).
    - H : Move selection to the top of the page.
    - L : Move slection to the bottom of the page.
    - { : Move selection up a paragraph
    - } : Move selection down a paragraph
    - gg: Move selection to the top of the file
    - G : Move selection to the bottom of the file
 - Press <Esc>, <C-c> or <leader>v to toggle *Drag Mode OFF* .
 - Drag Mode also disarms itself automatically whenever Visual mode is left
   by any other route (mouse click, running a : command, ...), so it can
   never fire a stray movement on the next selection.

## Configuration
Bind your preferred keys:

init.vim
```
" Change the toggle key mapping
let g:drag_selection_disable_defaults = 1
xmap <leader>d <Plug>(ToggleDragMode)

" Change internal movement keys
let g:down_one      = 'j'
let g:up_one        = 'k'
let g:down_lot'     = 'J'
let g:up_lot'       = 'K'
let g:dedent        = 'h'
let g:indent        = 'l'
let g:top_page'     = 'H'
let g:bottom_page'  = 'L'
let g:top_file'     = 'gg'
let g:bottom_file'  = 'G'
let g:blank_up'     = '{'
let g:blank_down'   = '}'
let g:exit'         = '<Esc>'
```
or

init.lua
```
-- Change the toggle key mapping
vim.g.drag_selection_disable_defaults = 1
vim.keymap.set('x', '<leader>d', '<Plug>(ToggleDragMode)')

-- Change internal movement keys
vim.g.down_one      = 'j'
vim.g.up_one        = 'k'
vim.g.down_lot'     = 'J'
vim.g.up_lot'       = 'K'
vim.g.dedent        = 'h'
vim.g.indent        = 'l'
vim.g.top_page'     = 'H'
vim.g.bottom_page'  = 'L'
vim.g.top_file'     = 'gg'
vim.g.bottom_file'  = 'G'
vim.g.blank_up'     = '{'
vim.g.blank_down'   = '}'
vim.g.exit'         = '<Esc>'
```