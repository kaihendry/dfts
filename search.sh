# EXPLAIN QUERY PLAN


time sqlite3 words.sqlite <<HERE
select word from words where "word" like "${1:-for}%"
HERE

sleep 2

time sqlite3 words.sqlite <<HERE
SELECT word FROM wordsfts WHERE "word" MATCH "for*" ORDER BY rank;
HERE


