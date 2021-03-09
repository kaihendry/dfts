#!/bin/bash

DB=words.sqlite

rm -f $DB
(
	echo "CREATE TABLE words (word varchar, length int);"
	echo "BEGIN;"
	while read w
	do
		echo "INSERT INTO words VALUES (\"$w\", length(\"$w\"));"
	done < british-english
	echo "CREATE INDEX words_index_1 ON words (word);"
	echo "COMMIT;"
) | sqlite3 --batch $DB
