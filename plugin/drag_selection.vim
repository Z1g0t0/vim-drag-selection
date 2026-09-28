if exists('g:loaded_drag_selection')
    finish
endif
let g:loaded_drag_selection = 1

" Helper function for right-aligning selected lines (Case 2)
function! s:AlignRight() abort
    let l:start = line("'<")
    let l:end = line("'>")
    let l:max_len = 0

    " Find the max line length (ignoring trailing whitespace)
    for l:lnum in range(l:start, l:end)
        let l:clean = substitute(getline(l:lnum), '\s\+$', '', '')
        let l:len = strdisplaywidth(l:clean)
        if l:len > l:max_len
            let l:max_len = l:len
        endif
    endfor

    " Right align the lines based on the longest line
    if l:max_len > 0
        execute "'<,'>right " . l:max_len
    endif

    " Reselect the visual area
    normal! gv
endfunction

function! ToggleDragMode()
    if !exists('b:drag_active')
        let b:drag_active = 0
    endif

    let l:k_down_one    = get(g:, 'down_one',       'j')
    let l:k_up_one      = get(g:, 'up_one',         'k')
    let l:k_down_lot    = get(g:, 'down_lot',       'J')
    let l:k_up_lot      = get(g:, 'up_lot',         'K')
    let l:k_dedent      = get(g:, 'dedent',         '<')
    let l:k_indent      = get(g:, 'indent',         '>')
    let l:k_top_page    = get(g:, 'top_page',       'H')
    let l:k_bottom_page = get(g:, 'bottom_page',    'L')
    let l:k_blank_up    = get(g:, 'blank_up',       '{')
    let l:k_blank_down  = get(g:, 'blank_down',     '}')
    let l:k_top_file    = get(g:, 'top_file',       'gg')
    let l:k_bottom_file = get(g:, 'bottom_file',    'G')

    let l:k_start_line  = get(g:, 'start_line',     '0')
    let l:k_end_line    = get(g:, 'end_line',       '$')
    let l:k_block_left  = get(g:, 'block_left',     'h')
    let l:k_block_right = get(g:, 'block_right',    'l')
    let l:k_block_up    = get(g:, 'block_up',       '<Up>')
    let l:k_block_down  = get(g:, 'block_down',     '<Down>')

    let l:k_exit        = get(g:, 'exit',           '<Esc>')

    if b:drag_active == 0
        let b:drag_active = 1

        " Line-based moves (Whole lines)
        exe 'xnoremap <buffer> <silent> ' . l:k_down_one    . ' :<C-u>silent! undojoin <Bar> ''<,''>m ''>+1<CR>gvgv'
        exe 'xnoremap <buffer> <silent> ' . l:k_up_one      . ' :<C-u>silent! undojoin <Bar> ''<,''>m ''<-2<CR>gvgv'
        exe 'xnoremap <buffer> <silent> ' . l:k_down_lot    . ' :m ''>+10<CR>gvgv'
        exe 'xnoremap <buffer> <silent> ' . l:k_up_lot      . ' :m ''<-11<CR>gvgv'
        exe 'xnoremap <buffer> <silent> ' . l:k_dedent      . ' <gv'
        exe 'xnoremap <buffer> <silent> ' . l:k_indent      . ' >gv'
        exe 'xnoremap <buffer> <silent> ' . l:k_top_page    . ' :m <C-R>=line("w0")-1<CR><CR>gvgv'
        exe 'xnoremap <buffer> <silent> ' . l:k_bottom_page . ' :m <C-R>=line("w$")<CR><CR>gvgv'
        exe 'xnoremap <buffer> <silent> ' . l:k_blank_up    . ' :m ''{-1<CR>gvgv'
        exe 'xnoremap <buffer> <silent> ' . l:k_blank_down  . ' :m ''}<CR>gvgv'
        exe 'xnoremap <buffer> <silent> ' . l:k_top_file    . ' :m 0<CR>gvgv'
        exe 'xnoremap <buffer> <silent> ' . l:k_bottom_file . ' :m $<CR>gvgv'

        " 0 and $ Logic: Align in v/V mode, Block move in <C-v> mode
        exe 'xnoremap <buffer> <expr> <silent> ' . l:k_start_line  . ' mode() ==# "\<C-V>" ? "d0P`[\<C-V>`]" : ":\<C-u>silent! ''<,''>left\<CR>gv"'
        exe 'xnoremap <buffer> <expr> <silent> ' . l:k_end_line    . ' mode() ==# "\<C-V>" ? "d$p`[\<C-V>`]" : ":\<C-u>call <SID>AlignRight()\<CR>"'

        " Inline / Visual Block moves
        exe 'xnoremap <buffer> <expr> <silent> ' . l:k_block_left  . ' "dhP`[" . mode() . "`]"'
        exe 'xnoremap <buffer> <expr> <silent> ' . l:k_block_right . ' "dp`[" . mode() . "`]"'
        exe 'xnoremap <buffer> <expr> <silent> ' . l:k_block_up    . ' "dkP`[" . mode() . "`]"'
        exe 'xnoremap <buffer> <expr> <silent> ' . l:k_block_down  . ' "djP`[" . mode() . "`]"'

        exe 'xnoremap <buffer> <silent> ' . l:k_exit        . ' <Cmd>call ToggleDragMode()<CR><Esc>'
        exe 'xnoremap <buffer> <silent> <C-c> <Cmd>call ToggleDragMode()<CR><C-c>'

        let b:drag_keys = [
                    \ l:k_down_one, l:k_up_one, l:k_down_lot, l:k_up_lot, l:k_dedent, l:k_indent, 
                    \ l:k_top_page, l:k_bottom_page, l:k_blank_up, l:k_blank_down, l:k_top_file, 
                    \ l:k_bottom_file, l:k_start_line, l:k_end_line, l:k_block_left, l:k_block_right, 
                    \ l:k_block_up, l:k_block_down, l:k_exit, '<C-c>'
                    \ ]
    else
        let b:drag_active = 0
        for k in b:drag_keys
            silent! exec 'xunmap <buffer>' k
        endfor
    endif
endfunction

xnoremap <silent> <Plug>(ToggleDragMode) <Cmd>call ToggleDragMode()<CR>

if !get(g:, 'drag_selection_disable_defaults', 0)
    xmap <leader>v <Plug>(ToggleDragMode)
endif

function! s:AutoDisarm(buf, timer) abort
    if a:buf == bufnr() && get(b:, 'drag_active', 0)
                \ && mode() !=# 'v' && mode() !=# 'V' && mode() !=# "\<C-V>"
        call ToggleDragMode()
    endif
endfunction

if exists('##ModeChanged')
    augroup DragSelection
        autocmd!
        autocmd ModeChanged * call timer_start(0, function(expand('<SID>') . 'AutoDisarm', [bufnr()]))
    augroup END
endif