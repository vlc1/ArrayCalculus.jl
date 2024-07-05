"""

An operator is a function that takes a variable number of `AbstractArray`s as input and returns another `AbstractArray`.


"""
abstract type Operator <: Function end

"""

    Ary{N}

Abstract type for operators supporting exacty `N` arguments.


"""
abstract type Ary{N} <: Operator end

const Nullary = Ary{0}
const Unary = Ary{1}
const Binary = Ary{2}

# interface

(::Ary{N})(::NTup{N,AArr}, ::Int...) where {N} = throw(UndefinedMethod())
