(do (fn return {} (quote (lua "return"))) (fn map [f xs] (icollect [_ x (ipairs xs)] (f x))) (fn parse [str] (icollect [s (: str "gmatch" "%w%w")] (/ (tonumber s 16) 256))) (local colors {:aurora (map parse ["#BF616A" "#D08770" "#EBCB8B" "#A3BE8C" "#B48EAD"])
 :frost (map parse ["#8FBCBB" "#88C0D0" "#81A1C1" "#5E81AC"])
 :night (map parse ["#2E3440" "#3B4252" "#434C5E" "#4C566A"])
 :storm (map parse ["#D8DEE9" "#E5E9F0" "#ECEFF4"])}) (fn color [name alpha] (local k (tostring name)) (var j (. colors (: k "sub" 1 -2) (tonumber (: k "sub" -1 -1)))) (list (sym "values") (. j 1) (. j 2) (. j 3) (or alpha 1))) (fn func [self f] (if f (do (table.insert self f))) (quote (xero.func (unquote self)))) (fn definemod [pre f post] (if f (do (table.insert pre f))) (if post (do (each [_ v (ipairs post)] (table.insert pre v)))) (quote (xero.definemod (unquote pre)))) (fn node [pre f post] (if f (do (table.insert pre f))) (if post (do (each [_ v (ipairs post)] (table.insert pre v)))) (quote (xero.node (unquote pre)))) (fn export [symbol] (quote (tset xero (unquote (tostring symbol)) (unquote symbol)))) {:color color
 :definemod definemod
 :export export
 :func func
 :node node
 :return return})
