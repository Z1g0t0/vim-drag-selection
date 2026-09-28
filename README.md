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
 - VISUAL MODE:
    - j : Move selection one line down.
    - J : Move selection half a page down.
    - k : Move selection one line up.
    - K : Move selection half a page up.
    - h : Dedent selection.
    - H : Move selection to the top of the page.
    - l : Indent selection.
    - L : Move selection to the bottom of the page. 
    - { : Move selection to the first blank line upwards.
    - } : Move selection to the first blank line downwards.
    - 0 : Left align selection(start of the line).
    - $ : Right align selection(based on the longest selected line).
    - gg: Move selection to the top of the file.
    - G : Move selection to the bottom of the file.
 - VISUAL BLOCK MODE:
    - j : Move block one line down.
    - J : Move block half a page down.
    - k : Move block one line up.
    - K : Move block up half a page.
    - h : Moves block one character to the left.
    - H : Move block to the top of the page.
    - l : Moves block one character to the right.
    - L : Move block to the bottom of the page.
    - { : Move block to the first blank line upwards.
    - } : Move block to the first blank line downwards.
    - 0 : Left align block(start of the line).
    - $ : Right align block(based on the longest selected line).
    - gg: Move block to the top of the file.
    - G : Move block to the bottom of the file.
 - Press <Esc>, <C-c> or <leader>v to toggle *Drag Mode OFF* .

## Configuration
Bind your preferred keys:

init.vim
```
" Change the toggle key mapping
let g:drag_selection_disable_defaults = 1
vnoremap <silent>v <Plug>(ToggleDragMode)   "v in visual mode, personally prefer this.

" Change internal movement keys
let g:down_one      = 'j'
let g:up_one        = 'k'
let g:down_lot      = 'J'
let g:up_lot        = 'K'
let g:dedent        = 'h'
let g:indent        = 'l'
let g:start_line    = '0'
let g:end_line      = '$'
let g:top_page      = 'H'
let g:bottom_page   = 'L'
let g:top_file      = 'gg'
let g:bottom_file   = 'G'
let g:blank_up      = '{'
let g:blank_down    = '}'
let g:exit          = '<Esc>'
```
or

init.lua
```
-- Disable the default <leader>v toggle
vim.g.drag_selection_disable_defaults = 1

-- Map the toggle to 'v' in visual mode(uses 'x' for correct recursive mapping)
vim.keymap.set('x', 'v', '<Plug>(ToggleDragMode)', { silent = true })

-- Change internal movement keys
vim.g.down_one      = 'j'
vim.g.up_one        = 'k'
vim.g.down_lot      = 'J'
vim.g.up_lot        = 'K'
vim.g.dedent        = 'h'
vim.g.indent        = 'l'
vim.g.start_line    = '0'
vim.g.end_line      = '$'
vim.g.top_page      = 'H'
vim.g.bottom_page   = 'L'
vim.g.top_file      = 'gg'
vim.g.bottom_file   = 'G'
vim.g.blank_up      = '{'
vim.g.blank_down    = '}'
vim.g.exit          = '<Esc>'
```