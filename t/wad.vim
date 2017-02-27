source plugin/wad.vim

describe 'WAD'
  before
    let g:wad_temp_dir = tempname()
    call mkdir(g:wad_temp_dir, "p") 
    let wad_init = wad#cmd() . " init"
    echomsg system(wad_init)
  end

  after
    %bwipeout
    call delete(g:wad_temp_dir, "rf")
  end

  describe 'cmd'
    context 'when g:wad_config_dir is not defined'
      it 'returns the wad command without the `config-file` flag'
        let cmd = wad#cmd()
	Expect cmd == "wad"
      end
    end

    context 'when g:wad_config_dir is defined'
      before
        let g:wad_config_dir = "/tmp/wad"
      end
      
      after
        unlet g:wad_config_dir
      end

      it 'returns the wad command with the `config-file` flag'
        Expect exists("g:wad_config_dir") == 1
        let cmd = wad#cmd()
	Expect cmd == "wad --config-dir=/tmp/wad"
      end
    end
  end

  describe 'progress'
    it 'displays the WAD progress'
      call wad#progress()
      let title = getline(2)
      Expect title =~ "DAY"
      Expect title =~ "WORDS"
      Expect title =~ "GOAL"
      Expect title =~ "STATUS"
    end

    it 'has a command'
      Expect exists(':WADProgress') to_be_true
    end

    it 'is mapped to <leader>wp'
      Expect hasmapto(":WADProgress<CR>") to_be_true
    end
  end

  describe 'files'
    it 'displays the WAD files'
      call wad#files()
      let title = getline(2)
      Expect title =~ "FILE"
      Expect title =~ "WORDS"
      Expect title =~ "LAST TRACKED ON"
    end

    it 'has a command'
      Expect exists(':WADFiles') to_be_true
    end

    it 'is mapped to <leader>wf'
      Expect hasmapto(":WADFiles<CR>") to_be_true
    end
  end

  describe 'track'
    before
      let g:wad_config_dir = g:wad_temp_dir
    end

    it 'tracks the current file'
      let temp_file = tempname()
      execute "new " . temp_file
      w 
      call wad#track()
      call wad#files()
      Expect getline(4) =~ temp_file
      call delete(temp_file, "rf")
    end

    it 'has a command'
      Expect exists(':WADTrack') to_be_true
    end

    it 'is mapped to <leader>wt'
      Expect hasmapto(":WADTrack<CR>") to_be_true
    end
  end

  describe 'buffer'
    context 'when `wad.wadw` does not exist'
      it 'opens a new buffer'
      	Expect bufexists('wad.wadw') to_be_false
	call wad#buffer()
      	Expect bufexists('wad.wadw') to_be_true
      end
    end

    context 'when `wad.wadw` exists'
      before
        execute "new wad.wadw"
      end

      it 'does not open a new buffer'
      	let windows_before = winnr('$')
	call wad#buffer()
      	Expect winnr('$') == windows_before
      end
    end

    context 'when `wad.wadw` window was quitted'
      before
        execute "new wad.wadw"
	:q
      end

      it 'reopens the window'
        Expect bufwinnr('wad.wadw') == -1
	call wad#buffer()
        Expect bufwinnr('wad.wadw') == 1
      end
    end
  end
end
