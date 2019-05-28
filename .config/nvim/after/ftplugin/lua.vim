" LSP: https://github.com/Alloyed/lua-lsp

" from https://github.com/tpope/tpope/blob/master/.vimrc
setlocal includeexpr=substitute(v:fname,'\\.','/','g').'.lua'

setlocal omnifunc=lsp#complete

let b:printf_pattern = 'print(string.format("%s", %s))'
if fnamemodify(@%, ':p') =~# 'neovim'
  nnoremap <silent><buffer> <leader>log owrite_file('dbg.txt', require('inspect')(foo)..'\n', true, true)<esc>
else
  nnoremap <silent><buffer> <leader>log olocal flog=io.open('dbg.txt','wa+'); flog:write('xxx: '..tostring(line)..'\n'); flog:flush(); flog:close()<esc>
endif
