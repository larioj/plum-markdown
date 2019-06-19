function! plum#markdown#Block()
  return plum#CreateAction(
        \ 'plum#markdown#Block',
        \ function('plum#markdown#IsBlock'),
        \ function('plum#markdown#ApplyBlock'))
endfunction

function! plum#markdown#IsBlock(context)
  let context = a:context
  if context.mode !=# 'n' && context.mode !=# 'i'
    return 0
  endif
  let curline = getline(line('.'))
  if strpart(curline, 0, 3) !=# '```'
    return 0
  endif
  "TODO(larioj): support older vim versions
  let syntax = trim(strpart(curline, 3))
  let actions = get(g:, 'plum_markdown_actions', {})
  if !has_key(actions, syntax)
    return 0
  endif
  let start = line('.') + 1
  let max = line('$')
  let cur = start
  while cur <= max
    if trim(getline(cur)) ==# '```'
      break
    endif
    let cur = cur + 1
  endwhile
  if cur > max
    return 0
  endif
  let end = cur - 1
  if end < start
    return 0
  endif
  let match = join(getline(start, end))
  let context.syntax = syntax
  let context.match = match
  return 1
endfunction

function! plum#markdown#ApplyBlock(context)
  let context = a:context
  let actions = get(g:, 'plum_markdown_actions', {})
  let action = actions[context.syntax]
  return action(context)
endfunction

function! plum#markdown#ApplyBlockAsHeredoc(context)
  let context = a:context
  let start = context.syntax . " <<'EOF'\n"
  let end = "EOF\n"
  let context.match = start . context.match . end
  call plum#term#SmartTerminal().apply(context)
endfunction
