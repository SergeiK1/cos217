for f in *.txt; do
  ./sampledecomment < "$f" > out1 2> err1
  ./decomment       < "$f" > out2 2> err2

  if ! diff -q out1 out2 >/dev/null || ! diff -q err1 err2 >/dev/null; then
    echo "FAIL: $f"
    diff -y out1 out2 | head
    diff -y err1 err2 | head
    rm -f out1 out2 err1 err2
    exit 1
  fi
done

rm -f out1 out2 err1 err2
echo "PASS: all .txt"

