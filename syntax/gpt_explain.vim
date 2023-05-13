" 清除任何现有的语法规则
syntax clear

" 定义一个名为 FunctionName 的自定义语法规则，用于匹配函数名的正则表达式
" 这里我们使用一个示例正则表达式，您可以根据需要修改
syntax match EnglishText /\w\+/

" 为 FunctionName 高亮组定义颜色
highlight EnglishText guifg=orange ctermfg=214
