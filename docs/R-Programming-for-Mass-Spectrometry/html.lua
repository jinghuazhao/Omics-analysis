-- div2rchunk.lua
-- Safely access stringify (may need require based on Pandoc build)
local stringify = pandoc.utils and pandoc.utils.stringify

function Div(el)
  -- Target divs with class "sourceCode"
  if el.classes:includes("sourceCode") then
    for _, block in ipairs(el.content) do
      if block.t == "CodeBlock" then
        -- Use the <div id="..."> as chunk label
        local label = el.identifier or "unnamed_chunk"
        -- Format as knitr R chunk
        local attr = pandoc.Attr("", {"r"}, {label = label})
        return pandoc.CodeBlock(block.text, attr)
      end
    end
  end
end
