function! wad#cmd()
	let cmd = "wad"
	if exists("g:wad_config_dir")
		let cmd = cmd . " --config-dir=" . g:wad_config_dir
	end
	return cmd
endfunction

function! wad#progress()
	let cmd = wad#cmd() . " progress"

	call wad#buffer()
	setlocal buftype=nofile

	execute "normal! I" . system(cmd)
endfunction

function! wad#files()
	let cmd = wad#cmd() . " files"

	call wad#buffer()
	setlocal buftype=nofile

	execute "normal! I" . system(cmd)
endfunction

function! wad#track()
	let current_file = expand('%:p')
	let cmd = wad#cmd() . " track " . current_file

	echomsg system(cmd)
endfunction

function! wad#buffer()
	if(bufexists('wad.wadw'))
		let wadwin = bufwinnr('wad.wadw')
		if (wadwin == -1)
			execute "sbuffer " . bufnr('wad.wadw')
		end
	else
		execute "new wad.wadw"
	end
endfunction

command! WADProgress call wad#progress()
command! WADFiles call wad#files()
command! WADTrack call wad#track()

nnoremap <leader>wp :WADProgress<CR>
nnoremap <leader>wf :WADFiles<CR>
nnoremap <leader>wt :WADTrack<CR>
