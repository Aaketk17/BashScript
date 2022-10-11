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

