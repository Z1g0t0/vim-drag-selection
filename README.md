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
 - Press <Esc> or <leader>v to toggle *Drag Mode OFF* .
