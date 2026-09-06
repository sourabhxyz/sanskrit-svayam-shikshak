# संस्कृत स्वयं-शिक्षक — संशोधित संस्करण

A corrected transcription of **संस्कृत स्वयं-शिक्षक** (*Sanskrit Svayam Shikshak*) by Pt. Shripad Damodar Satvalekar, the Hindi-medium Sanskrit self-teacher, prepared from the scanned 2016 Rajpal & Sons printing (`Sanskrit Svayam Shikshak - S D Satvalekar.pdf`).

Every page of the scan was OCR'd and then proofread by eye against the page image, and the finished edition was then read once more from beginning to end for sense and continuity between lessons. Typographical errors, wrong verb/noun forms, dropped anusvāras and visargas, misnumbered footnotes and wrong cross-references have been corrected. Substantive corrections are recorded in `errata.md`.

## Layout

| Path | Contents |
|---|---|
| `corrected/00-parichay.md` | लेखक-परिचय |
| `corrected/01-prastavana.md` | प्रस्तावना |
| `corrected/02-varnamala.md` | अक्षर / वर्णमाला |
| `corrected/bhag1-paath-01.md` … `bhag1-paath-50.md` | Part 1, lessons 1–50 |
| `corrected/bhag2-00-moolakshar.md` | मूलाक्षर-व्यवस्था (pronunciation chapter opening Part 2) |
| `corrected/bhag2-paath-01.md` … `bhag2-paath-59.md` | Part 2, lessons 1–59 |
| `errata.md` | शुद्धि-पत्र: table of substantive corrections, keyed to the printed page numbers |
| `build.sh` | Builds a single Markdown file, an HTML file and an EPUB into `build/` (needs pandoc) |

## Conventions used in the text

- Lesson headings are `# पाठ N`. Sanskrit text is set in **bold**; Hindi is plain.
- Vocabulary lines are `**शब्द** = अर्थ`. Verb entries follow the book's pattern `**धातु** (Dhātupāṭha gloss) = Hindi – forms`.
- Paradigms are three-column tables (singular, dual, plural); `"` stands for "same as above".
- Sandhi splits and glosses that the book prints as footnotes are Markdown footnotes (`[^n]`); numbering restarts in every lesson.
- The scan's inconsistent spellings have been normalised silently: chandrabindu is written where standard Hindi has it (कहाँ, हूँ, गाँव), the ब/व confusion of the print is resolved (पिबति, बाग़, बुद्धि, बिभेति), nukta is used for Urdu-derived words (ख़रीदना, ज़रूर), and conjuncts are written in their standard form (ह्ण, ष्ठ, ङ्क्ष). These normalisations are not listed in the errata.
- Where the printing dropped a heading (e.g. Part 2, lesson 49) or cut off a word at the page edge, the missing text has been supplied and noted in the errata.
- Two things Part 2 refers back to but this printing never contained, a diagram of the five places of articulation and a note on pronouncing ऋ/ऌ, have been added to the अक्षर chapter. Early lessons that use words before introducing them now carry a short 'नये शब्द' gloss. The preface's reading instructions were reworded for the combined two-part edition.

## Building

```sh
./build.sh
```

produces `build/sanskrit-svayam-shikshak.md`, `.html` (self-contained, with a Devanagari font stack) and `.epub`. Only pandoc and python3 are required.

## Errata

`errata.md` lists each correction as *page – original – corrected – note*, using the printed page numbers of the original. Pure OCR artefacts and the silent normalisations listed above are not included.

## Copyright

The original work is by Pt. S. D. Satvalekar (1867–1968). This transcription was prepared for personal study from a copy of the printed book; check the copyright status of the text in your jurisdiction before redistributing it.
