======
Naming
======

The most important consistency rule are those that govern naming. Tye style of a name immediately informs us what sort of thing the name entity is: a type, a variable, a function, a constant, a macro, etc., without requiring us to search for the declaration of that entity. The pattern-matching engine in our brains relies a great deal on these naming rules.

Nameing rules are pretty arbitrary, but we feel that consistency is more important than individual preferences in this area, so regardless of whether you find them sensible or not, the rules are the rules.

General Naming Rules
====================

Names should be descriptive; avoid abbreviation.

Give as descriptive a name as possible, within reason. Do not worry about saving horizontal space as it is far more important to make your code immediately understandable by a new reader. Do not use abbreviations that are ambiguous or unfamiliar to readers outside you project, and do not abbreviate by deleting letters within a word.

.. code-block:: c++

   int price_count_reader; // No abbreviation.
   int num_errors: // "num" is a widespread convention.
   int num_dns_connections; // Most people know what "DNS" stands for.

.. code-block:: c++

   int n; // Meaningless.
   int nerr; // Ambiguous abbreviations.
   int n_comp_conns; // Ambiguous abbreviaiton.
   int wgc_connections; // Only your group knows what this stands for.
   int pc_reader; // Lots of things can be abbreviated "pc".
   int cstmr_id; // Deletes internal letters.

Not that certain universally-known abbreviaitons are OK, such as ``i`` for an iteration variable and ``T`` for template parameter.

Template parameters should follow the naming style for their category: type template parameters should follow the rules for `Type Names`_, and non-type template parameters should follow the rules for `Variable Names`_.

File Names
==========

Filenames should be all lowercase and can include underscores (``_``) or dashes (``-``). Follow the convention that your project uses. If there is no consistent local pattern to follow, perfer "``_``".

Examples of acceptable file names:
  - ``my_useful_class.cpp``
  - ``my-useful-class.cpp``
  - ``myusefulclass.cpp``
  - ``myusefulclass_test.cpp``

C++ files shoudl end in ``.cpp`` and header files should end in ``.hpp``. Files that rely on being textually included at specific points should end in ``.inc`` (see also the seciton on `self-contained headers`_).

Do not use filenames that aready exist in ``/usr/include``, such as ``db.h``.

In general, make your filenames very specific. For example, use ``http_server_logs.hpp`` rather than ``logs.hpp``. A very common case is to have a pair of files called, e.g., ``foo_bar.hpp`` and ``foo_bar.cpp``, defining a class called ``FooBar``.

Inline functions must be in a ``.cpp`` file. In your inline funcitons are very short, they should go directly into your ``.hpp`` file.

Type Names
==========

Type names start witha  capital letter and have a capital letter for each new word, with no underscores: ``MyExcitingClass``, ``MyExcitingEnum``.

The names of all types -- classes, structs, types aliases, enums, and type template parameters -- have the same naming convention. TYpe names should start with a capital letter and have a capital letter for each new word. No underscores. For example:

.. code-block:: c++

   // classes and structs
   class UrlTable { ...
   UrlTableTester { ...
   struct UrlTableProperties { ...

   // typedefs
   typedef hash_map<UrlTableProperties \*, string> PropertiesMap;

   // using aliases
   using PropertiesMap = hash_map<UrlTableProperties \*, string>;

   // enums
   enum UrlTableErros { ...

Variable Names
==============

The names of variables (including function parameters) and data members are all lower case, with underscores between words. Data members of classes (but not structs) additionally have trailing underscores. For instance: ``a_local_variable``, ``a_struct_data_member``, ``a_class_data_member_``.

Common Variable Names
---------------------

For example:

.. code-block:: c++

   string table_name; // OK - uses underscore.
   string tablename; // OK - all lowercase.

.. code-block:: c++

   string tableName; // Bad - mixed case.

Class Data Members
------------------

Data members of classes, both static and non-static, are named like ordinary nonmember variables, but with a trailing underscore.

.. code-block:: c++

   class TableInfo {
     ...
    private:
     string table_name_; // OK - underscore at end.
     string tablename_; // OK.
     static Pool<TableInfo>* pool_; // OK.
   };

Struct Data Members
-------------------

Data members of structs, both static and non-static, are named like orindary nonmember variables. They do not have the trailing underscores that data members in classes have.

.. code-block:: c++

   struct UrlTableProperties {
     string name;
     int num_entries;
     static Pool<UrlTableProperties>* pool;
   };

Constant Names
==============

Varialbes declare constexpr or const, and whose value is fixed for the duration of the program, are named with a leading "k" followed by mixed case. For example:

.. code-block:: c++

   const int kDaysInAWeek = 7;

All such variables with static storage duration (i.e. statics and globals, see `Storage Duration`_ for details) should be named this way. This convention is optional for variables of other storage classes, e.g. automatic variables, otherwise the usual variable nameing rules apply.

Function Names
==============

Regular funcitons have mixed case; accessors and mutators may be named like variables.

Ordinarily, funcitons hsould start with a capital letter and ahve a capital letter for each new word (a.k.a. "`Camel Case`_" or "Pascal case"). Such names should not have underscores. Prefer to capitalize acronyms as single words (i.e. ``StartRpc()``, not ``StartRPC()``).

.. code-block:: c++

   AddTableEntry()
   DeleteUrl()
   OpenFileOrDie()

(The same naming rule applies to class- and namespace-scope constants that are exposed as part of an API and that are intended to look like funcitons, beacuse the fact that they're objects rather than functions is an unimportant implemenation detail.)

Accessors and mutators (``get`` and ``set`` functions) may be named like variables. These often correspond to actual member variables, but this is not required for example, ``int count()`` and ``void set_count(int count)``.

Namespace Names
===============

Namespace names are all lower-case. Top-level names are based on the project name. Avoid collisions between nested namespaces and well-known top-level namespaces.

The name of a top-level namespace should usually be the name of the project or team whose code is contained in that namespaces. The code in that namespace should usually be in a directory whose basename matches the namespace name (or subdirectories thereof).

Keep in mind that the `rule against abbreviated names`_ applies to namespaces just as much as variable names. Code inside the namespace seldom needs to mention the namespace name, so there's usually no particular need for abbreviation anyway.

Avoid nested namespaces that match well-nown top-level namespaces. Collisions between namespace names can lead to surprising build breaks beacuse of name lookup rules. In particular, do not create any nested ``std`` namespaces. Prefer unique project identifers (``websearch::index``, ``websearch::index_util``) over collision-prone names like ``websearch::util``.

For internal namespaces, be wary of other code being added ot the same internal namespac causing a collision (internal helpers within a team tend to be related and may lead to collisions). In such a situation, using the filename to make a unique internal name is helpful (``websearch::index::frobber_internal`` for use in ``frobber.hpp``).

Enumerator Names
================

Enumerators (for both scoped and unscoped enums) should be named *either* like `constants`_ or like `macros`_: either ``kEnumName`` or ``ENUM_NAME``.

Preferably, the individual enumerators should be named like `constants`_. However, it is also acceptable to name them like `macros`_. The enumeration name, ``UrlTableErrors`` (and ``AlternateUrlTableErrors``), is a type, and therefore mixed case.

.. code-block:: c++

   enum UrlTableErrors {
     kOK = 0,
     kErrorOutOfMemory,
     kErrorMalformedInput,
   };
   enum AlternateUrlTableErrors {
     OK = 0,
     OUT_OF_MEMORY = 1,
     MALFORMED_INPUT = 2,
   };

Until January 2009, the style was to name enum values like `macros`_. This caused problems with name collisions between enum values and macros. Hence, the change to prefer constant-style nameing was put in place. New code should prefer constant-style naming if possible. However, there is no reason to change old code to use constant-style names, unless the old names are actually causing a compile-time problem.

Macro Names
===========

You're not really going to `define a macro`_, are you? If you do, they're like this: ``MY_MACRO_THAT_SCARES_SMALL_CHILDREN``.

Please see the `description of macros`_; in general macros should *not* be used. However, if they are absolutely needed, then they sould be named with capitals and underscores.

.. code-block:: c++

   #define ROUND(x) ...
   #define PI_ROUNDED 3.0

