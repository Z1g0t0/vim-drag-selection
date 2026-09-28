if exists('g:loaded_drag_selection')
    finish
endif
let g:loaded_drag_selection = 1

" Helper function for right-aligning selected lines (0 / $ logic in v/V mode)
function! s:AlignRight() abort
    let l:start = line("'<")
    let l:end = line("'>")
    let l:max_len = 0

    for l:lnum in range(l:start, l:end)
        let l:clean = substitute(getline(l:lnum), '\s\+$', '', '')
        let l:len = strdisplaywidth(l:clean)
        if l:len > l:max_len
            let l:max_len = l:len
        endif
    endfor

    if l:max_len > 0
        execute "'<,'>right " . l:max_len
    endif

    normal! gv
endfunction

function! ToggleDragMode()
    if !exists('b:drag_active')
        let b:drag_active = 0
    endif

    " Key configurations (overridable via g: variables)
    let l:k_down_one    = get(g:, 'down_one',       'j')
    let l:k_up_one      = get(g:, 'up_one',         'k')
    let l:k_dedent      = get(g:, 'dedent',         'h')
    let l:k_indent      = get(g:, 'indent',         'l')
    let l:k_down_lot    = get(g:, 'down_lot',       'J')
    let l:k_up_lot      = get(g:, 'up_lot',         'K')
    let l:k_top_page    = get(g:, 'top_page',       'H') 
    let l:k_bottom_page = get(g:, 'bottom_page',    'L') 
    let l:k_blank_up    = get(g:, 'blank_up',       '{')
    let l:k_blank_down  = get(g:, 'blank_down',     '}')
    let l:k_top_file    = get(g:, 'top_file',       'gg')
    let l:k_bottom_file = get(g:, 'bottom_file',    'G')

    let l:k_start_line  = get(g:, 'start_line',     '0')
    let l:k_end_line    = get(g:, 'end_line',       '$')

    let l:k_exit        = get(g:, 'exit',           '<Esc>')

    if b:drag_active == 0
        let b:drag_active = 1

        " 1. Single Step Up/Down (Line move vs Block move)
        exe 'xnoremap <buffer> <expr> <silent> ' . l:k_down_one . ' mode() ==# "\<C-V>" ? "djP`[\<C-V>`]" : ":\<C-u>silent! undojoin <Bar> ''<,''>m ''>+1\<CR>gvgv"'
        exe 'xnoremap <buffer> <expr> <silent> ' . l:k_up_one   . ' mode() ==# "\<C-V>" ? "dkP`[\<C-V>`]" : ":\<C-u>silent! undojoin <Bar> ''<,''>m ''<-2\<CR>gvgv"'

        " 2. Multi-Step / Large Jumps (10 lines up/down)
        exe 'xnoremap <buffer> <expr> <silent> ' . l:k_down_lot . ' mode() ==# "\<C-V>" ? "d10jP`[\<C-V>`]" : ":\<C-u>''<,''>m ''>+10\<CR>gvgv"'
        exe 'xnoremap <buffer> <expr> <silent> ' . l:k_up_lot   . ' mode() ==# "\<C-V>" ? "d10kP`[\<C-V>`]" : ":\<C-u>''<,''>m ''<-11\<CR>gvgv"'

        " 3. File Top/Bottom Jumps (gg / G)
        exe 'xnoremap <buffer> <expr> <silent> ' . l:k_top_file    . ' mode() ==# "\<C-V>" ? "dggP`[\<C-V>`]" : ":\<C-u>''<,''>m 0\<CR>gvgv"'
        exe 'xnoremap <buffer> <expr> <silent> ' . l:k_bottom_file . ' mode() ==# "\<C-V>" ? "dGP`[\<C-V>`]"  : ":\<C-u>''<,''>m $\<CR>gvgv"'

        " 4. Blank Line Paragraph Jumps ({ / })
        exe 'xnoremap <buffer> <expr> <silent> ' . l:k_blank_up   . ' mode() ==# "\<C-V>" ? "d{P`[\<C-V>`]" : ":\<C-u>''<,''>m ''{-1\<CR>gvgv"'
        exe 'xnoremap <buffer> <expr> <silent> ' . l:k_blank_down . ' mode() ==# "\<C-V>" ? "d}P`[\<C-V>`]" : ":\<C-u>''<,''>m ''}\<CR>gvgv"'

        " 5. Page Window Jumps (H / L if mapped)
        if l:k_top_page !=# '<Nop>'
            exe 'xnoremap <buffer> <expr> <silent> ' . l:k_top_page . ' mode() ==# "\<C-V>" ? "dHP`[\<C-V>`]" : ":\<C-u>''<,''>m <C-R>=line(\"w0\")-1<CR>\<CR>gvgv"'
        endif
        if l:k_bottom_page !=# '<Nop>'
            exe 'xnoremap <buffer> <expr> <silent> ' . l:k_bottom_page . ' mode() ==# "\<C-V>" ? "dLP`[\<C-V>`]" : ":\<C-u>''<,''>m <C-R>=line(\"w$\")<CR>\<CR>gvgv"'
        endif

        " 6. Left / Right Indent and Block Shifts (h / l / < / >)
        exe 'xnoremap <buffer> <expr> <silent> ' . l:k_dedent . ' mode() ==# "\<C-V>" ? "dhP`[\<C-V>`]" : "<gv"'
        exe 'xnoremap <buffer> <expr> <silent> ' . l:k_indent . ' mode() ==# "\<C-V>" ? "dp`[\<C-V>`]" : ">gv"'
        " 7. Line Alignments / Block Edge Moves (H / L or 0 / $)
        exe 'xnoremap <buffer> <expr> <silent> ' . l:k_start_line . ' mode() ==# "\<C-V>" ? "d0P`[\<C-V>`]" : ":\<C-u>silent! ''<,''>left\<CR>gv"'
        exe 'xnoremap <buffer> <expr> <silent> ' . l:k_end_line   . ' mode() ==# "\<C-V>" ? "d$p`[\<C-V>`]" : ":\<C-u>call <SID>AlignRight()\<CR>"'

        " 8. Exit bindings
        exe 'xnoremap <buffer> <silent> ' . l:k_exit . ' <Cmd>call ToggleDragMode()<CR><Esc>'
        exe 'xnoremap <buffer> <silent> <C-c> <Cmd>call ToggleDragMode()<CR><C-c>'

        let b:drag_keys = [
                    \ l:k_down_one, l:k_up_one, 
                    \ l:k_down_lot, l:k_up_lot, 
                    \ l:k_dedent, l:k_indent, 
                    \ l:k_top_page, l:k_bottom_page, 
                    \ l:k_blank_up, l:k_blank_down, 
                    \ l:k_top_file, l:k_bottom_file, 
                    \ l:k_start_line, l:k_end_line,
                    \ l:k_exit, '<C-c>'
                    \ ]
    else
        let b:drag_active = 0
        for k in b:drag_keys
            if k !=# '<Nop>'
                silent! exec 'xunmap <buffer>' k
            endif
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