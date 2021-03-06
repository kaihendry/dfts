#!/bin/bash

words=./german

if ! test -s $words
then
	echo Please install words dictionary
	echo $words
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
	done < $words
	echo "CREATE INDEX words_index_1 ON words (word);"
	echo "COMMIT;"
) | sqlite3 --batch $DB

(
	echo "CREATE VIRTUAL TABLE wordsfts USING fts5(word);"
	echo "BEGIN;"
	while read w
	do
		echo "INSERT INTO wordsfts VALUES (\"$w\");"
	done < $words
	echo "COMMIT;"
) | sqlite3 --batch $DB
