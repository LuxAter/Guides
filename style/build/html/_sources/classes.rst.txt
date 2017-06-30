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

Inheritance
===========

Multiple Inheritance
====================

Interfaces
==========

Operator Overloading
====================

Access Control
==============

Declaration Order
=================
