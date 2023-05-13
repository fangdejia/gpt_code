function! gpt_api#SendToGPTAPI(txt)
    let api_key = g:openai_api_key
    let api_endpoint = g:openai_host . '/v1/chat/completions'
    let headers = "Content-Type: application/json\nAuthorization: Bearer " . api_key
    let payload = {"model": "gpt-3.5-turbo","messages": [{"role": "user", "content": "请帮我解析一下这段代码的意思:" . a:txt}]}
    let response = system('curl -s -X POST -H ' . shellescape(headers) . ' -d ' . shellescape(json_encode(payload)) . ' ' . shellescape(api_endpoint))
    "" 从 GPT API 响应中提取解析后的文本
    let response_data = json_decode(response)
    let parsed_text = response_data['choices'][0]['message']['content']
    return parsed_text
endfunction
