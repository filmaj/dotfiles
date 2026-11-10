; extends

; Eta templates: markup is HTML, code inside <% %> tags is JavaScript
((content) @injection.content
 (#set! injection.language "html")
 (#set! injection.combined))

((code) @injection.content
 (#set! injection.language "javascript")
 (#set! injection.combined))
