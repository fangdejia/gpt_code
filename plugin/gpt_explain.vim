function! GetVisualSelection()
	let saved_reg = @"
	normal! gvy
	let selected_text = substitute(@" , '\%x00', '', 'g')
	let @" = saved_reg
	return selected_text
endfunction

function! OpenGPTBuffer()
	" 检查名为 'gpt_explanation' 的缓冲区是否已经存在
	let bufnr = bufnr('gpt_explanation')

	" 如果缓冲区不存在，则创建一个新的分割窗口和缓冲区
	if bufnr == -1
		" 分割窗口
		split gpt_explanation

		" 为新缓冲区设置名称
		exec 'file gpt_explanation'
	else
		" 如果缓冲区已经存在，找到与其关联的窗口
		let winnr = bufwinnr('gpt_explanation')
		" 如果找到了窗口，则激活它
		if winnr != -1
			exec winnr . 'wincmd w'
		else
			" 如果没有找到窗口，创建一个新的分割窗口并显示缓冲区
			split
			exec 'buffer' bufnr
		endif       " 如果缓冲区已经存在，将其显示在当前窗口
	endif
endfunction

function! GPTExplain()
    "代码解析
	echom "GPTExplain called"
	" 获取选中的文本
	let selected_text = GetVisualSelection()

    
	call OpenGPTBuffer()
	" 插入分割线，如果缓冲区非空
	call append(line('$'), '')
	call append(line('$'), repeat('-', winwidth(0)-10))
	call append(line('$'), '')
    " 逐行插入到当前缓冲区
	" 发送选中文本到 GPT API，获取响应（解析后的文本）
	let response = gpt_api#SendToGPTAPI(selected_text)
    let lines = split(response, '\n')
    for line in lines
        call append(line('$'), line)
    endfor
	normal! G
	
endfunction

function! AskGPT(question)
    "问题提问
	echom "AskGPT called"
	" 获取选中的文本
	let selected_text = GetVisualSelection()
    let q=a:question . ':' . selected_text 

	call OpenGPTBuffer()
	" 插入分割线，如果缓冲区非空
	call append(line('$'), '')
	call append(line('$'), repeat('-', winwidth(0)-10))
	call append(line('$'), '')
	call append(line('$'),q)
	call append(line('$'), '')
	call append(line('$'), repeat('-', winwidth(0)-10))
	call append(line('$'), '')
	normal! G

	let response = gpt_api#SendToGPTAPI(selected_text)
    let lines = split(response, '\n')
    for line in lines
        call append(line('$'), line)
    endfor
	normal! G
endfunction

vnoremap <leader>? :<C-u>call GPTExplain()<CR>
augroup GPTExplain
    autocmd!
	autocmd BufEnter gpt_explanation setlocal wrap
	autocmd BufEnter gpt_explanation setlocal textwidth=60
	autocmd BufEnter gpt_explanation setlocal syntax=gpt_explain
	autocmd BufEnter gpt_explanation resize 20
augroup END

