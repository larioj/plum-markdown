# Plum Markdown

## Lets You Execute Blocks
```cat
foobar
```

## Configuration
```viml
let g:plum_markdown_actions = { 
    \ 'cat' : function('plum#markdown#ApplyBlockAsHeredoc') }
" add plum#markdown#Block() to g:plum_actions
```

## Files
-   autoload/plum/markdown.vim


