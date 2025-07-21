(do (local gsub string.gsub) (fn read [filename] (: (io.open filename) "read" "*a")) (fn _G.readlua [filename] (gsub (read (.. "build/" filename)) "\"" "'")) (fn _G.wrap [str] (.. "do end (function()
" str "
end)()
")) (fn build [infile outfile] (io.output (io.open outfile "w")) (local code (-> (.. "%}" (read infile) "{%") (gsub "\t" "  ") (gsub "%%%}
?" "io.write([=[") (gsub "[\t ]*%{%%" "]=])") (gsub "%}%}" ")..[=[") (gsub "%{%{" "]=]..(") (gsub "io%.write%(%[=%[%]=%]%)" "") loadstring assert)) (code)) (build "src/mods.xml.in" "lua/mods.xml") (build "src/splines.xml.in" "plugins/swap-except-there-are-splines.xml"))
