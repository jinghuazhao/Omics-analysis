-- div2rchunk.lua
local stringify = pandoc.utils and pandoc.utils.stringify

function Div(el)
  if el.classes:includes("sourceCode") then
    for _, blk in ipairs(el.content) do
      if blk.t == "CodeBlock" then
        -- Extract identifier for label
        local label = blk.attr.identifier or "unnamed_chunk"
        -- Build a new CodeBlock with proper knitr syntax
        local attr = pandoc.Attr("", {"r"}, { label = label })
        return pandoc.CodeBlock(blk.text, attr)
      end
    end
  end
  return nil
end
