#!/bin/bash
# Run this from your assignment directory to generate all test files

# Boundary: empty file
> mywcempty.txt

# Boundary: only spaces
printf "      " > mywcspaces.txt

# Boundary: only newlines
printf "\n\n\n\n" > mywcnewlines.txt

# Boundary: single character (no newline)
printf "a" > mywcsinglechar.txt

# Boundary: only characters, no spaces or newlines
printf "helloworld" > mywccharsonly.txt

# Boundary: file ends without newline (mid-word at EOF)
printf "hello world" > mywcnonewline.txt

# Statement: multiple words on one line, ends with newline
printf "hello world\nfoo bar\nbaz\n" > mywcmultiword.txt

# Statement: tabs as whitespace (isspace catches tabs)
printf "hello\tworld\nfoo\tbar\n" > mywctabs.txt

# Statement: word followed by space mid-loop (triggers iInWord inside loop)
printf "word1 word2 word3\n" > mywcwordspace.txt

# Statement: mix of spaces, tabs, newlines, and words
printf "  hello   world\n\tfoo\t\tbar\n  \n" > mywcmix.txt

# Stress: large file, one word per line
python3 -c "
for i in range(1000):
    print('word' + str(i))
" > mywclargewords.txt

# Stress: large file, many words per line
python3 -c "
import random, string
for i in range(500):
    words = ' '.join(''.join(random.choices(string.ascii_lowercase, k=5)) for _ in range(10))
    print(words)
" > mywclargestandard.txt

# Stress: large file, very long lines, no newline at end
python3 -c "
s = ('abcde ' * 8000)[:49999]
print(s, end='')
" > mywclargestress.txt

echo "All test files created:"
ls mywc*.txt
