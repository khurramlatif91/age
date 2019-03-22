CREATE EXTENSION agensgraph;
LOAD 'agensgraph';

SET search_path TO ag_catalog;

-- cypher() function takes only a string constant as an argument.
-- All other cases throw an error.

SELECT * FROM cypher($$RETURN 0$$) AS r(c text);
WITH r(c) AS (
  SELECT * FROM cypher($$RETURN 0$$) AS r(c text)
)
SELECT * FROM r;
SELECT * FROM cypher(NULL) AS r(c text);
WITH q(s) AS (
  VALUES ($$RETURN 0$$)
)
SELECT * FROM q, cypher(q.s) AS r(c text);

-- cypher() function can be called in ROWS FROM only if it is there solely.

SELECT * FROM ROWS FROM (cypher($$RETURN 0$$) AS (c text));
SELECT * FROM ROWS FROM (cypher($$RETURN 0$$) AS (c text),
                         generate_series(1, 2));

-- WITH ORDINALITY is not supported.

SELECT * FROM ROWS FROM (cypher($$RETURN 0$$) AS (c text)) WITH ORDINALITY;

-- cypher() function cannot be called in expressions.
-- However, it can be called in subqueries.

SELECT cypher($$RETURN 0$$);
SELECT (SELECT * FROM cypher($$RETURN 0$$) AS r(c text));