if exists('g:loaded_drag_selection')
    finish
endif
let g:loaded_drag_selection = 1

function! ToggleDragMode()
    if !exists('b:drag_active')
        let b:drag_active = 0
    endif

    if b:drag_active == 0
        let b:drag_active = 1
        xnoremap <buffer> <silent> j :m '>+1<CR>gvgv
        xnoremap <buffer> <silent> k :m '<-2<CR>gvgv
        xnoremap <buffer> <silent> J :m '>+10<CR>gvgv
        xnoremap <buffer> <silent> K :m '<-11<CR>gvgv
        xnoremap <buffer> <silent> gg :m 0<CR>gvgv
        xnoremap <buffer> <silent> G :m $<CR>gvgv
        xnoremap <buffer> <silent> h <gv
        xnoremap <buffer> <silent> { :m '{-1<CR>gvgv
        xnoremap <buffer> <silent> } :m '}<CR>gvgv
        xnoremap <buffer> <silent> l >gv
        xnoremap <buffer> <silent> <Esc> <Cmd>call ToggleDragMode()<CR><Esc>
        echo "-- DRAG MODE ON --"
    else
        let b:drag_active = 0
        " Changed nunmap to xunmap to match xnoremap
        for k in ['h','j','k','l','H','J','K','L','gg','G','{','}','<Esc>']
            silent! exec 'xunmap <buffer>' k
        endfor
        echo "-- DRAG MODE OFF --"
    endif
endfunction

xnoremap <silent> <leader>v <Cmd>call ToggleDragMode()<CR>