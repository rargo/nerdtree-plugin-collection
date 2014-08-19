if exists("g:loaded_nerdtree_ctrlp")
  finish
endif
let g:loaded_nerdtree_ctrlp = 1

call NERDTreeAddMenuItem({'text': '(p) ctrlp', 'shortcut': 'p', 'callback': 'NERDTreeCallCtrlp'})
"call NERDTreeAddKeyMap({
    "\ 'key': 'sh',
    "\ 'callback': 'NERDTreeCallSh',
    "\ 'quickhelpText': 'Call Shell Command' })

function! NERDTreeCallCtrlp()
	let currentNode = g:NERDTreeFileNode.GetSelected()

	let old_pwd = getcwd()
	let new_pwd = ""
    if !currentNode.path.isDirectory
		let new_pwd = GetFileDir(currentNode.path.str())
	else 
		let new_pwd = currentNode.path.str()
    endif
	execute "CtrlP " . new_pwd
endfunction
