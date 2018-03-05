# JP_address_searcher

## How to use

(checked: ruby 2.2.4)

put on KEN_ALL.CSV (from http://www.post.japanpost.jp/zipcode/dl/kogaki/zip/ken_all.zip )

execute at console

`ruby encode_win31j_to_utf8.rb KEN_ALL.CSV` => create KEN_ALL_UTF8.CSV

`ruby create_inddex.rb` (set same dir : KEN_ALL_UTF8.CSV) => address.csv + index/**.csv

`ruby search_address.rb`

```
$> ruby search_address.rb
search words => 渋谷       ## <= $STDIN (input from keybord)
#=> any result
```
