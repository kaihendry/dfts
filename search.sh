# select word, length from words where "word" like "$1%"
sqlite3 words.sqlite <<HERE
SELECT word FROM words where "word" like "wa%"
HERE

# not using USING INDEX words_index_1 ... why?