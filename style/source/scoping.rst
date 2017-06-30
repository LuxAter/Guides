=======
Scoping
=======

Namespaces
==========

With few exceptions, place code in a namespace. Namespaces should have unique names based on the project name and possibly its path. Do not use *using-dierectives* (e.g. ``using namespace foo``). Do not using inline namespaces. For unnamed namespaces see `Unnamed Namespaces and Static Variables`_.

Definition:
  Namespaces subdivide the global scope into distinct, named scopes, and so are useful for preventing name collisions in the global scope.

Pros:
  Namespaces provide a method for preventing name conflicts in large programs while allowing most code to be used reasonably short names.

  For example, if two different projects have a class ``foo`` in the global scope, these symbols may collide at compile time or at runtime. If each project places their code in a namespace, ``projectt1::Foo`` and ``project2::Foo`` are now distinct symbols that do not collide, and code within each project's namespace can continue to refer to ``Foo`` without the prefix.

  Inline namespaces automatically place their names in the enclosing scope. Consider the following snippet, for example:

.. code-block:: c++

   namespace X {
     inline namespace Y {
       void foo();
     } // namespace Y
   } // namespace X

The expressions ``X::Y::foo()`` and ``X::foo()`` are interchangeable. Inline namespaces are primarily intended for ABI compatibility across versions.

Cons:
  Namespaces can be confusing, because they complicate the mechanics of figuring out what definition a name refers to.

  Inline namespaces, in particular, can be confusing because names aren't actually restricted to the namespace where they are declared. They are only useful as part of some larger versioning policy.

  In some contexts, it's necessary to repeatedly refer to symbols by their fully qualified names. For deeply-nested namespaces, this can add a lot of clutter.

Decision:
  Namespaces should be used as follows:

  - Follow the rules on `Namespace Names`_.
  - Terminate namespaces with comments as showing in the given examples.
  - Namespaces wrap the entire source file after includes, `gflags`_, definitions/declarations and forward declarations of classes from other namespaces.

.. code-block:: c++

   // In the .hpp file
   namespace mynamespace {

     // All declarations are within the namespace scope.
     class MyClass {
      public:
       ...
       void Foo();
     };

   } // namespace mynamespace

.. code-block:: c++

   // In the .cpp file
   namespace mynamespace {
     
     //Definition of functions in within scope of the namespace.
     void MyClass::Foo() {
       ..
     }

   } // namespace mynamespace 

More complex ``.cpp`` files might have additional details, like flags or using-declarations.

  - Do not declare anything in namespace ``std``, including forward declarations of standard library classes. Declaring entities in namespace ``std`` is undefined behavior, e.g., not portable. To declare entities from the standard library, include the appropriate header file.
  - You may not use a *using-directive* to make all names form a namespace available.

.. code-block:: c++

   // Forbidden -- This pollutes the namespace.
   using namespace foo;

- Do not use *Namespace aliases* at namespace scope in header files except in explicitly marked internal-only namespace, because anything imported into a namespace in a header file becomes part of the public API exported by that file

.. code-block:: c++

   // Shorten access to some commonly used names in .cpp files.
   namespace bax = ::foo::bar::baz;

.. code-block:: c++

   // Shorten access to some commonly used names (in a .hpp file).
   namespace librarian {
     namespace impl { // Internal, not part of the API.
       namespace sidetable = ::pipline_diagnostics::sidetable;
     } // namespace impl

     inline void my_inline_function() {
       // namespace alias local to a function (or method).
       namespace bax = ::foo::bar::baz;
       ...
     }
   } // namespace librarian

- Do not use inline namespaces.

Unnamed Namespaces and Static Variables
=======================================

When definitions in a ``.cpp`` file do not need to be referenced outside that file, place them in an unnamed namespace or declare them ``static``. Do not use either of these constructs in ``.hpp`` files.

Definition:
  All declarations can be given internal linkage by placing them in unnamed namespaces, and functions and variables can be given internal linkage by declaring them ``static``. This means that anything you're declaring can't be accessed from another file. If a different file declares something with the same name, then the two entities are completely independent.

Decision:
  Use of internal linkage in ``.cpp`` files is encouraged for all code that does not need to be referenced elsewhere. Do not use internal linkage in ``.hpp`` files.

  Format unnamed namespace like named namespace in the terminating comment, leave the namespace name empty:

.. code-block:: c++

   namespace {
     ...
   } // namespace

Nonmember, Static Member, and Global Functions
==============================================

Prefer placing nonmember functions in a namespace; use completely global functions rarely. Prefer grouping functions within a namespace instead of using a class as if it were a namesapce. Static methods of a class should generally be closely related to instances of the class or the class's static data.

Pros:
  Nonmember and static member functions can be useful in some situations. Putting nonmember functions in a namespace avoids polluting the global namespace.

Cons:
  Nonmember and static member functions may make more sense as members of a new class, especially if they access external resources or have significant dependencies.

Decision:
  Sometimes it is useful to define a function not bound to a class instance. Such a function can be either a static member of a nonmember function. Nonmember functions should not depend on external variables, and should nearly always exist in a namespace. Rather than creating classes only to group static member functions which do not share static data, use `Namespaces`_ instead. For a header ``myproject/foo_bar.h``, for example, write

.. code-block:: c++

   namespace myproject {
     namespace foo_bar {
       void Function1();
       void Function2();
     } // namespace foo_bar
   } // namespace myproject

instead of

.. code-block:: c++

   namespace myproject {
     class FooBar {
      public:
       static void Function1();
       static void Function2();
     };
   } // namespace myproject

If you define a nonmember function and it is only needed in its ``.cpp`` file, use `Internal Linkage`_ to limit its scope.

Local Variables
===============

Place a function's variables in the narrowest scope possible, and initialize variables in the declaration.

C++ allows you to declare variables anywhere in a function. We encourage you to declare them in as local a scope as possible, and as close to the first use as possible. This makes it easier for the reader to find the declaration and see what type the variable is and what it was initialized to. In particular, initialization should be used instead of declaration and assignment, e.g.:

.. code-block:: c++

   int i;
   i = f(); // Bad -- initialization separate from declaration.

.. code-block:: c++

   int j = g() // Good -- declaration has initialization.

.. code-block:: c++

   std::vector<int> v;
   v.push_back(1); // Prefer initializing using brace initialization.
   v.push_back(2);

.. code-block:: c++

   std::vector<int> v = {1, 2}; // Good -- v starts initialized.

Variables needed for ``if``, ``while``, and ``for`` statements should normally be declared within those statements, so that such variables are confined to those scopes. E.g.:

.. code-block:: c++

   while (const char* p = strchr(str, '/')) str = p + 1;

There is one caveat: if the variable is an object, its constructor is invoked every time it enters scope and is created, and its destructor is invoked every time it goes out of scope.

.. code-block:: c++

   // Inefficient implementation:
   for (int i = 0; i < 1000000; ++i) {
     Foo f; // My ctor and dtor get called 1000000 times each.
     f.DoSomething(i);
   }

It may be more efficient to declare such a variable used in a loop outside that loop:

.. code-block:: c++

   Foo f; // My ctor and dtor get called once each.
   for (int i = 0; i < 1000000; ++i) {
     f.DoSOmething(i);
   }


Static and Global Variables
===========================

Variables of class type with `Static Sotrage Duration`_ are forbidden: they cause hard-to-find bugs due to indeterminate order of construction and destruction. However, such variables are allowed if they are ``constexpr``: they have no dynamic initialization or destruction.

Objects with static storage duration, including global variables, static variables, static class member variables, and function static variables, must be Plain Old Data (POD): only ints, chars, floats, or pointers, or arrays/structs of POD.

The order in which class constructors and initializers for static variables are called is only partially specified in C++ and can be even changed from build to build, which can cause bugs that are difficult to find. Therefor in addition to banning globals of class type, we do not allow non-local static variables to be initialized with the result of a function, unless that function (such as ``getenv()``, or ``getpid()``) does not itself depend on any other globals. However, a static POD variable within function scope may be initialized with a result of a function, since its initialization order is well-defined and does not occurs until control passes through its declaration.

Likewise, global and static variables are destroyed when the program terminates, regardless of whether the termination is by returning from ``main()`` or by calling ``exit()``. The order in which destructors are called is defined to be the reverse of the order in which the constructors were called. Since constructors order is indeterminate, so is destructor order. For Example, at program-end time a static variable might have been destroyed, but code still running -- perhaps in another thread -- tries to access it and fills. Or the destructor for a static ``string`` variable might be run prior to the destructor for another variable that contains a reference to that string.

One way to alleviate the destructor problem is to terminate the program by calling ``quick_exit()`` instead of ``exit()``. The difference is that ``quick_exit()`` does not invoke destructors and does not invoke any handlers that were registered by calling ``atexit()``. If you have a handler that needs to run when a program terminates via ``quick_exit()`` (flushing logs, for example), you can register it using ``at_quick_exit()``. (if you have a handler that need to run at both ``exit()`` and ``quick_exit()``, you need to register it in both places.)

As a result we only allow static variables to contain POD data. This rule completely disallows ``std::vector`` (use C arrays instead), or ``string`` (use ``const char []``).

If you need a static or global variable of a class type, consider initializing a pointer (which will never be freed), from either your ``main()`` function or from ``pthread_once()``. Noe that this must be a raw pointer, not a "smart" pointer, since the smart pointer's destructor will have the order-of-destructor issue that we are trying to avoid.
