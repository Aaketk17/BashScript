# Analyzer

**An analyzer**  — whether built-in or custom — is just a package which contains three lower-level building blocks: 
 - character filters 
 - tokenizers
 - token filters

## 1. character filters

A character filter receives the original text as a stream of characters and can transform the stream by adding, removing, or changing characters. For instance, a character filter could be used to convert Hindu-Arabic numerals (٠‎١٢٣٤٥٦٧٨‎٩‎) into their Arabic-Latin equivalents (0123456789), or to strip HTML elements like <b> from the stream.

  - HTML Strip Character Filter
  - Mapping Character Filter
  - Pattern Replace Character Filter

 1. **HTML strip character filter**
 > Strips HTML elements from a text and replaces HTML entities with their decoded value (e.g, replaces &amp; with &).
 
 ```yaml
 GET /_analyze
{
  "tokenizer": "keyword",
  "char_filter": [
    "html_strip"
  ],
  "text": "<p>I&apos;m so <b>happy</b>!</p>"
}
 ```
 
 2. **Mapping Character Filter**
 > The mapping character filter accepts a map of keys and values. Whenever it encounters a string of characters that is the same as a key, it replaces      them with the value associated with that key.
 
 ```yaml
   GET /_analyze
  {
    "tokenizer": "keyword",
    "char_filter": [
      {
        "type": "mapping",
        "mappings": [
          "٠ => 0",
          "١ => 1",
          "٢ => 2",
          "٣ => 3",
          "٤ => 4",
          "٥ => 5",
          "٦ => 6",
          "٧ => 7",
          "٨ => 8",
          "٩ => 9"
        ]
      }
    ],
    "text": "My license plate is ٢٥٠١٥"
  }
 ```
 3. **Pattern Replace Character Filter**
 
 In this example, we configure the pattern_replace character filter to replace any embedded dashes in numbers with underscores, i.e 123-456-789 → 123_456_789:
 
 ```yaml
GET /_analyze
{
   "tokenizer": "keyword",
   "filter": [{
       "type": "pattern_replace",
       "pattern": "(\\d+)-(?=\\d)",
       "replacement": "$1_"
    }],
   "text": "My credit card is 123-456-789"
 }
 ```
 > ### Result
 > [ My, credit, card, is, 123_456_789 ]

An analyzer may have zero or more character filters, which are applied in order.
  
## 2. Tokenizer
A tokenizer receives a stream of characters, breaks it up into individual tokens (usually individual words), and outputs a stream of tokens. For instance, a whitespace tokenizer breaks text into tokens whenever it sees any whitespace. It would convert the text "Quick brown fox!" into the terms [Quick, brown, fox!].

The tokenizer is also responsible for recording the order or position of each term and the start and end character offsets of the original word which the term represents.
 
 [Types](https://www.elastic.co/guide/en/elasticsearch/reference/8.4/analysis-tokenizers.html) of tokenizer

An analyzer must have exactly one tokenizer.
  
## 3.Token filters
A token filter receives the token stream and may add, remove, or change tokens. For example, a lowercase token filter converts all tokens to lowercase, a stop token filter removes common words (stop words) like the from the token stream, and a synonym token filter introduces synonyms into the token stream.

Token filters are not allowed to change the position or character offsets of each token.

An analyzer may have zero or more token filters, which are applied in order.

[Types](https://www.elastic.co/guide/en/elasticsearch/reference/8.4/analysis-tokenfilters.html) of Token Filters 
 
  > without token filters
 ```yaml
 POST _analyze
{
  "analyzer": "whitespace",
  "text":     "The quick brown fox."
}
 ```
 > with `lowercase`, `asciifolding` token filters
 ```yaml
 POST _analyze
{
  "tokenizer": "standard",
  "filter":  [ "lowercase", "asciifolding" ],
  "text":      "Is this déja vu?"
}
 ```
  
## Built-in analyzers

- Standard Analyzer
  - The standard analyzer divides text into terms on word boundaries, as defined by the Unicode Text Segmentation algorithm. It removes most                 punctuation, lowercases terms, and supports removing stop words.
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
 
 
 
# Custom Analyzer
When the built-in analyzers do not fulfill your needs, you can create a custom analyzer which uses the appropriate combination of:

 - zero or more character filters
 - a tokenizer
 - zero or more token filters.
 
 ## Example 01
 
Character Filter
 - HTML Strip Character Filter
Tokenizer
 - Standard Tokenizer
Token Filters
 - Lowercase Token Filter
 - ASCII-Folding Token Filter
 
 ```yaml
 PUT my-index
{
  "settings": {
    "analysis": {
      "analyzer": {
        "my_custom_analyzer": {
          "type": "custom", 
          "tokenizer": "standard",
          "char_filter": [
            "html_strip"
          ],
          "filter": [
            "lowercase",
            "asciifolding"
          ]
        }
      }
    }
  }
}
 ```
 ```yaml
 POST my-index/_analyze
{
  "analyzer": "my_custom_analyzer",
  "text": "Is this <b>déjà vu</b>?"
}
 ```
 
 > ### output
 > [ is, this, deja, vu ]
 
The previous example used tokenizer, token filters, and character filters with their default configurations, but it is possible to create configured versions of each and to use them in a custom analyzer.
 
  ## complicated Example 02
 
Character Filter
 - Mapping Character Filter, configured to replace :) with _happy_ and :( with _sad_
Tokenizer
 - Pattern Tokenizer, configured to split on punctuation characters
Token Filters
 - Lowercase Token Filter
 - Stop Token Filter, configured to use the pre-defined list of English stop words
 
 ```yaml
 PUT my-index-1
{
  "settings": {
    "analysis": {
      "analyzer": {
        "my_custom_analyzer": { 
          "char_filter": [
            "emoticons"
          ],
          "tokenizer": "punctuation",
          "filter": [
            "lowercase",
            "english_stop"
          ]
        }
      },
      "tokenizer": {
        "punctuation": { 
          "type": "pattern",
          "pattern": "[ .,!?]"
        }
      },
      "char_filter": {
        "emoticons": { 
          "type": "mapping",
          "mappings": [
            ":) => _happy_",
            ":( => _sad_"
          ]
        }
      },
      "filter": {
        "english_stop": { 
          "type": "stop",
          "stopwords": "_english_"
        }
      }
    }
  }
}
 ```
 
 ```yaml
 POST my-index-1/_analyze
{
  "analyzer": "my_custom_analyzer",
  "text": "I'm a :) person, and you?"
}
 ```
 
 > ### output
 > [ i'm, _happy_, person, you ]
 
 - Assigns the index a default custom analyzer, my_custom_analyzer. This analyzer uses a custom tokenizer, character filter, and token filter that are   defined later in the request. This analyzer also omits the type parameter.

 - Defines the custom punctuation tokenizer.

 - Defines the custom emoticons character filter.

 - Defines the custom english_stop token filter.
 
