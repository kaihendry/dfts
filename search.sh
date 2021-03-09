# EXPLAIN QUERY PLAN
sqlite3 words.sqlite <<-HERE
select word, length from words where "word" = "$1"
HERE
