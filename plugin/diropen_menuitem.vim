if exists("g:loaded_nerdtree_open_file_directory")
    finish
endif
let g:loaded_nerdtree_open_file_directory = 1
let s:haskdeinit = system("ps -e") =~ 'kdeinit'
let s:hasdarwin = system("uname -s") =~ 'Darwin'
let s:hascygwin = system("uname -s") =~ "CYGWIN.*"

call NERDTreeAddMenuItem({
            \ 'text': "(I) open node's directory",
            \ 'shortcut': 'i',
            \ 'callback': 'NERDTreeFileDirectory',
            \ 'isActiveCallback': 'NERDTreeFileDirectoryActive' })

function! NERDTreeFileDirectoryActive()
    "let node = g:NERDTreeFileNode.GetSelected()
    "return !node.path.isDirectory
	return 1
endfunction

func! HelperGetFileDir(filename)
	if a:filename == "%" "special,'%' means current file
		let current_file = getreg('%')
	else 
		let current_file = a:filename
	endif

	if isdirectory(filename)
		return current_file
	endif

	let last_slash = strridx(current_file, "/")
	if last_slash != -1
		let current_dir = strpart(current_file, 0, last_slash+1)
	else
		let current_dir = "./"
	endif
	"echo current_dir
	return current_dir
endfunc

function! NERDTreeFileDirectory()
  let node = g:NERDTreeFileNode.GetSelected()
  let path = node.path.str()
  "echom "path is "
  "echom  path

  "let dir = GetFileDir(path)
  let dir = HelperGetFileDir(path)
  "echom "dir is "
  "echom dir

  if has("gui_running")
    let args = dir ." &"
  else
    let args = dir ." > /dev/null"
  end

  if s:hascygwin == 1
    "exe "silent !start explorer ".shellescape(path,1)
    exe "silent !cmd /c start cygstart ".dir
  elseif has("unix") && executable("gnome-open") && !s:haskdeinit
    exe "silent !gnome-open ".args
    let ret= v:shell_error
  elseif has("unix") && executable("kde-open") && s:haskdeinit
    exe "silent !kde-open ".args
    let ret= v:shell_error
  elseif has("unix") && executable("open") && s:hasdarwin
    exe "silent !open ".args
    let ret= v:shell_error
  elseif has("win32") || has("win64")
    "exe "silent !start explorer ".shellescape(path,1)
    exe "silent !start explorer ".dir
  end
  redraw!

endfunction
