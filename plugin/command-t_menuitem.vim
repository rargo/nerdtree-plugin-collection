if exists("g:loaded_nerdtree_commandt")
  finish
endif
let g:loaded_nerdtree_commandt = 1

call NERDTreeAddMenuItem({'text': '(t) CommandT', 'shortcut': 't', 'callback': 'NERDTreeCallCommandT'})

function! NERDTreeCallCommandT()
	let currentNode = g:NERDTreeFileNode.GetSelected()

	let old_pwd = getcwd()
	let new_pwd = ""
    if !currentNode.path.isDirectory
		let new_pwd = HelperGetFileDir(currentNode.path.str())
	else 
		let new_pwd = currentNode.path.str()
    endif
	execute "cd " . new_pwd
	try
		execute "CommandT"
	catch

	endtry
	execute "cd " . old_pwd
endfunction
