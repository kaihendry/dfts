sqlite3 words.sqlite <<HERE
EXPLAIN QUERY PLAN
select word, length from words where "word" like "$1%"
HERE

# not using USING INDEX words_index_1 ... why?
