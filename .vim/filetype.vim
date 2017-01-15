"Check to see if the filetype was automagically identified by Vim
" (for ObjC)
" From: http://sg80bab.blogspot.com/2007/08/objective-c-syntax-in-gvim.html

if exists("did_load_filetypes")

    finish

else

    augroup filetypedetect

    au! BufRead,BufNewFile *.m       setfiletype objc

    augroup END
endif
