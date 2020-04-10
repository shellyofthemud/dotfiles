filetype indent on
set incsearch
set number
set relativenumber
set paste
set tabstop=4
set shiftwidth=4
syntax on

" This is still a WIP - might not finish this
function Changetabs()
	call inputsave()
	let l:inp = input("Set tab size to: ")
	call inputrestore()
	setlocal tabstop = l:inp
endfunction
