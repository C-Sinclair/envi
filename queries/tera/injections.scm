((script_element
  (raw_js_text) @injection.content)
 (#set! injection.language "javascript"))

((style_element
  (raw_css_text) @injection.content)
 (#set! injection.language "css"))
