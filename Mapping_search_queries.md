# Mapping

### M1: syntax for index the document
```yaml
POST Enter-name-of-the-index/_doc
{
  "field": "value"
}
```

### M2: Example

```yaml
POST temp_index/_doc
{
  "name": "Pineapple",
  "botanical_name": "Ananas comosus",
  "produce_type": "Fruit",
  "country_of_origin": "New Zealand",
  "date_purchased": "2020-06-02T12:15:35",
  "quantity": 200,
  "unit_price": 3.11,
  "description": "a large juicy tropical fruit consisting of aromatic edible yellow flesh surrounded by a tough segmented skin and topped with a tuft of stiff leaves.These pineapples are sourced from New Zealand.",
  "vendor_details": {
    "vendor": "Tropical Fruit Growers of New Zealand",
    "main_contact": "Hugh Rose",
    "vendor_location": "Whangarei, New Zealand",
    "preferred_vendor": true
  }
}
```
### M3: Syntax for view mapping
```yaml
GET Enter_name_of_the_index_here/_mapping
```
### M4: Example
```yaml
GET temp_index/_mapping
```
### M5: Exercise
```yaml
POST test_index/_doc
{
  "name": "Pineapple",
  "botanical_name": "Ananas comosus",
  "produce_type": "Fruit",
  "country_of_origin": "New Zealand",
  "date_purchased": "2020-06-02T12:15:35",
  "quantity": 200,
  "unit_price": 3.11,
  "description": "a large juicy tropical fruit consisting of aromatic edible yellow flesh surrounded by a tough segmented skin and topped with a tuft of stiff leaves.These pineapples are sourced from New Zealand.",
  "vendor_details": {
    "vendor": "Tropical Fruit Growers of New Zealand",
    "main_contact": "Hugh Rose",
    "vendor_location": "Whangarei, New Zealand",
    "preferred_vendor": true
  }
}
```
### M6: get mapping of test_index
```yaml
GET test_index/_mapping
```

### M7: Edit mapping as per requirement
```yaml
PUT produce_index
{
  "mappings": {
    "properties": {
      "botanical_name": {
        "enabled": false - when you don’t need to query or run aggregations,only store
      },
      "country_of_origin": {
        "type": "text",
        "fields": {
          "keyword": {
            "type": "keyword"
          }
        }
      },
      "date_purchased": {
        "type": "date"
      },
      "description": {
        "type": "text"
      },
      "name": {
        "type": "text"
      },
      "produce_type": {
        "type": "keyword"
      },
      "quantity": {
        "type": "long"
      },
      "unit_price": {
        "type": "float"
      },
      "vendor_details": {
        "enabled": false
      }
    }
  }
}
```
### M8: get mapping of produce index
```yaml
GET produce_index/_mapping
```

### M9: Indexing two more date in produce index
```yaml
POST produce_index/_doc
{
  "name": "Pineapple",
  "botanical_name": "Ananas comosus",
  "produce_type": "Fruit",
  "country_of_origin": "New Zealand",
  "date_purchased": "2020-06-02T12:15:35",
  "quantity": 200,
  "unit_price": 3.11,
  "description": "a large juicy tropical fruit consisting of aromatic edible yellow flesh surrounded by a tough segmented skin and topped with a tuft of stiff leaves.These pineapples are sourced from New Zealand.",
  "vendor_details": {
    "vendor": "Tropical Fruit Growers of New Zealand",
    "main_contact": "Hugh Rose",
    "vendor_location": "Whangarei, New Zealand",
    "preferred_vendor": true
  }
}
```

### M10: Indexing two more date in produce index
```yaml
POST produce_index/_doc
{
  "name": "Mango",
  "botanical_name": "Harum Manis",
  "produce_type": "Fruit",
  "country_of_origin": "Indonesia",
  "organic": true,
  "date_purchased": "2020-05-02T07:15:35",
  "quantity": 500,
  "unit_price": 1.5,
  "description": "Mango Arumanis or Harum Manis is originated from East Java. Arumanis means harum dan manis or fragrant and sweet just like its taste. The ripe Mango Arumanis has dark green skin coated with thin grayish natural wax. The flesh is deep yellow, thick, and soft with little to no fiber. Mango Arumanis is best eaten when ripe.",
  "vendor_details": {
    "vendor": "Ayra Shezan Trading",
    "main_contact": "Suharto",
    "vendor_location": "Binjai, Indonesia",
    "preferred_vendor": true
  }
}
```



### What if we want to make changes to the mapping of an existing field ?
 - We can’t change it …. So then How to do that ???.......**reindex**


### M11: Create new desired mapping
```yaml
PUT produce_v2
{
  "mappings": {
    "properties": {
      "botanical_name": {
        "type": "text"
      },
      "country_of_origin": {
        "type": "text",
        "fields": {
          "keyword": {
            "type": "keyword",
            "ignore_above": 256
          }
        }
      },
      "date_purchased": {
        "type": "date"
      },
      "description": {
        "type": "text"
      },
      "name": {
        "type": "text"
      },
      "organic": {
        "type": "boolean"
      },
      "produce_type": {
        "type": "keyword"
      },
      "quantity": {
        "type": "long"
      },
      "unit_price": {
        "type": "float"
      },
      "vendor_details": {
        "type": "object",
        "enabled": false
      }
    }
  }
}
```

### M12: Create new desired mapping
```yaml
POST _reindex
{
  "source": {
    "index": "produce_index"
  },
  "dest": {
    "index": "produce_v2"
  }
}
```
### M13: delete the old index
```yaml
DELETE produce_index
```

### M14: reindex again
```yaml
POST _reindex
{
  "source": {
    "index": "produce_v2”
  },
  "dest": {
    "index": "produce_index"
  }
}
```

# Search for Data

- There are two main ways to search in Elasticsearch:
  - **Queries**: retrieve documents that match the specified criteria.
  - **Aggregations**: present the summary of your data as metrics, statistics, and other analytics.


### S1: Syntax - Retrieve all document from index
```yaml
GET name _of_index/_search
```

### S2: Example - Retrieve all document from index
```yaml
GET news_headline/_search
```

### S3: Syntax - Get the exact total number of hits

> To improve the response speed on large datasets, Elasticsearch limits the total count to 10,000 by default. 
  If you want the exact total number of hits, use the following query.

```yaml
GET enter_name_of_the_index_here/_search
{
  "track_total_hits": true
}
```


### S4: Example - Get the exact total number of hits

```yaml
GET news_headlines/_search
{
  "track_total_hits": true
}
```

### S5: Syntax - Search for data within a specific time range
```yaml
GET enter_name_of_the_index_here/_search
{
  "query": {
    "Specify the type of query here": {
      "Enter name of the field here": {
        "gte": "Enter lowest value of the range here",
        "lte": "Enter highest value of the range here"
      }
    }
  }
}
```

### S6: Example - Search for data within a specific time range
```yaml
GET news_headlines/_search
{
  "query": {
    "range": {
      "date": {
        "gte": "2015-06-20",
        "lte": "2015-09-22"
      }
    }
  }
}
```

### S7: Syntax - Searching for phrases using the match_phrase query
```yaml
GET Enter_name_of_index_here/_search
{
  "query": {
    "match_phrase": {
      "Specify the field you want to search": {
        "query": "Enter search terms"
      }
    }
  }
}
```

### S8: Example - Searching for phrases using the match_phrase query
```yaml
GET news_headlines/_search
{
  "query": {
    "match_phrase": {
      "headline": {
        "query": "Shape of You"
      }
    }
  }
}
```
- When the match_phrase parameter is used, all hits must meet the following criteria:
  - the search terms "Shape", "of", and "you" must appear in the field headline .
  - the terms must appear in that order.
  - the terms must appear next to each other.

```yaml
GET news_headlines/_search
{
  "query": {
    "match": {
      "headline": {
        "query": "Shape of You"
      }
    }
  }
}
```

### S9: Syntax - Running a match query against multiple fields
```yaml
GET Enter_the_name_of_the_index_here/_search
{
  "query": {
    "multi_match": {
      "query": "Enter search terms here",
      "fields": [
        "List the field you want to search over",
        "List the field you want to search over",
        "List the field you want to search over"
      ]
    }
  }
}
```
### S10: Example - Running a match query against multiple fields
```yaml
GET news_headlines/_search
{
  "query": {
    "multi_match": {
      "query": "Michelle Obama",
      "fields": [
        "headline",
        "short_description",
        "authors"
      ]
    }
  }
}
```

##### Per-field boosting
> - Headlines mentioning "Michelle Obama" in the field headline are more likely to be related to our search than the headlines that mention "Michelle Obama" 
    once or twice in the field short_description.
> - To improve the precision of your search, you can designate one field to carry more weight than the others.
> - This can be done by boosting the score of the field headline(per-field boosting). This is notated by adding a carat(^) symbol and number 2 to the desired field as shown below.

```yaml
GET news_headlines/_search
{
  "query": {
    "multi_match": {
      "query": "Michelle Obama",
      "fields": [
        "headline^2",
        "short_description",
        "authors"
      ]
    }
  }
}
```

##### Boosting

> - Use the boost operator ^ to make one term more relevant than another. For instance, if we want to find all documents about foxes, but we are especially interested in quick foxes:
    `quick^2 fox`
> - The default boost value is 1, but can be any positive floating point number. Boosts between 0 and 1 reduce relevance.
> - Boosts can also be applied to phrases or to groups:
    `"john smith"^2   (foo bar)^4`

#### Combined Queries

There will be times when a user asks a multi-faceted question that requires multiple queries to answer.

- This search is actually a combination of three queries:
  - Query headlines that contain the search terms "Michelle Obama" in the field headline.
  - Query "Michelle Obama" headlines from the "POLITICS" category.
  - Query "Michelle Obama" headlines published before the year 2016

With the bool query, you can combine multiple queries into one request and further specify boolean clauses to narrow down your search results.

- There are four clauses to choose from:
  - must
  - must_not
  - should
  - filter
  
### S11: Syntax - Executing multiple queries in bool query

```yaml
GET name_of_index/_search
{
  "query": {
    "bool": {
      "must": [
        {One or more queries can be specified here. A document MUST match all of these queries to be considered as a hit.}
      ],
      "must_not": [
        {A document must NOT match any of the queries specified here. It it does, it is excluded from the search results.}
      ],
      "should": [
        {A document does not have to match any queries specified here. However, it if it does match, this document is given a higher score.}
      ],
      "filter": [
        {These filters(queries) place documents in either yes or no category. Ones that fall into the yes category are included in the hits. }
      ]
    }
  }
}
```
### S12: `must` clause in Bool query
> - The must clause defines all queries(criteria) a document MUST match to be returned as hits. These criteria are expressed in the form of one or multiple queries.

> - All queries in the must clause must be satisfied for a document to be returned as a hit. As a result, having more queries in the must clause will increase the precision of your query.

Syntax:

```yaml
GET Enter_name_of_the_index_here/_search
{
  "query": {
    "bool": {
      "must": [
        {
        "Enter match or match_phrase here": {
          "Enter the name of the field": "Enter the value you are looking for" 
         }
        },
        {
          "Enter match or match_phrase here": {
            "Enter the name of the field": "Enter the value you are looking for" 
          }
        }
      ]
    }
  }
}
```
Example

```yaml
GET news_headlines/_search
{
  "query": {
    "bool": {
      "must": [
        {
        "match_phrase": {
          "headline": "Michelle Obama"
         }
        },
        {
          "match": {
            "category": "POLITICS"
          }
        }
      ]
    }
  }
}
```
### S13: `must_not` clause in Bool query
> The must_not clause defines queries(criteria) a document MUST NOT match to be included in the search results.

Syntax:

```yaml
GET Enter_name_of_the_index_here/_search
{
  "query": {
    "bool": {
      "must": [
        {
        "Enter match or match_phrase here": {
          "Enter the name of the field": "Enter the value you are looking for" 
         }
        },
       "must_not":[
         {
          "Enter match or match_phrase here": {
            "Enter the name of the field": "Enter the value you are looking for"
          }
        }
      ]
    }
  }
}
```
Example:

```yaml
GET news_headlines/_search
{
  "query": {
    "bool": {
      "must": {
        "match_phrase": {
          "headline": "Michelle Obama"
         }
        },
       "must_not":[
         {
          "match": {
            "category": "WEDDINGS"
          }
        }
      ]
    }
  }
}
```

### S13: `should` clause in Bool query

> The should clause adds "nice to have" queries(criteria). The documents do not need to match the "nice to have" queries to be considered as hits.         However, the ones that do will be given a **higher score** so it shows up higher in the search results.

Syntax:

```yaml
GET Enter_name_of_the_index_here/_search
{
  "query": {
    "bool": {
      "must": [
        {
        "Enter match or match_phrase here: {
          "Enter the name of the field": "Enter the value you are looking for" 
         }
        },
       "should":[
         {
          "Enter match or match_phrase here": {
            "Enter the name of the field": "Enter the value you are looking for"
          }
        }
      ]
    }
  }
```

Example:

> user may be looking up "Michelle Obama" in the context of "BLACK VOICES" category rather than in the context of "WEDDINGS", "TASTE", or "STYLE"         categories.

```yaml
GET news_headlines/_search
{
  "query": {
    "bool": {
      "must": [
        {
        "match_phrase": {
          "headline": "Michelle Obama"
          }
         }
        ],
       "should":[
         {
          "match_phrase": {
            "category": "BLACK VOICES"
          }
        }
      ]
    }
  }
}
```
> The documents with the phrase "BLACK VOICES" in the field category are now presented at the top of the search results.

### S14: `filter` clause in Bool query

> The filter clause contains filter queries that place documents into either "yes" or "no" category.

Syntax:

```yaml
GET Enter_name_of_the_index_here/_search
{
  "query": {
    "bool": {
      "must": [
        {
        "Enter match or match_phrase here": {
          "Enter the name of the field": "Enter the value you are looking for" 
         }
        }
        ],
       "filter":{
          "range":{
             "date": {
               "gte": "Enter lowest value of the range here",
               "lte": "Enter highest value of the range here"
          }
        }
      }
    }
  }
}
```

Example 1 - `range`:

```yaml
GET news_headlines/_search
{
  "query": {
    "bool": {
      "must": [
        {
        "match_phrase": {
          "headline": "Michelle Obama"
          }
         }
        ],
       "filter":{
          "range":{
             "date": {
               "gte": "2014-03-25",
               "lte": "2016-03-25"
          }
        }
      }
    }
  }
}
```

Example 2 - `term`:
```yaml
.......code
```

Example 3 - `terms`:
```yaml
.......code
```

#### Fine-tuning the relevance of bool queries
> There are many ways you can fine-tune the relevance of bool queries. One of the ways is to add multiple queries under the should clause.

#### Adding multiple queries under the should clause

> This approach ensures that you maintain a high recall but also offers a way to present more precise search results at the top of your search results.

