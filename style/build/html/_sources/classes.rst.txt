=======
Classes
=======

Classes are the fundamental unit of code in C++. Naturally, we use them extensively. This section lists the main dos and don'ts you should follow when writing a class.

Doing work in Constructors
==========================

Avoid virtual method calls in constructors, and avoid initialization that can fail if you can't signal an error.

Definition:
  It is possible to preform arbitrary initialization in the body of the constructor.

Pros:
  - No need to worry about whether the class has been initialized or not.
  - Objects that are fully initialized by constructor call can be ``const`` and may also be easier to use with standard containers or algorithms.

Cons:
  - I the work calls virtual functions, these calls will not get dispatched to the subclass implementations. Future modification to you class can quietly introduce this problem even if your class is not currently subclassed, causing much confusion.
  - There is no easy way for constructors to signal errors, short of crashing the program (not always appropriate) or using exceptions (which are 'forbidden'_).
  - If the work failed, we now have an object whose initialization cod failed, so it may be unusual state requiring a ``bool IsBalid()`` state checking mechanism (or similar) which is easy to forget to call.
  - You cannot take the address of a constructor, so whatever work is done in the constructor cannot easily be handed off to, for examples, another thread.

Decision:
  Constructors should never call virtual functions. If appropriate for your code, terminating the program may be an appropriate error handling response. Otherwise, consider a factory function or ``Init()`` method. Avoid ``Init()`` methods on objects with no other states that affect which public methods may be called (semi-constructed objects of this form are particularly hard to work with correctly).

Implicit Conversions
====================

Do not define implicit conversions. Use the ``explicit`` keyword for conversion operators and single-argument constructors.

Definition:
  Implicit conversions allow an object of one type (called the source type) to be used where a different type (called the destination type) is expected, such as when passing an ``int`` argument to a function that takes a ``double`` parameter.

  In addition to the implicit conversions defined by the language, users can define their own, by adding appropriate members to the class definition of the source or destination type. An implicit conversion in the source type is defined by a type conversion operator named after the destination type (e.g. ``operator bool()``). An implicit conversion in the destination type is defined by a constructor that can take the source type as its only argument (or only argument with no default value).

  The ``explicit`` keyword can be applied to a constructor of (since C++11) a conversion operator, to ensure that it can only be used when the destination type is explicit at the point of use, e.g. with a cast. This applies not only for implicit conversion, but to C++11's list initialization syntax:

.. code-block:: c++
   
   class Foo {
     explicit Foo(int x, double y);
     ...
   };

   void Func(Foo f);

   Func({42, 3.14}); // Error

This kind of code isn't technically an implicit conversion, but the language treats it as one as far as ``explicit`` is concerned.

Pros:
  - Implicit conversions can make a type more usable and expressive by eliminating the need to explicitly name a type when it's obvious.
  - Implicit conversion can be a simpler alternative to overloading.
  - List initialization syntax is a concise and expressive way of initializing objects.

Cons:
  - Implicit conversion can hide type-mismatch bugs, where the destination type does not match the user's expectation, or the user is unaware that any conversion will take place.
  - Implicit conversions can make code harder to read, particularly in the presence of overloading, by making it less obvious what code is actually getting called.
  - Constructors that take a single argument may accidentally be usable as implicit type conversions, even if they are not intended to do so.
  - When a single-argument constructor is not marked ``explicit``, there's no reliable way to tell whether it's intended to define an implicit conversion, or the author simply forgot to mark it.
  - It's not always clear which type should provide the conversion, and if they both do, the code becomes ambiguous.
  - List initialization ca suffer form the same problems if the destination type is implicit, particularly if the list has only a single element.

Decision:
  Type conversion operators, and constructors that are callable with a single argument, must be marked ``explicit`` in the class definition.  As an exception, copy and move constructors should not be ``explicit``, since they do not preform type conversion. Implicit conversion can sometimes be necessary and appropriate for types that are designed to transparently wrap other types. In that case, contact you project leads to request a waiver of this rule.

  Constructors that cannot be called with a single argument should usually omit ``explicit``. Constructors that take a single ``std::initializer_list`` parameter should also omit ``explicit``, in order to support copy-initialization (e.g. ``MyType m = {1, 2};``)

Copyable and Movable Types
==========================

Support copying and/or moving if these operattions are clear and meaningful for your type. Otherwise, disable the implicityly generated special funcitons that preform copies and moves.

Definition:
  A copyable type allows its objects to be initialized or assigned from any other object of the same type, the copy behavior is defined by the copy constructor and the copy-assignment operator. ``string`` is an example of a copyable type.

  A movable type is one that can be initialized and assigned from temporaries (all copyable types are therefor movable). ``std::unique_ptr<int>`` is an example of a movable but not copyable type. For user-defined types, the move behavior is defined by the move constructor and the move-assignment operator.

  THe copy/move constructors can be implicity invoked by the computer in soem situations, d.g. when passing object by value.

Pros:
  Objects of copyable and movable types can be passed and returned by value, which makes APIs simpler, safer, and more general. Unlike when passing objects by pointer or reference, there's no risk of confusin or ownership, lifetime, mutability, and similar issues, and no need to specify them in the contract. It also prevents non-local interactions between the client and the implementation, which makes them easier to understand, maintain, and optimize by the compiler. FUrther, such objects can be used with generic APIs additional flexibility in e.g., type composition.

  Copy/move constructors and assignment operators are usually easier to define correctly than alternitives like ``Clone()``, ``CopyFrom()``, or ``Swap()``, because they can be generated by the compiler, either implicity or with ``= default``. They are concise, and ensure that all data members are copied. Copy and move constructors are also generally more efficent, because they don't require heap allocation or seperate initialization and assignment steps, and they're eligible for optimizations such as `Copy Elison`_.

  Move operators alow the implicit and efficient transfer of resources out of rvalue objects. this allows a plainer coding style in some cases.

Cons:
  Some types do not need to be copyable, and providing copy operators for such types can be confusing, nonsensical, or outright incorrect. Types representing singleton objects (``Registerer``), objects tied to specific scope (``Cleanup``), or closely coupled to object identity (``Mutex``) cannot be copied meaningfully. COpy opeations for base class types that are to be used poymorphically are hazardous, because use of them can lead to `Object Slicing`_. Defaulted or carelessly-implemented copy operations can be incorrect, and the resulting bugs can be confusing and difficult to diagnose.

  COpy constructros are invoked implicity, which makes the invocation easy to miss. THis may cause confusion for programmers used to languages where pass-by-referce is conventional or mandatory. It may also encourage excessive copying, which can cuase preformeance problems.

Decision:
  Provide the copy and move operations if their meaning is clear to a casual user and the copy/moving does not incur unexpected costs. If you define a copy or move constructor, define the corresponding assignment operator, and vice-versa.If your type is copyable, do not define move operations unless they are significantly more efficient thatn the corresponding copy operations. If your type is not copyable, but the conrrectness of a move is obvious to users of the type, you may make the type move-only by defining both of the move operations.

  If your type provides copy operations, it is recommended that you design your class so that the default implementation of those operations is correct. Remember to review the correctness of any defaulted operations as you would any other code, and to document that your class is copyable and/or cheaply movable if that's and API guarantee.

.. code-block:: c++

   class Foo {
    public:
     Foo(Foo&& other) : field_(other.field) {}
     // Bad, defines only move constructor, but not operator=.

    private:
     Field field_;
   };
  
Due to the risk of slicing, avoid providing an assignment operator or public copy/move constructor for a class that's intended to be derived from (and avoid deriving form a class with such members). If your base class needs to be copyable, provide a public virtual ``Clone()`` method, and a protected copy constructor that derived classes can use to implement it.

If you do not want to support copy/move operations on your type, explicity disable them using ``= delete`` in the ``public:`` section:

.. code-block:: c++

   // MyClass is neither copyable nor movable.
   MyClass(const MyClass&) = delete;
   MyClass& operator=(const MyClass&) = delete;

Structs vs. Classes
===================

Use a ``struct`` only for passive objects that carry data; everything else is a ``class``.

The ``struct`` and ``class`` keywords behave almost identically in C++. We add our own semantic meanings to each keyword, so you should use the appropriate keyword for the data-type your defining.

``struct``\s should be used for passive objects that carry data, and may have associated constants, but lack any funcionality other than access/setting the data members. The access/setting of fields is done by directly accessing the fields rather than through method invocations. Methods should not provide behavior by should only be used to set up the data members e.g., ``constructor``, ``destructor``, ``Initialize()``, ``Reset()``, ``Validate()``.

If more functionality is required, a ``class`` is more appropriate. If in doubt, make it a ``class``.

Conf consistency with Stl you can use ``struct`` instead of ``class`` for functor and traits.

Note that member variables in structs and classes have `Different Naming Rules`_.

Inheritance
===========

Composition is often more appropriate than inheritance. When using inheritance, make it ``public``.

Definition:
  When a sub-class inherits form a base class, it includes the definitions of all the data and operations that the parent base class defines. In practice, inheritance is used in two major ways in C++: implementation inheritance, in which actual code is inherited by the child, and `Interface Inheritance`_, in which only method names are inherited.

Pros:
  Implementation inheritace reduces code size by re-using the base class code as it specializes an existing type. Because inheritance is a compile-time declaration, you and the compiler can understand the operation and detect errors. Interface inheritance can be used to programmatically enforce that a class expose a particular API. Again th ecompiler can detect errors, in this  case, when a class does not define a necessary method of the API.

Cons:
  For implementation inheritance, because the code implementing a sub-class is spread between the base and the sub-class, it can be more difficult to understand an implementation. The sub-class cannot override functions that are not virtual, so the sub-class cannot change implementation. The base class may also define some data members, so that specifies phyical layout of the base class.

Decision:
  All inheritance should be ``public``. If you want to do ``private`` inheritance, you should be including an instance of the base class as a member instead.

  Do not overuse implementation inheritance. Composition is often more appropriate. Try to restrict usse of inheritance to the "is-a" case: ``Bar`` subclasses ``Foo`` if it can reasonably be said that ``Bar`` "is a kind of" ``Foo``.

  Make your destructor ``virtual`` if necessary. If your class has ``virtual`` methods, itd destructor should be ``virtual``.

  Limit the use of ``protected`` to those member functions that might need to be accessed from subclasses. Not that `Data Members Should Be Private`_.

  Explicitly annotate overrides of virtual functions or virtual destructors with an override or (less frequently) final specifier. Older (pre-C++11) code will ue the ``virtual`` keyword as an inferior alternative annotation. For clarity, use exactly one of ``override``, ``final``, or ``virtual`` when declaring an override. Rational: A function or destructor marked override or final that isnot an override of a base class virtual function will not compile, and this helps catch common errors. THe specifiers serve as documentation; if no specifier is present, the reader has to check all ancestors of the class in question to tdetermin if the function or destructor is virtual or not.

Multiple Inheritance
====================

Only very rarely is multiple implementation inheritance actually useful. We allow multiple inheritance only when at most one of the base classes has an implementation; all other base classes must be `Pure Interface`_ classes tagged with the ``Interface`` suffix.

Definition:
  Multiple inheritance allows a sub-class to have more than one base class. We distinguish between base classes that are *pure interfaces* and those that have *implementation*.

Pros:
  Multiple implementation inheritance may let you re-use even more code than single inheritance (see `Inheritance`_).

Cons:
  Only very rarely is multiple *implementation* inheritance actually useful. When multiple implementation inheritance seems like the solution, you can usually find a different, more explicit, and cleaner solution.

Decision:
  Muliple inheritance is allowed only when all superclasses, with the possible exception of the first one, are `Pure Interfaces`_. In order to ensure that they remain pure interfaces, they must end with the ``Interface`` suffix.

Interfaces
==========

Classes taht satisfy certain conditions are allowed, but not required, to end with the ``Interface`` suffix.

Definition:
  A class is a pure interface if it meets the following requirements:
  
  - It has only public pure virtual ("= 0") methods and static methods (but see below for destructor).
  - It may not have non-static data members.
  - It needs not have any constructors defined. If a constructor is provided, it must take no arguments and must be protected.
  - If it is a subclass, it may only be derived from classes that satisfy these conditions and are tagged with the ``Interface`` suffix.

  An interface class can never be directly instantiated because of the pure virtual method(s) it declares. To make sure all implementations of the interface can be destroyed correctly, the interface must also declare a virtual destructor (in an exception to the first rule, this dhouls not be pure).

Pros:
  Tagging a class with the ``Interface`` suffix lets other know that they must not add implemented methods or non static data members. This is particularly important in the case of `Multiple Inheritance`_. Additionally, the interface concept is already well-understood by Java programmers.

Cons:
  The ``Interface`` suffix lengthens the class name, which can make it harder to read and understand. Also, ther interface property may be considered an implementation detail that shouldn't be exposed to clients.

Decision:
  A class may end with ``Interface`` only if it meets that aboce requierments. We do not require the converse, however: classes that meet the above requirements are not required to end with ``Interface``.

Operator Overloading
====================

Overload operators judiciously. Do not create user-defined literals.

Definition:
  C__ permits user code to `Declare Overloaded Versions of the Build-in Operators`_ using the ``operator`` keyword, so long as one of the parameters is a user-defined type. the ``operator`` keyword also permits user code to define new kinds of literals using ``operator" "``, and to define type-conversion funcitons such as ``operator bool()``.

Pros:
  Operator overloading can make code more concise and intuitaive by enabling user-defined types to behave the same as built-in types. Overloading operators are the idiomatic names for certain operations (e.g. ``==``, ``<`` , ``=``, and ``<<``), and adhering to those conventions can make user-defined types more readable and enable them to interoperate with libraries that expect those names.

  User-defined literals are a vary concise notation for creating objects of user-defined types.

Cons:
  - Providing a correct, consistent, and unsurprising set of operator overloads requires some care, and failure to do so can lead to confusion and bugs.
  - Overuse of operators can lead to obfuscated code, particularly if the overloaded operator's semantics don't follow convention.
  - The hazards of function overloading apply just as mutch to operator overloading, if not more so.
  - Operator overloads can fool our intuition into thinking that expensive operations are cheap, built-in operations.
  - Finding the call sites for overloaded operators may require a search tool that's aware of C++ syntacx, reather than e.g. grep.
  - If you get the argument type of an overloaded operator wrong, you may get a different overload rather than a compiler error. For ecample, ``foo < bar`` may do one thing, while ``&foo < &bar`` does something totally different.
  - Certain operator overloads are inherently hazardous. Overloading unary & can cause the same code to have different meanings depending on whether the overload declaration is visible. Overloads of ``&&``, ``||``, and ``,`` cannot match the evaluation-order semantics of the built-in operators.
  - Operators are often defined outside the class, so there's a risk of different files introducing different definitions of the same operator. If both definitions are linked inot the same binary, this result is undefined behavior, which can manifest as subtle run-time bugs.
  - User-defined literals allow the creation of new syntactic forms that are unfamiliar even to experienced C++ programmers.

Decision:
  Define overloaded operators only if their meaning is obvious, unsurprising, nad consistent with the corresponding built-in operators. For example, use ``|`` as a bitwise- or logical-or, not as a shell-style pipe.

  Define operators only on your own types. More precisely define them in the same headers, ``.cpp`` files, and namespaces as the types they operate on. That way, the operators are available wherever the type is, minimizing the risk of multiple definitions. If possible, avoid defining operators as templates, because they must satisfy this rule for any possible template arguments. If you define an operator, also define any related operators that make sense, and make sure they are defined consistently. For example, if you overload ``<``, overload all the comparison operators, and make sure ``<`` and ``>`` never return ``true`` for the same arguments.

  Prefer to define non-modifying binary operators as non-member functions. If a binary operator is defined as a class member, implicit conversions will apply to the right-hand argument, but not the left one. It wil confuse your users if ``a < b`` compiels bu ``b < a`` doesn't.

  Don't go out of your way to avoid defining operator overloads. For example, preer to define ``==``, ``=``, and ``<<``, rather than ``Equals()``, ``CopyFrom()``, and ``PrintTo()``. Conversely, don't define operator overloads just because other libraries expect them. FOr example, if your type doensn't have a natural ordering, but you want to store it in a ``std::set``, use a custom comparator rather than overloading ``<``.

  Do not overload ``&&``, ``||``, ``,``, or unary ``&``. Do not overload ``operator" "``, i.e. do not introduce user-defined literals.

  Type conversion operators are covered in the section on `Implicit Conversions`_. The ``=`` operator is covered in the section on `Copy Constructors`_. Overloading ``<<`` for use with streams is convered in the section on `Streams`_. See also the rules on `Function Overloading`_, which apply to operator overloading as well.

Access Control
==============

Make data members ``private`` unless they are ``static const`` (and follow the `Naming Convention for Constants`_). FOr technical reasons, we allow data members of a test fixture class to be ``protected`` when using `Google Test`_.

Declaration Order
=================

Group similar declarations together, placing public parts earlier.

A class definition should usually start with a ``public:`` section, followed by ``protected:``, then ``private:``. Omit sections that would be empty.

Within each section, generally prefer grouping similar kinds of declarations together, and generally prefer the following order: types (including ``typedef``, ``using``, and nested structs and classes), constants, factory functions, constructors, assignment operators, destructor, all other methods, data members.

Do not put large method definitions inline in the class definition. Usually, only trivial or preformance-critical, and very short, methods may be defined inline. See `Inline Functions`_ for more details.
