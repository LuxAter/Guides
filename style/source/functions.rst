=========
Functions
=========

Parameter Ordering
==================

When defining a funciton, parameter order is: inputs, then output.

Parameters to C/C++ functions are either input to the funciton, outpput form the function, or both. Input parameters are usually values or ``const`` references, while output and input/output parameters will be pointes to non-``const``. When ordering function parameters, put all input-only parameters before any output parameters. In particular, do not add noew parameters to the end of the function just because they are new; place new input-only parameters before the output parameters.

This is not a hard-and-fast rule. Parameters that are both input and output (often classes/structs) muddy the waters, and, as always, consistency with related function may require you to bend the rule.

Write Short Functions
=====================

Prefer small and focused functions.

We recognize that long funcitons are somethimes appropriate, so no hard limit is placed on functions length. If a function exceeds about 40 lines, think about whether it can be broken up without harming the structure of the program.

Even if your long function works perfectly now, someone modifying it in a few months may add new behavior. This could result in bugs that are hard to find. Keeping your functions short and simple makes it easier for other people to read and modify your code.

You could find long and complicated functions when working with some code. DO not be intimidated by modifying existing code: if workin with such a function provides to be difficult, you find that erros are hard to debug, or you want to use a piece of it in several different contexts, consider breaking up the function into smaller and more manageable pieces.

Reference Arguments
===================

All parameters passed by reference must be labeled ``const``.

Definition:
  In C, if a funciton needs to modify a variable, the parameter must use a pointer, e.g. ``int foo(int *pval)``. In C++, the function can alternatively declare a reference parameter: ``int foo(int &val)``.

Pros:
  Defining a parameter as reference avoids ugly code like ``(*pval)++``. Necessary for some applicaitons like copy constructors. Makes it clear, unlike with pointers, that a null pointer is not a possible value.

Cons:
  References can be confusing, as they have value syntax but pointer semantics.

Decision:
  WIthin function parameter lists all references must be ``const``:

.. code-block:: c++

   void Foo(const string &in, string \*out);

In fact it is a very strong convention in Google code that input arguments are values or ``const`` references while output areguments are pointers. INput parameters may be ``const`` pointers, but we never allow non-``const`` refernce parameters except when required by convention, e.g., ``swap()``.

However, there are some instances where using ``const T*`` is perferable to ``const T&`` for input parameters. For example:
- You want to pass in a null pointer.
- The function saves a pointer or reference to the input.

Remember that most of the time input parameters are going to be specified as ``const T&`` using ``const T*`` instead communicates to the reader that the input is somehow treated differently. So if you choose ``const T*`` rather than ``const T&``, do so for a concrete reason; otherwise it will likely confuse readers by making them look for an explanation that doesn't exist.

Function Overloading
====================

Use overloaded functions (including constructors) only if a reader looking at a call site can get a good idea of what is happening without having to first figure out exactly which overload is being called.

Definition:
  You may write a funciton that takes a ``const string&`` and overload it with another that takes ``const char*``.

.. code-block:: c++

   class MyClass {
    public:
     void Analyze(const string &text);
     void Analyze(const car*text, size_t textleng);

Pros:
  Overloading can make code more intuitive by allowing an identically-named funciton to take different arguments. It may be necessary for templatized code, and it can be convenient for Visitors.

Cons:
  If a funciton is overloaded by the argument types alone, a reader may have to understand C++'s complex matching rules in order to tell what's going on. Also many people are confused by the semantics of inheritance if a derived class overides only some of the variants of a funciton.

Decision:
  If you want to overlad a funciton, consider qualifying th ename with some informaiton about the arguments, e.g., ``AppendString()``, ``AppendInt()`` rather than just ``Append()``. If you are overloading a function to support variable number of arguments of the same type, consider making it take a ``std::vector`` so that the use can use an `Initializer List`_ to specify the arguments.

Default Arguments
=================

Default arguments are allowed on non-virtual functions when the default is guaranteed to always have the same value. Follow the same restrictions as for `Function Overloading`_, and prefer overloaded functions if the readability gained with the default arguments doesn't outweigh the downsides below.

Pros:
  Often you have a funciton that uses default values, but occasionally you want to override the defaults. Default parameters allow an easy way to do this without having to define many funcitons for the rare exceptions. COmpared to overloading the funciton, default arguments have a cleaner syntax, with less boilerplate and a clearer distinction between 'required' and 'optional' arguments.

Cons:
  Defaulted arguments are another way to achieve the semantics of overloaded functions, so all the `Reasons not to overload functions`_ apply.

  THe default for arguemnts in a virtual funciton call are determined by the static type fo the target object and there's no guarantee that all overrides of a given function declare the same default.

  Default parameters are re-evaluated at each call site, which can bloat the generated code. Readers may also expect the default's value to be fixed at the declaration instead of varying at each call.

  Funciton pointers are confusing in the presence of default arguments, since the funciton signature often doesn't match the call signature. Adding function overloads avoid these problems.

Decision:
  Default arguments are banned on virtual funcitons, where they don't work properly, and in cases where the specified default might not evaluate to the same value depending on when it was evaluated. (For example, don't write ``void f(int n = counter++);``.)

  In some other cases, default arguments can imporve the readability of their function declarations enought to overcome the downsides about, so they are allowed. When in doubt, use overloads.

Trailing Return Type Syntax
===========================

Use trailing return types only where using th eordinary syntax (leading return types) is impractical or much less readable.

Definitions:
  C++ allows two different forms of function declarations. In ht older form, the return type appears before the funciton name. For example:

.. code-block:: c++

   int foo(int x);

The new form, introduced in C++11, uses the auto keyword before the function name and a trailing return type after the argument list. FOr example, the declaration above could equivalently be written:

.. code-block:: c++

   auto foo(int x) -> int;

The trailing return type is in the funciton's scope. THis doesn't make a difference for a simple case like ``int`` but in matters for more complicated cases, like types declared in calss scope or types wirtten in terms of the function parameters.

Pros:
  Trailing return types are the only wat to explicitly specify the return type of a `Lambda expression`_. In some cases the ecompiler is able to deduce a lambda's return type, but not in all cases. Even when the compiler can deduce it automatically, sometimes specifying it explicitly would be clearer for readers.

  Sometimes it's easier and more readable to specify a return type after the funciton's parameter list has already appeared. This si particularly true when the retrun type depends on template parameters. For example:

.. code-block:: c++

   template <class T, class U> auto add(T t, U u) -> decltype(t + u);

versus

.. code-block:: c++

   template <class T, class Y> decltype(declval<T&>() + declval<U&>()) add(T t, U u);

Cons:
  Trailing return type syntax is relatively new and it has no analoge in C++-like languages like C and Java, so some readers may find it unfamiliar.

  Existing code bases have an enormous number of function declarations that aren't going to get changed to use the new syntax, so the realistic choices are using the only syntax only or using a mixture of the two. Using a single version is better for uniformity of style.

Decision:
  In most cases, continue to use the older style of function declaration where the return type goes before the function name. Use the new trailing-return-type form only in cases where it's required (such as lambdas) or where, by putting the type after the function's  parameter list, it allows you to write the type in a much more readable way. The latter case should be rare; it's mostly an issue in fairly complicated template code, which is `discouraged in most cases`_.
