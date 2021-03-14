# select word, length from words where "word" like "$1%"
sqlite3 words.sqlite <<HERE
EXPLAIN QUERY PLAN
select word from words where "word" like "${1:-for}%"
HERE

# not using USING INDEX words_index_1 ... why?
