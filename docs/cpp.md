[![C++](img/cpplogo.svg)](cpp)

C++ is a general-purpose programming language. It has imperative,
object-oriented and generic programming features, while also providing
facilities for low-level memory manipulation.

It was desigend with a bias toward system programming and embedded,
resource-constrained and large system, with preformance efficiency and
flexibility of use as its design highlights. C++ has also been found useful in
many other contexts, with key strengths begin software infrastructure and
resource-constrained applications, including desktop applications, servers
(e.g. e-commerce, web search or SQL servers), and performance-critical
applications (e.g. telephone switches or space probes). C++ is a compiled
language, with implementations of it available on many platforms. Many vendors
provide C++ compilers, including the Free Software Foundation, Microsoft,
Intel, and IBM.

C++ is standardized by the International Organization for Standardization
(ISO), with the latest standard version ratified and published by ISO in
December 2017 as ISO/IEC 14882:2017 (informally known as C++17). The C++
programming language was initially standardized in 1998 as ISO/IEC 14882:1998,
which was then amended by the C++03, C++11 and C++14 standards. The current
C++17 standard supersedes these with new features and an enlarged standard
library. Before the initial standardization in 1998, C++ was developed by
Bjarne Stroustrup at Bell Labs since 1979, as an extension of the C language as
he wanted an efficient and flexible language similar to C, which also provided
high-level features for program organization. C++20 is the next planned
standard thereafter.

Many other programming languages have been influenced by C++, including C#, D,
Java, and newer versions of C.

* * *

# In: Introduction

This is a set of core guidelines for modern C++, C++17, C++15, and C++11,
taking likely future enhancements and ISO Technical Specifications (TSs) into
account. The aim is to help C++ programmers to write simpler, more efficient,
more maintainable code.

## In.target: Target Readership

All C++ programmers. This includes programmers who might consider C.

## In.aims: Aims

The purpose of this document is to help developers to adopt modern C++ and to
achieve a more uniform style across code bases.

We do not suffer the delusion that every one of these rules can be effectively
applied to every code base. Upgrading old systems is hard. However, we do
believe that a program that uses a rule is less error-prone and more
maintainable than one that does not. Often, rules also lead to faster.easier
initial development. As far as we can tell, these rules lead to code that
preforms as well or better than older, more conventional techniques; they are
meant to follow the zero-overhead principle. Consider these rules ideals for
new code, opportunities to exploit when working on older code, ad try to
approximate these ideals as closely as feasible
j

### In.0: Don't Panic!

Take the time to understand the implications of a guideline rule on your
program.

These guidelines are designed according to the "subset of superset" principle.
They do not simply define a subset of C++ to be used. Instead, they strongly
recommend the use of a few simple "extensions" that make the use of the most
error-prone features of C++ redundant, so that they can be banned.

The rules emphasize static type safety and resource safety. For that reason,
they emphasize possibilities for range checking, for avoiding dereferencing
`nullptr`, for avoiding dangling pointers, and semantic use of exceptions
(via RAII). Partly to achieve that and partly to minimize obscure code as a
source of errors, the rule to emphasize simplicity and the hiding of necessary
complexity behind well-specified interfaces.

Many of the rules are prescriptive. We are uncomfortable with rules that simply
state "don't do that!" without offering an alternative. One consequence of that
is that some rules can be supported only by heuristics, rather than precise and
mechanically verifiable checks. Other rules articulate general principles. For
these more general rules, more detailed and specific rules provide partial
checking.

These guidelines address the core of C++ and its use. We expect that most large
organizations, specific application areas, and even large projects will need
further rules, possibly further restrictions, and further library support. For
example, hard-real-time programmers typically can't use free store (dynamic
memory) freely and will be restricted in their choice of libraries. We encourage
the development of such more specific rules as addenda to these core
guidelines. Build your ideal small foundation library and use that, rather than
lowering your level of programming to glorified assembly code.

These rules are designed to allow gradual adoption.

Some rules aim to increase various forms of safety while others aim to reduce
the likelihood of accidents, many do both. The guidelines aimed at preventing
accidents often ban perfectly legal C++. However, when there are two ways of
expressing an idea and one has shown itself a common source of errors and the
other has not, we try to guide programmers toward the latter.

## In.not: Non-Aims

The rules are not intended to be minimal or orthogonal. In particular, general
rules can be simple, but unenforceable. Also, it is often hard to understand
the implications of a general rule. More specialized rules are often easier to
understand and to enforce, but without general rules, they would just be a long
list of special cases. We provide rules aimed at helping novices as well as
rules supporting expert use. Some rules can be completely enforced, but others
are based on heuristics.

These rules are not meant to be read serially, like a book. You can brows
through them using the links. However, their main intended use is to be targets
for tools. That is, a tool looks for violations and the tool returns links to
violated rules. The rules then provide reasons, examples of potential
consequences of the violation, and suggested remedies.

These guidelines are not intended to be a substitute for a tutorial treatment
of C++. If you need a tutorial for some given level of experience, see the
references.

This is not a guide on how to convert old C++ code to more modern code. It is
meant to articulate ideas for new code in a concrete fashion. However, see the
modernization section for some possible approaches to modernizing. Importantly,
the rules support gradual adoption: It is typically infeasible to completely
convert a large code base all at once.

These guidelines are not meant to be complete or exact in every
language-technical detail. For the final word on language definition issues,
including every exception to general rules and every feature see the ISO C++
standard.

The rules are not intended to force you to write in an impoverished subset of
C++. They are _emphatically_ not meant to define a, say, Java-like subset of
C++. They are not meant to define a single "one true C++" language. We value
expressiveness and uncompromised performance.

The rules are not value-neutral. They are meant to make code simpler and more
correct/safer than most existing C++ code, without loss of performance. They
are meant to inhibit perfectly valid C++ code that correlates with errors,
spurious complexity, and poor performance.

The rules are not perfect. A rule can do harm by prohibiting something that is
useful in a given situation. A rule can do harm by failing to prohibit
something that enables a serious error in a given situation. A rule can do a
lot of harm by being vague ambiguous, unenforceable, or by enabling every
solution to a problem. It is impossible to completely meet the "do no harm"
criteria. Instead, our aim is the less ambitious: "Do the most good for most
programmers"; if you cannot live with a rule, object to it, ignore it, but
don't water it down until it becomes meaningless. Also, suggest an improvement.

## In.force: Enforcement

Rules with no enforcement are unmanageable for large code bases. Enforcement of
all rules is possible only for a small weak set of rules or for a specific user
community.

-   But we want lots of rules, and we want rules that everybody can use.
-   But different people have different needs.
-   But people don't like to read lots for rules.
-   But people can't remember many rules.

So, we need subsetting to meet a variety of needs.

-   But arbitrary subsetting leads to chaos.

We want guidelines that help a lot of people, make code more uniform, and
strongly encourage people to modernize their code. We want to encourage best
practices, rather than leave all to individual choices and management pressures.
The ideal is to use all rules; that gives the greatest benefits.

This adds up to quite a few dilemmas. We try to resolve those using tools. Each
rule has an **Enforcement** section listing ideas for enforcement. Enforcement
might be done by code review, by static analysis, by compiler, or by run-time
checks. Wherever possible, we prefer "mechanical" checking (humans are slow,
inaccurate, and bore easily) and static checking. Run-time checks are suggested
only rarely where no alternative exists; we do not want to introduce
"distributed fat". Where appropriate, we label a rule (in the **Enforcement**
section) with the name of groups of related rules (called "profiles"). A rule
can be part of several profiles, or none. For a start, we have a few profiles
corresponding to common needs (desires, ideals):

-   **type**: No type violations (reinterpreting a `T` as a `U` through casts,
      unions, or varags).
-   **bounds**: No bounds violations (accessing beyond the range of an array).
-   **lifetime**: No leaks (failing to `delete` or multiple `delete`) and no
      access to invalid objects (dereferencing `nullptr`, using a dangling
      reference).

The profiles are intended to be used by tools, but also serve as an aid to the
human reader. We do not limit our comment in the **Enforcement** sections to
things we know how to enforce; some comments are mere wishes that might inspire
some tool builder.

Tools that implement these rules shall respect the following syntax to
explicitly suppress a rule:

    [[gsl::suppress(tag)]]

where "tag" is the anchor name of the item where the Enforcement rule
appears, the name of a profile group-of-rules, or a specific rule in a profile.

## In.struct: The Structure of this Document

Each rule (guideline, suggestion) can have several parts:

-   The rule itself -- e.g., **no naked `new`**.
-   A rule reference number -- e.g., **C.7** (the 7th rule related to classes).
      Since the major sections are not inherently ordered we use letters as the
      first part of a rule reference "number". We leave gaps in the numbering to
      minimize "disruption" when we add or remove rules.
-   **Reason**s -- because programmers find it hard to follow rules they don't
      understand.
-   **Example**s -- because rules are hard to understand in the abstract; can be
      positive or negative.
-   **Alternative**s -- for "don't do this" rules
-   **Exception**s -- we prefer simple general rules. However, many rules apply
      widely, but not universally, so exceptions must be listed.
-   **Enforcement** -- ideas about hot the rule might be checked "mechanically"
-   **See also**s -- references to related rules and/or further discussion.
-   **Note**s -- something that needs saying that doesn't fit the other
      classifications.
-   **Discussion** -- references to more extensive rationale and/or examples
      placed outside the main lists of rules.

Some rules are hard to check mechanically, but they all meet the minimal
criteria that an expert programmer can spot many violations without too much
trouble. We hope that "mechanical" tools will improve with time to approximate
what such any expert programmer notices. Also, we assume that the rules will be
refined over time to make them more precise and checkable.

A rule is aimed at being simple, rather than carefully phrased to mention every
alternative and special case. Such information is found in the **Alternative**
paragraphs and the Discussion sections. If you don't understand a rule or
disagree with it, please visit its **Discussion**. If you feel that a
discussion is missing or incomplete, enter an Issue explaining your concerns
and possibly a corresponding PR.

This is not a language manual. It is meant to e helpful, rather than complete,
fully accurate on technical details, or a guide to exiting code. Recommended
information sources can be found in the references.

# P: Philosophy

The rules in this section are very general.

Philosophical rules are generally not mechanically checkable. However,
individual rules reflecting these philosophical themes are. Without a
philosophical basis, the more concrete/specific/checkable rules lack rationale.

### P.1: Express Ideas Directly in Code

#### Reason

Compilers don't read comments (or design documents) and neither do many
programmers (consistently).  What is expressed in code has defined semantics
and can (in principle) be checked by compilers and other tools.

#### Enforcement

Very hard in general.

-   Use `const` consistently (check if member functions modify their object;
      check if functions modify arguments passed by pointer or reference).
-   Flag uses of casts (casts neuter the type system)
-   Detect code that mimics the standard library (hard).

### P.2: Write in ISO Standard C++

#### Reason

This is a set of guidelines for writing ISO Standard C++.

#### Note

There are environments where extensions are necessary, e.g., to access system resources.
In such cases, localize the use of necessary extensions and control their use
with non-core Coding Guidelines.  If possible, build interfaces that
encapsulate the extensions so they can be turned off or compiled away on
systems that do not support those extensions.

Extensions often do not have rigorously defined semantics.  Even extensions
that are common and implemented by multiple compilers may have slightly
different behaviors and edge case behavior as a direct result of _not_ having a
rigorous standard definition.  With sufficient use of any such extension,
expected portability will be impacted.

#### Note

Using valid ISO C++ does not guarantee portability (let alone correctness).
Avoid dependence on undefined behavior (e.g., [undefined order of evaluation](#es-43-avoid-expressions-with-undefined-order-of-evaluation))
and be aware of constructs with implementation defined meaning (e.g., `sizeof(int)`).

#### Note ####

There are environments where restrictions on use of standard C++ language or
library features are necessary, e.g., to avoid dynamic memory allocation as
required by aircraft control software standards. In such cases, control their
(dis)use with an extension of these Coding Guidelines customized to the
specific environment.

#### Enforcement ####

Use an up-to-date C++ compiler with a set of options that do not accept
extensions.

### P.3: Express Intent

### P.4: Ideally, a Program Should be Statically Type Safe

### Prefer Compiler-Time Checking to Run-Time Checking

### What Cannot be Checked at Compile Time Should be Checked at Run Time

### Catch Run-Time Errors Early

### Don't Leak Any Resources

### Don't Waste Time or Space

### Prefer Immutable Data to Mutable Data

### Encapsulate Messy Constructs, Rather Than Spreading Through the Code

### Use Supporting Tools as Appropriate

### Use Support Libraries as Appropriate

# Interfaces

### Make Interfaces Explicit

### Avoid Non-Const Global Variables

### Avoid Singletons

### Make Interfaces Precisely and Strongly Typed

### State Preconditions

### Prefer Expects for Expressing Preconditions

### State Postconditions

### Prefer Ensures for Expressing Postconditions

### If an Interface is a Template, Document its Parameters Using Concepts

### Use Exceptions to Signal a Failure to Preform a Required Task

### Never Transfer Ownership by a Raw Pointer or Refernece

### Declare a Pointer that Must not be Null as not_null

### Do not Pass an Array as a Single Pointer

### Avoid Complex Initialization of Global Objects

### Keep the Number of Function Arguments Low

### Avoid Adjacent Unrelated Parameters of the Same Type

### Prefer Abstract Classes as Interfaces to Calss Hierarchies

### If You Want a Cross-COmpiler ABI, Use a C-Stype Subset

### For Stable Library ABI, Consider the Pimpl Idiom

### Encapsulate Rule Violations

# Functions

## Function Definition

### "Package" Meaningful Operations as Carefully Named Funcitons

### A Function Should Preform a Single Logical Operation

### Keep Functions Short and Simple

### If a Function May Have to be Evaluated at Compile Time, Declare it Constexpr

### If a Function is Very Small and Time-Critical, Declare it Inline

### If Your Function May Not Throw, Declare it Noexcept

### For General Use, Take T\* or T& Arguments Rather Than Smart Pointers

### Prefer Pure Functions

### Unused Parameters Should be Unnamed

## Parameter Passing Expression

### Prefer Simple and Conventional Ways of Passing Information

### For "in" Parameters, Pass Cheaply-Copied Types by Value and Others by Reference to Const

### For "in-out" Parameters, Pass by Reference to Non-Const

### For "will-move-from" Parameters, Pass by X&& and std::move the Parameter

### For "forward" Parameters, Pass by X&& and only std::forward the Parameter

### For "out" output Values, Prefer Return Values to Output Parameters

### To Return multiple "out" Values, Prefer returning a Tuple or Struct

### Prefer T\* over T& when "no argument" is a Valid Option

## Parameter Passing Semantic

### Use T_ or owner&lt;T_> to Designate a Single Object

### Use a not_null<T> to Indicate that "null" is not a Valid Value

### Use a span<T> or  a span_p<T> to Designame a Half-Open Sequence

### Use a zstring or a not_null<zstring> to Designate a C-Style String

### Use a unique_ptr<T> to Transfer Ownership Where a Pointer is Needed

### Use a shared_ptr<T> to Share Ownership

## Value Return Semantic

### Return a T\* to Inicate a Position (Only)

### Never (Directly or Indirectly) return a Pointer or a Reference to a Local Object

### Return a T& When COpy is Undesirable and "returning no object" isn't Needed

### Don't Return a T&&

### int is the Return Type for main()

### Reuturn T& from Assignment Operators

## Other

### Use a Lambda When a Function Won't do (to Capture Local Variables, or to Write a Local Function)

### Where There is a Choice, Prefer Default Arguments Over Overloading

### Prefer Capturing by Reference in Lambdas That Will be Used Locally, Including Passed to Algorithms

### Avoid Capturing by Reference in Lambdas That Will be Used Nonlocally, Including Returned, Sotred on the Heap, or Passed to Another Thread

### If you Capture this, Capture all Variables Explicitly (No Default Capture)

### Don't use va_arg Arguments

# Classes and Class Hierarchies

### Organize Related Data into Structures (structs or classes)

### Use class if the class has an invariant; use struct if the data members can vary independently

### Represent the distinction between an interace and an implementation using a class

### Make a Function a Member Only if it Needs Direct Access to the Representation of a Class

### Place Helper Functions in the Same Namespace as the Class they Support

### Don't define a class or enum and Declare a variable of its type in the same statement

### Use class rather than struct if Any Member is non-public

### Minimize Exposure of Members

## Concrete Types

### Prefer Concrete Types over Class Hierarchies

### Make Concreate Types Regular

## Constructors, Assignments, and Destructors

## Default Operations

### If You Can Avoid Defining Any Default Operations, do

### If You Define or =delete any Default operation, define or =delete them all

### Make Default Operations Consistent

## Destructor Rules

### Define a Destructor if a Class Needs an Explicit action at object destruction

## Containers and Other resource Handles

## Function Objetcs and Lambdas

## Class Hierarchies(OOP)

## Overloading and overloaded operators

## Unions

# Enumerations

# Resource Management

# Expressions and Statements

# Preformance

# Concurrency

# Error Handling

# Constants and Immutability

# Templates and Generic Programming

# C-Stype Programming

# Source Files

# The Standard Library

# Architectural Ideas

# Non-Rules and Myths

# Profiles

# Guideline Support Library

# Naming and Layout
