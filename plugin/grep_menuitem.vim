if exists("g:loaded_nerdtree_grep_menuitem")
    finish
endif
let g:loaded_nerdtree_grep_menuitem = 1

call NERDTreeAddMenuItem({
            \ 'text': '(g)rep',
            \ 'shortcut': 'g',
            \ 'callback': 'NERDTreeSearchFile',
            \ 'isActiveCallback': 'NERDTreeSearchFileActive' })

function! NERDTreeSearchFileActive()
    let node = g:NERDTreeFileNode.GetSelected()
    return node.path.isDirectory
endfunction

function! NERDTreeSearchFile()
        "exec ':vimgrep ' . cmd . ' ' . item . '/**/*.*'
    let treenode = g:NERDTreeFileNode.GetSelected()
    echo "==========================================================\n"
    let cwd = treenode.path.str({'escape': 0})
    let cmd = input('Grep Regex: ', '')
    if cmd != ''
		call setqflist([])
		execute 'cclose'
		let save_grepprg=&grepprg
		set grepprg=grep\ -n\ -R\ --exclude-dir=.git\ --exclude-dir=.svn
        exec "wincmd p"                     
        let to_run = "grep -r " . cmd . " \"" . cwd . "\""
		echo "Command is: " . to_run
        exec to_run
		set grepprg=save_grepprg
		execute "normal \<F4>"
		let qflist = getqflist()
		if len(qflist) > 1
			execute 'rightbelow cw'
		endif
		execute "normal \<cr>"
    else
        echo "Aborted"
    endif
endfunction
