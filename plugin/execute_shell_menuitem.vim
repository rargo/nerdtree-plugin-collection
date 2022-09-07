if exists("g:loaded_nerdtree_callsh_keymap")
  finish
endif
let g:loaded_nerdtree_callsh_keymap = 1

if !exists('g:callsh_cmd')
  "let g:callsh_cmd = "open -n -a 'iTerm' "  " windows (?)
  let g:callsh_cmd = ""
endif

call NERDTreeAddMenuItem({'text': '(e) execute shell command', 'shortcut': 'e', 'callback': 'NERDTreeCallSh'})
"call NERDTreeAddKeyMap({
    "\ 'key': 'sh',
    "\ 'callback': 'NERDTreeCallSh',
    "\ 'quickhelpText': 'Call Shell Command' })
"
func! GetFileDirAndName(filename)
	if a:filename == "%" "special,'%' means current file
		let current_file = getreg('%')
	else 
		let current_file = a:filename
	endif
	let last_slash = strridx(current_file, "/")
	if last_slash != -1
		let current_dir = strpart(current_file, 0, last_slash+1)
		let file = strpart(current_file, last_slash+1)
	else
		let current_dir = "./"
		let file = a:filename
	endif
	"echo current_dir
	return [current_dir,file]
endfunc

function! NERDTreeCallSh()
	let currentNode = g:NERDTreeFileNode.GetSelected()
    let word_and_option = ""
	if currentNode.path.isDirectory
		let word_and_option = input("==============================================================\n".
					\ " Execute Shell\n" .
					\ " % will be replace as current directory: \n  " . currentNode.path.str() . "\n" .
					\ "==============================================================\n".
					\ "Enter command:" .
					\ "")
	else
		let word_and_option = input("==============================================================\n".
					\ " Execute Shell\n" .
					\ " % will be replace as current file: \n  " .  currentNode.path.str() . "\n" .
					\ "==============================================================\n".
					\ "Enter command:" .
					\ "")
	endif

    if word_and_option ==# ''
        call s:echo("Ack Aborted.")
        return
    endif

	let word_and_option_sub = substitute(word_and_option,"%",currentNode.path.str(),'g')
	let cmd = g:callsh_cmd . word_and_option_sub
	"echo "\ncommand is: " . cmd

	let old_pwd = getcwd()
	let new_pwd = ""
    if !currentNode.path.isDirectory
		let new_pwd = GetFileDirAndName(currentNode.path.str())[0]
		execute "cd " . new_pwd
	else 
		let new_pwd = currentNode.path.str()
		execute "cd " . new_pwd
    endif
	call system("cd " . new_pwd)
	echo "\n\n"
	echo cmd
	echo "\n"
	"sleep one second
	let metadata = split(system(cmd),'\n')
	for m in metadata
		echo m
	endfor
	let p = input("\npress any key to continue")
	execute "normal r"
	execute "cd " . old_pwd
	"echo getcwd()
endfunction
