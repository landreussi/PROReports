DEFINE NEW GLOBAL SHARED TEMP-TABLE tt-dashboard NO-UNDO
    FIELD NAME      AS CHARACTER FORMAT "X(30)"
    FIELD path      AS CHARACTER FORMAT "X(200)"
    FIELD brand     AS CHARACTER FORMAT "X(40)"
    FIELD theme     AS CHARACTER FORMAT "X(20)"
    FIELD nav       AS CHARACTER FORMAT "X(70)"
    FIELD exec-time AS INTEGER
    FIELD container-page AS LOGICAL
    FIELD container-nav  AS LOGICAL
    FIELD inverse        AS LOGICAL
    FIELD acomp          AS LOGICAL.
