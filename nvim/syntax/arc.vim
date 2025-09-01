" Vim syntax file for .arc files (Architect Serverless Framework)
" Language: Arc
" Maintainer: @filmaj

if exists("b:current_syntax")
  finish
endif

" Comments (both full line and inline)
syn match arcComment "#.*$" contains=@Spell
highlight link arcComment Comment

" Pragmas (sections starting with @)
syn match arcPragma "^@[a-zA-Z][a-zA-Z0-9_-]*\>"
highlight link arcPragma Special

" Invalid pragma syntax - catches common mistakes
syn match arcInvalidPragma "^@[0-9]\|^@-\|^@_\|^@.*[&*%$@!+|^<>{}[\]()]"
highlight link arcInvalidPragma Error

" String values (quoted strings)
syn region arcString start='"' end='"' skip='\\"' contains=@Spell
syn region arcString start="'" end="'" skip="\\'" contains=@Spell
highlight link arcString String

" Numbers (only standalone values, not part of identifiers)
syn match arcNumber "\(^\|\s\)\@<=\d\+\(\s\|$\)\@="
syn match arcNumber "\(^\|\s\)\@<=\d\+\.\d\+\(\s\|$\)\@="
" Negative numbers
syn match arcNumber "\(^\|\s\)\@<=-\d\+\(\s\|$\)\@="
syn match arcNumber "\(^\|\s\)\@<=-\d\+\.\d\+\(\s\|$\)\@="
highlight link arcNumber Number

" Booleans
syn keyword arcBoolean true false
highlight link arcBoolean Boolean

" Note: All pragmas are handled by arcPragma pattern above

" HTTP methods
syn keyword arcHttpMethod get post put patch delete head options
highlight link arcHttpMethod Type

" AWS-specific keywords (only in @aws context)
syn match arcAwsKeyword "^\s\+\(profile\|region\|bucket\)\>"
highlight link arcAwsKeyword Identifier

" DynamoDB table attributes (partition and sort keys)
syn match arcPartitionKey "\*[A-Z][a-zA-Z]*\>"
syn match arcSortKey "\*\*[A-Z][a-zA-Z]*\>"
syn keyword arcTableType String Number Boolean TTL
highlight link arcPartitionKey Special
highlight link arcSortKey Keyword
highlight link arcTableType Type

" Route paths (starting with /)
syn match arcRoute "^\s*/\S*"
highlight link arcRoute Constant

" Indentation significance - structural highlighting
" 2-space indentation: vector names and map keys
syn match arcVector2Space "^  [a-zA-Z][a-zA-Z0-9_-]*\s*$"
syn match arcMapKey "^  [a-zA-Z][a-zA-Z0-9_-]*\s\+"
" 4-space indentation: nested vector values in maps  
syn match arcVector4Space "^    [a-zA-Z0-9][a-zA-Z0-9_.-]*"
highlight link arcVector2Space Function
highlight link arcMapKey Function  
highlight link arcVector4Space Identifier

" Rate expressions for scheduled functions
syn match arcRate "rate(\d\+\s\+\w\+)"
highlight link arcRate Special

" Cron expressions
syn match arcCron "cron(\S\+)"
highlight link arcCron Special

" Reserved characters - these should only appear in quoted strings
syn match arcReservedChar "[{}[\]<>]"
highlight link arcReservedChar Error

let b:current_syntax = "arc"
