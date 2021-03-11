# Web [dmenu](https://tools.suckless.org/dmenu/)

	dmenu < /usr/share/dict/words

With the Web...

* https://twitter.com/simonw/status/1369298440895614976
* https://git.codemadness.nl/jscancer/file/datalist/example.html.html
* https://projects.verou.me/awesomplete/

# TODO

The DOM can't take thousands of options in the datalist. It's slow.

1. Perhaps limit sqlite LIKE query to at least 3 letters maybe
2. Do not do subsequent queries as letters are appended since there is no point, the UA already has the list to filter.
3. Do re-query if base 3 letters change
