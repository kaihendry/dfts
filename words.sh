#!/bin/bash

if ! test -s /usr/share/dict/words
then
	echo Please install words dictionary
	echo /usr/share/dict/words
	exit 1
fi

DB=words.sqlite

rm -f $DB
(
	echo "CREATE TABLE words (word varchar, length int);"
	echo "BEGIN;"
	while read w
	do
		echo "INSERT INTO words VALUES (\"$w\", length(\"$w\"));"
	done < /usr/share/dict/words
	echo "CREATE INDEX words_index_1 ON words (word);"
	echo "COMMIT;"
) | sqlite3 --batch $DB
