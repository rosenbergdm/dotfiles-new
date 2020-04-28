if exists("david_did_load_filetypes")
  finish
endif
let david_did_load_filetypes = 1

augroup filetypedetect
  au! BufRead,BufNewFile *.sh     setfiletype sh
  au! BufRead,BufNewFile *.hs     setfiletype haskell
  au! BufRead,BufNewFile *.hs     call Map_for_haskell()
augroup END
