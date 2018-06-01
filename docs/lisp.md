[![CommonLisp](img/lisplogo.svg)](lisp)
# Common Lisp #

The Common Lisp language was developed as a standardized and improved successor
of Maclisp. Byt the early 1980s several groups wer ealready at work on diverse
successors to MacLisp. COmmon lisp sought to unify, standardise, and extend the
features of these MaxLisp dialects. Common Lisp is not an implementation but
rather a language spcifications. Common Lisp is a general-purpose,
multi-paradigm programming lanugage. It supports a combinations of procedural,
functions, and object-oriented programming paradigms. As a dynamic programming
language, it facilitates evolutionary and incremental software development,
wither iterative compilation into efficient run-tim programs. This incremental
development is often done interactivly without interrupting the running
application.

---

## Meta-Guide ##

### Must, Should, May, or Not ###

Each guideline's level of importance is indicated by use fo the following
keywords and phrases.

#### MUST ####

This, or the terms "REQUIRED" or "SHALL", means that the guideline is an
absolute requirement. You must ask permission to violate a MUST

#### MUST NOT ####

This phrase, or the phrase "SHALL NOT", means that the guideline is an absolute
prohibition. You must ask permisson to violate a MUST NOT.

#### SHOULD ####

This word, or the adjective "RECOMMENDED", means that there may exist valid
reasons in particular circumstances to ignore the demands of the guideline, but
the full implications must be understood and carefully weighted before choosing
a different course. You must ask forgiveness for violating a SHOULD.

#### SHOULD NOT ####

This phrase, or the phrase "NOT RECOMMENDED", means that there may exist valid
rasons in particular circumstances to ignore thr prohibitions of this
guideline, but the full implications should be understood and carefully
weighted before choosing a different course. You must ask forgiveness for
violating a SHOULD NOT.

#### MAY ####

This word, or the adjective "OPTIONAL", means that an item is truly optional.

### Permission and Forgiveness ###

There are cases wher transgression of some of these rules is useful or even
necessary. In some cases, you must seek permission or obtain forgiveness form
the proper people.

Permission comes from the owners of your project.

Forgiveness is requested in a comment near the point of guideline violation,
and is granted by your code reviewer. The original comment should be signed by
you, the reviewer should add a signed approval to the comment at review time.

### Conventions ###

You MUST follow conventsion. They are not optional.

Some of these guidelines are motivated by universal priciples of good
programming. Some guidelines are motivated by technical peculiarities of COmmon
Lisp. Some guidelines were once motivated by a technical reason, but the
guideline remained after the reason subsided. Some guidelines, such those about
comments and indentation, are based purely on convention, rather than on clear
technical merit. Whatever the case may be, you must still follow these
guidelines, aswell as other conventional guidelines that have not been
fomalized in this document.

You MUST follow conventaions. THey are important for readability. When
conventions are followed by default, violations of the convention are a signal
that something notable is happening and deserves attention. When conventations
are systematically violated, violations of the conventation are distractin
noise that needs to be ignored.

Conventional guidelines *are* indoctrination. Their purpose is to make you
follow the mores of the community, so you can more effectively cooperate with
existing members. It is still useful to distinguish the parts that are
technically motivated from the parts that are mear conventions, so you know
when best to defy conventions for good effect, and when not to fall into the
pitfalls that the conventions are there to help avoid.

## General Guidelines ##

### Principles ###

There are some basic principles for team software development that every
developer must keep in mind. Whenever the detailed guidelines are inadequate,
confusing or contradictory, refer back to these principles for guidance:

* Every developer's code must be easy for another developer to read, understand
    and modify -- even if the first developer isn't around to explain it.
* Everybody's code should look the same.
* Be precise.
* Be concise.
* KISS -- Keep It Simple, Stupid.
* Use the smallest hammer for the job.
* Use common sense.
* Keep related code together. Minimize the amount of jumping around someone has
    to do to understand an area of code.

### Priorities ###

### Architecture ###

### Using Libraries ###

### Open-Sourcing Code ###

### Development Process ###

## Formatting ##

### Spelling and Abbreviations ###

### Line Length ###

### Indentation ###

### File Header ###

### Vertical Whitespace ###

### Horizontal Whitespace ###

## Documentation ##

### Document Everything ###

### Comment Semicolons ###

### Grammar and Punctuation ###

### Attention Required ###

### Domain-Specific Languages ###

## Naming ##

### Symbol Guidelines ###

### Denote Indent, not Content ###

### Global Variables and Constants ###

### Predicate Names ###

### Omit Library Prefixes ###

### Packages ###

## Language Usage Guidelines ##

### Mostly Functional Style ###

### Recursion ###

### Special Variables ###

### Assignment ###

### Assertions and Conditions ###

### Type Checking ###

### CLOS ###

## Meta-Language Guidelines ##

### Macros ###

### EVAL-WHEN ###

### Read-Time Evaluation ###

### EVAL ###

### INTERN and UNINTERN ###

## Data Representation ##

### NIL: empty-list, false and I Don't Know ###

### Do not abuse lists ###

### List vs. Structures vs. Multiple Values ###

### Lists vs. Pairs ###

### Lists vs. Arrays ###

### Lists vs. Sets ###

## Proper Forms ##

### Defining Constants ###

### Defining Functions ###

### Conditional Expressions ###

### Identify, Equality and Comparisions ###

### Iteration ###

### I/O ###

## Optimization ##

### Avoid Allocation ###

### Unsafe Operations ###

### DYNAMIC-EXTENT ###

### REDUCE vs APPLY ###

### Avoid NCONC ###

## Pitfalls ##

### #'FUN vs 'FUN ###

### Pathnames ###

### SATISFIES ###

