============
Header Files
============

In general, every ``.cpp`` file should have an associated ``.hpp`` file. There are some common exceptions, such as unit tests and small ``.cpp`` files containing just a ``main()`` function.

Correct use of header files can make a huge difference to the readability, size and performance of your code.

The following rules will guide you through the various pitfalls of using headers files.

Self-contained Headers
======================

Header files should be self-contained (compile on their own) and end in ``.hpp``. Non-header files that are meant for including should end in ``.inc`` and be used sparingly.

All header files should be self-contained. Users and refactoring tools should not have to adhere to special conditions to include the header. Specifically, a header should have `Header Guards`_ and include all other headers it needs. 

Prefer placing the definitions for templates and inline functions in the same file as their declarations. The definitions of these constructs must be included into every ``.cpp`` file that uses them, or the program may fail to link in some build configurations. If declarations and definitions are in different files, including the former should transitively include the later. Do not move these definitions to separately included header files (``-inl.h``); this practice was common in the past, but is no loner allowed.

As an exception, a template that is explicitly instantiated for all relevant sets of template arguments, or that is a private implementation detail of a class, is allowed to be defined in the one and only ``.cpp`` file that instantiates the template.

There are rare cases where a file designed to be included is not self-contained. These are typically intended to be included at usual locations, such as the middle of another file. They might not use `Header Guards`_, and might not include their prerequisites. Name such files with the ``.inc`` extension. Use sparingly, and prefer self-contained headers when possible.

Header Guards
=============

All header files should have ``#define`` guards to prevent multiple inclusion. The format of the symbol name should be ``<PROJECT>_<PATH>_<FILE>_HPP_``.

To guarantee uniqueness, they should be based on the full path in a project's source tree. For example, the file ``foo/src/bar/baz.h`` in the project ``foo`` should have the following guard:

.. code-block:: c++

   #ifndef FOO_BAR_BAZ_HPP_
   #define FOO_BAR_BAZ_HPP_

   ...

   #endif // FOO_BAR_BAZ_HPP_

Forward Declarations
====================

Avoid using forward declarations where possible. Just ``#include`` the headers you need.

Definition:
  A "forward declaration" is a declaration of a class, function or template without an associated definition.

Pros:
  - Forward declarations can save compile time, as ``#include``\s force the compiler to open more files and process more input.
  - Forward declarations can save on unnecessary recompilation. ``#include``\s can force your code to be recompiled more often, due to unrelated changes in the header.

Cons:
  - Forward declarations ca hide a dependency, allowing user code to skip necessary recompilation when headers change.
  - Forward declarations may be broken by subsequent changes to the library. Forward declarations of functions and templates can prevent the header owners from making otherwise-compatible changes to their APIs. Such as widening a parameter type, adding a template parameter with a default value, or migrating to a new namespace.
  - Forward declaring symbols from namespace ``std::`` yields undefined behavior.
  - It can be difficult to determine whether a forward declaration or a full ``#include`` is needed. Replacing an ``#include`` with a forward declaration can silent change the meaning of code.
  - Forward declaring multiple symbols from a header can be more verbose than simply ``#includ``\ing the header.
  - Structuring code to enable forward declaration (e.g. using pointer members instead of object members) can make code slower and more complex.

Decision:
  - Try to avoid forward declarations of entities defined in another project.
  - When using a function declared in a header file, always ``#include`` that header.
  - When using a class template, prefer to ``#include`` its header file.

Please see `Names and Order of Includes`_ for rules about when to ``#include`` a header.

Inline Functions
================

Define function inline only when they are small, say, 10 lines or fewer.

Definition:
  You can declare functions in a way that allows the compiler to expand them inline rather than calling them through the usual function call mechanism.

Pros:
  - Inlining a function can generate more efficient object code, as long as the inlined function is small. Feel free to inline accessors and mutators, and other short, performance-critical functions.

Cons:
  - Overuse of inlining can actually make programs slower. Depending on a function's size, inlining it can cause the code size to increase or decrease. Inlining a very small accessor function will usually decrease code size while inlining a very large function can dramatically increase code size. On modern processors smaller code usually runs faster due to better use of the instruction cache.

Decision:
  - A decent rule of thumb is to not inline a function if it is more than 10 liens long. Beware of destructors, which are often longer than they appear because of implicit member- and base-destructor calls!
  - It's typically not cost effective to inline functions with loops or switch statements (unless, in the common case, the loop or switch statement is never executed).

It is important to know that functions are not always inlined even if they are declared as such; for example virtual and recursive functions are not normally inlined. Usually recursive functions should not be inlined. The main reason for making a virtual function inline is to place its definition in the class, either for convenience or to document its behavior, e.g., for accessors and mutators.

Names and Order of Includes
===========================

Use standard order for readability and to avoid hidden dependencies: Related headers, C library, C++ library, other libraries' ``.h``/``.hpp``, your project's ``.h``/``.hpp``.

All of a projects headers files should be listed as descendants of the project's source directory without the use of UNIX directory shortcuts ``.`` (the current directory) or ``..`` (the parent directory). For example, ``google-awesome-project/src/base/logging.hpp`` should be included as:

.. code-block:: c++

   #include "base/logging.hpp"

In ``dir/foo/cpp`` or ``dir/foo_test.cpp``, whose main purpose is to implement or test the stuff in ``dir2/foo2.hpp``, order your includes as follows:

1. ``dir2/foo2.hpp``.
2. C system files.
3. C++ system files.
4. Other libraries' ``.h``/``.hpp`` files.
5. Your project's ``.h``/``.hpp`` files.

With the preferred ordering, if ``dir2/foo2.hpp`` omits any necessary includes, the build of ``dir/foo.cpp`` or ``dirfoo_test.cpp`` will break. This, this rule ensures that build breaks show up first for the people working of these files, not for innocent people in other packages.

``dir/foo.cpp`` and ``dir2/foo2.hpp`` are usually in the same directory (e.g. ``base/basictypes_test.cpp`` and ``base/basictypes.hpp``), but may sometimes be in different directories too.

Within each section the includes should be ordered alphabetically. Note that older code might not conform to this rule an should be fixed when convenient.

You should include all the headers that define the symbols you rely upon, except in the unusual case of `Forward Declarations`_. If you rely on symbols from ``bar.hpp``, don't count on the fact that you included ``foo.hpp`` which (currently) includes ``bar.hpp``: include ``bar.hpp`` yourself, unless ``foo.hpp`` explicitly demonstrates its intent to provide you the symbols of ``bar.hpp``. However, any includes present in the related header do not need to be included again in the related ``.cpp`` (i.e., ``foo.cpp`` can rely on ``foo.hpp``'s includes).

For example, the includes in ``google-awesome-project/src/foo/internal/fooserver.cpp`` might look like this:

.. code-block:: c++

   #include "foo/server/fooserver.hpp"
   
   #include <sys/types.h>
   #include <unistd.h>

   #include <hash_map>
   #include <vector>
   
   #include "base/basictypes.hpp"
   #include "base/commandlineflags.hpp"
   #include "foo/server/bar.hpp"

Exception:
  Sometimes, system-specific code needs conditional includes. Such code can put conditional includes after other includes. Of course, keep your system specific code small and localized. Example:

.. code-block:: c++

   #include "foo/public/fooserver.hpp"
   
   #include "base/port.hpp" // For LANG_CXX11.

   #ifndef LANG_CXX11
   #include <initializer_list>
   #endif // LANG_CXX11
