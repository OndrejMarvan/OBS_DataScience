---
tags:
  - system
---

# Dataview Queries

Copy these into any note to create dynamic views of your vocabulary and progress.

## Total Word Count by Level
```dataview
TABLE length(rows) as "Word Count"
FROM #word
GROUP BY tags
WHERE contains(tags, "A1") OR contains(tags, "A2") OR contains(tags, "B1") OR contains(tags, "B2") OR contains(tags, "C1")
```

## Words to Review (not yet mastered)
```dataview
TABLE tags as "Tags", date_added as "Added"
FROM #word AND #review
WHERE mastered = false
SORT date_added ASC
LIMIT 20
```

## Recently Added Words
```dataview
TABLE tags as "Tags"
FROM #word
SORT date_added DESC
LIMIT 15
```

## False Friends to Watch
```dataview
LIST
FROM #false-friend
SORT file.name ASC
```

## Words by Theme
```dataview
TABLE length(rows) as "Count"
FROM #word
GROUP BY filter(tags, (t) => startswith(t, "theme/"))
SORT length(rows) DESC
```

## Grammar Notes by Level
```dataview
TABLE tags as "Tags"
FROM #grammar
SORT file.name ASC
```

## All Patterns
```dataview
TABLE tags as "Type"
FROM #pattern
SORT file.name ASC
```

## Study Log — Last 7 Days
```dataview
TABLE date as "Date", topic as "Topic"
FROM #daily
SORT date DESC
LIMIT 7
```

## Confused Words (need extra attention)
```dataview
LIST
FROM #confused
SORT file.name ASC
```

---

## How to Use
1. Install the **Dataview** plugin from Obsidian Community Plugins
2. Copy any query block above into a note
3. The query will automatically update as you add more notes
4. Customize queries by changing tags, limits, or sort orders
