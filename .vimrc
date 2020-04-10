filetype indent on
set incsearch
set number
set relativenumber
set paste

function changetabs(size)
  let newsize=a:size
  setlocal tabstop=newsize
endfunction

function changetabswrapper()
  call inputsave()
  let a:inp = input("Set tab size to: ")
  call inputrestore()
  call changetabs(a:inp)
endfunction
