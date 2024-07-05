abstract type OperatorStyle end

struct ArityUnknown <: OperatorStyle end
struct HasArity{N} <: OperatorStyle end

const Nullarity = HasArity{0}
const Unarity = HasArity{1}
#const Binarity = HasArity{2}
#const Ternarity = HasArity{3}
#const Quaternarity = HasArity{4}

"""

An operator is a function that takes a variable number of `AbstractArray`s as input and returns another `AbstractArray`.


"""
abstract type Operator{S} <: Function end

OperatorStyle(::Type{<:Operator{S}}) where {S} = S()

OperatorStyle(::O) where {O<:Operator} = OperatorStyle(O)

abstract type Primitive{S} <: Operator{S} end

#=
"""

    AbstractAry{N}

Abstract type for operators supporting exacty `N` arguments.


"""
abstract type AbstractAry{N} <: Operator end

=#
const Nullary = Operator{Nullarity}
const Unary = Operator{Unarity}
#const Binary = Operator{Binarity}
#const Ternary = Operator{Ternarity}
#const Quaternary = Operator{Quaternarity}
#const Ary{N} = Operator{HasArity{N}}

# interface
#
#(::AbstractAry{N})(::NTup{N,AArr}, ::Int...) where {N} = throw(UndefinedMethod())

#=
"""

"""
struct Ary{N,O<:Operator} <: AbstractAry{N}
    op::O

    Ary{N}(this::AbstractAry{N}) where {N} = this
    Ary{N}(this::AbstractAry) where {N} = throw("Conflicting arities.")
    Ary{N}(this::O) where {N,O<:Operator} = new{N,O}(this)
end

operator(this::Ary) = this.op

(this::Ary{N})(args::NTup{N,AArr}, I::Int...) where {N} = operator(this)(args, I...)
=#
