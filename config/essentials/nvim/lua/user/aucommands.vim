" Absolute numbers if window isn't focused
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,WinEnter * if &nu | set rnu   | endif
  autocmd BufLeave,FocusLost,WinLeave   * if &nu | set nornu | endif
augroup END

" terminal specific layout
augroup neovim_terminal autocmd! 
	autocmd TermOpen * startinsert 
	autocmd TermOpen * :set nonumber norelativenumber signcolumn=no
	autocmd TermOpen * nnoremap <buffer> <C-c> i<C-c> 
augroup END

" Return to last edit position
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" Makes vim-commentary work
autocmd FileType dosini setlocal commentstring=#\ %s

funct! Filter(command)
    redir =>output
    silent exec a:command
    redir END
    let @o = output
    execute "put o"
	redraw!
    return ''
endfunct!

nnoremap <Leader>F :silent call Filter('g/')<left><Left>
