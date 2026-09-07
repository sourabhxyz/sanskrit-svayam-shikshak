#!/bin/zsh
# Build the corrected edition of "संस्कृत स्वयं-शिक्षक" from the Markdown
# sources in corrected/. Produces build/sanskrit-svayam-shikshak.{md,html,epub,pdf}.
# Requires pandoc (https://pandoc.org) and, for the PDF, typst (https://typst.app).
set -e
cd "$(dirname "$0")"
mkdir -p build

order=(
  corrected/00-parichay.md
  corrected/01-prastavana.md
  corrected/02-varnamala.md
)
# Part 1: lessons 1–50
for i in $(seq -f "%02g" 1 50); do order+=(corrected/bhag1-paath-$i.md); done
# Part 2: pronunciation chapter, then lessons 1–59
order+=(corrected/bhag2-00-moolakshar.md)
for i in $(seq -f "%02g" 1 59); do order+=(corrected/bhag2-paath-$i.md); done

out=build/sanskrit-svayam-shikshak.md
{
  echo "---"
  echo "title: संस्कृत स्वयं-शिक्षक"
  echo "subtitle: संशोधित संस्करण"
  echo "author: पं. श्रीपाद दामोदर सातवलेकर"
  echo "lang: hi"
  echo "---"
  echo
  echo "# प्रथम भाग"
  echo
  n=0
  for f in "${order[@]}"; do
    n=$((n+1))
    [ "$f" = corrected/bhag2-00-moolakshar.md ] && { echo; echo "# द्वितीय भाग"; echo; }
    # Part-1 and Part-2 lessons share heading text ("पाठ N"); make them distinct.
    case $f in
      corrected/bhag1-paath-*) sed '1s/^# पाठ /# प्रथम भाग, पाठ /' "$f" ;;
      corrected/bhag2-paath-*) sed '1s/^# पाठ /# द्वितीय भाग, पाठ /' "$f" ;;
      # Part 2 opens with its own book-title heading; the part heading above replaces it.
      corrected/bhag2-00-moolakshar.md) sed '1{/^# संस्कृत स्वयं-शिक्षक/d;}' "$f" ;;
      *) cat "$f" ;;
    esac
    echo
    echo
  done
  echo
  echo "# शुद्धि-पत्र"
  echo
  tail -n +2 errata.md
} > "$out"

# Footnote labels ([^1] etc.) repeat across lessons; pandoc needs them unique
# within one document, so rewrite them per lesson. In lessons that reference the
# same note twice (the Sanskrit word and its Hindi gloss both carry the number),
# pandoc would duplicate the note, so those lessons use plain superscripts (^n^)
# and a numbered gloss list instead.
python3 - "$out" <<'PY'
import re, sys
p = sys.argv[1]
text = open(p, encoding="utf-8").read()
blocks = re.split(r"(?m)^(?=# )", text)
ref = re.compile(r"\[\^(\w+)\](?!:)")
out = []
for i, b in enumerate(blocks):
    refs = ref.findall(b)
    if len(refs) != len(set(refs)):
        b = re.sub(r"(?m)^\[\^(\w+)\]:\s*", lambda m: "\n^%s^ " % m.group(1), b)
        b = ref.sub(lambda m: "^%s^" % m.group(1), b)
    else:
        b = re.sub(r"\[\^(\w+)\]", lambda m: "[^%d-%s]" % (i, m.group(1)), b)
    out.append(b)
open(p, "w", encoding="utf-8").write("".join(out))
PY

css=build/style.css
cat > "$css" <<'CSS'
body { font-family: "Noto Serif Devanagari", "Kohinoor Devanagari", "Devanagari MT", "Mangal", serif;
       max-width: 46em; margin: 2em auto; padding: 0 1em; line-height: 1.7; font-size: 1.1em; }
h1 { border-bottom: 2px solid #999; padding-bottom: .2em; margin-top: 2.5em; }
table { border-collapse: collapse; margin: 1em 0; }
td, th { padding: .2em .9em; vertical-align: top; border-bottom: 1px solid #ddd; }
strong { font-weight: 700; }
CSS

pandoc "$out" -f markdown -t html5 --standalone --toc --toc-depth=1 \
  --css "$css" --embed-resources --metadata title="संस्कृत स्वयं-शिक्षक" \
  -o build/sanskrit-svayam-shikshak.html
pandoc "$out" -f markdown -t epub3 --toc --toc-depth=1 --css "$css" \
  --metadata title="संस्कृत स्वयं-शिक्षक" -o build/sanskrit-svayam-shikshak.epub

# PDF: pandoc -> Typst source -> typst. The bundled Noto Serif Devanagari
# (fonts/, OFL) is used so the output is identical on every machine.
if command -v typst >/dev/null; then
  pandoc "$out" -f markdown -t typst --template=book.typst --toc --toc-depth=1 \
    --wrap=none -o build/sanskrit-svayam-shikshak.typ
  # - pandoc leaves a leading "= " in table cells unescaped, which Typst reads
  #   as a heading marker (e.g. the sandhi tables' "= वसिष्ठाश्रमः" cells);
  # - tables are set flush left rather than centred;
  # - lesson headings drop the "प्रथम भाग, " prefix (the part is shown in the
  #   running head instead).
  sed -i '' -e 's/\[= /[\\= /g' \
    -e 's/^  align(center)\[#table(/  align(left)[#table(/' \
    -e 's/^= प्रथम भाग, पाठ /= पाठ /' -e 's/^= द्वितीय भाग, पाठ /= पाठ /' \
    build/sanskrit-svayam-shikshak.typ
  typst compile --font-path fonts build/sanskrit-svayam-shikshak.typ \
    build/sanskrit-svayam-shikshak.pdf
else
  echo "typst not found; skipping PDF" >&2
fi
echo "Built:"; ls -la build/sanskrit-svayam-shikshak.*
