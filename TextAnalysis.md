# Analyzer

**An analyzer**  — whether built-in or custom — is just a package which contains three lower-level building blocks: 
 - character filters 
 - tokenizers
 - token filters

## 1. character filters

A character filter receives the original text as a stream of characters and can transform the stream by adding, removing, or changing characters. For instance, a character filter could be used to convert Hindu-Arabic numerals (٠‎١٢٣٤٥٦٧٨‎٩‎) into their Arabic-Latin equivalents (0123456789), or to strip HTML elements like <b> from the stream.

An analyzer may have zero or more character filters, which are applied in order.
  
## 2. Tokenizer
A tokenizer receives a stream of characters, breaks it up into individual tokens (usually individual words), and outputs a stream of tokens. For instance, a whitespace tokenizer breaks text into tokens whenever it sees any whitespace. It would convert the text "Quick brown fox!" into the terms [Quick, brown, fox!].

The tokenizer is also responsible for recording the order or position of each term and the start and end character offsets of the original word which the term represents.

An analyzer must have exactly one tokenizer.
  
## 3.Token filters
A token filter receives the token stream and may add, remove, or change tokens. For example, a lowercase token filter converts all tokens to lowercase, a stop token filter removes common words (stop words) like the from the token stream, and a synonym token filter introduces synonyms into the token stream.

Token filters are not allowed to change the position or character offsets of each token.

An analyzer may have zero or more token filters, which are applied in order.
  
## Built-in analyzers

- Standard Analyzer
  - The standard analyzer divides text into terms on word boundaries, as defined by the Unicode Text Segmentation algorithm. It removes most punctuation,     lowercases terms, and supports removing stop words.

- Simple Analyzer
  - The simple analyzer divides text into terms whenever it encounters a character which is not a letter. It lowercases all terms.
- Whitespace Analyzer
  - The whitespace analyzer divides text into terms whenever it encounters any whitespace character. It does not lowercase terms.
- Stop Analyzer
  - The stop analyzer is like the simple analyzer, but also supports removal of stop words.
- Keyword Analyzer
  - The keyword analyzer is a “noop” analyzer that accepts whatever text it is given and outputs the exact same text as a single term.
- Pattern Analyzer
  - The pattern analyzer uses a regular expression to split the text into terms. It supports lower-casing and stop words.
- Language Analyzers
  - Elasticsearch provides many language-specific analyzers like english or french.
- Fingerprint Analyzer
  - The fingerprint analyzer is a specialist analyzer which creates a fingerprint which can be used for duplicate detection.
