if exists("g:loaded_nerdtree_callsh_keymap")
  finish
endif
let g:loaded_nerdtree_callsh_keymap = 1

if !exists('g:callsh_cmd')
  "let g:callsh_cmd = "open -n -a 'iTerm' "  " windows (?)
  let g:callsh_cmd = ""
endif

call NERDTreeAddMenuItem({'text': '(s)hell', 'shortcut': 's', 'callback': 'NERDTreeCallSh'})
"call NERDTreeAddKeyMap({
    "\ 'key': 'sh',
    "\ 'callback': 'NERDTreeCallSh',
    "\ 'quickhelpText': 'Call Shell Command' })

function! NERDTreeCallSh()
	let currentNode = g:NERDTreeFileNode.GetSelected()
    let word_and_option = ""
	if currentNode.path.isDirectory
		let word_and_option = input("==========================================================\n".
					\ " Execute Shell\n" .
					\ " % will be replace as current directory\n" .
					\ " Current directory: " .  currentNode.path.str() . "\n" .
					\ "==========================================================\n".
					\ "Enter command:" .
					\ "")
	else
		let word_and_option = input("==========================================================\n".
					\ " Execute Shell\n" .
					\ " % will be replace as current file\n" .
					\ " Current file: " .  currentNode.path.str() . "\n" .
					\ "==========================================================\n".
					\ "Enter command:" .
					\ "")
	endif

    if word_and_option ==# ''
        call s:echo("Ack Aborted.")
        return
    endif

	let word_and_option_sub = substitute(word_and_option,"%",currentNode.path.str(),'g')
	let cmd = g:callsh_cmd . word_and_option_sub
	echo "\ncommand is: " . cmd

	let old_pwd = getcwd()
	let new_pwd = ""
    if !currentNode.path.isDirectory
		let new_pwd = HelperGetFileDir(currentNode.path.str())
		execute "cd " . new_pwd
	else 
		let new_pwd = currentNode.path.str()
		execute "cd " . new_pwd
    endif
	"echo getcwd()
	"try
		call system("cd " . new_pwd)
		cgetexpr system(cmd)
		call system("cd " . old_pwd)
		"refresh Current node, TODO:not work when delete file 
		execute "normal r"
		silent exec 'cwin'
	"catch /^Vim\%((\a\+)\)\=:/
		"echo v:exception
	"endtry
	execute "cd " . old_pwd
	"echo getcwd()
endfunction
