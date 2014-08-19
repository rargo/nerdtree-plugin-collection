if exists("g:loaded_nerdtree_mail_menuitem")
    finish
endif
let g:loaded_nerdtree_mail_menuitem = 1

call NERDTreeAddMenuItem({
            \ 'text': '(m)ail',
            \ 'shortcut': 'm',
            \ 'callback': 'NERDTreeMailFile',
            \ 'isActiveCallback': 'NERDTreeMailFileActive' })

function! NERDTreeMailFileActive()
    let node = g:NERDTreeFileNode.GetSelected()
    return !node.path.isDirectory
endfunction

function! NERDTreeMailFile()

endfunction
