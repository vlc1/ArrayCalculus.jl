abstract type ArityStyle end

struct HasArity <: ArityStyle end
struct ArityUnknown <: ArityStyle end

"""

    Arity{N}

Number of arguments.


"""
struct Arity{N}

    Arity{N}() where {N} =
        (N ≥ 0 || error("Arity must be positive."); new{N}())
end

@inline dim(::Arity{N}) where {N} = N

const Nullarity = Arity{0}
const Unarity = Arity{1}

"""

An operator is a function that takes a variable number of `AbstractArray`s as input and returns another `AbstractArray`.


"""
abstract type Operator{S} <: Function end

Arity(::Type{<:Operator{S}}) where {S} = S()

Arity(::O) where {O<:Operator} = Arity(O)

ArityStyle(::Type{<:Operator}) = HasArity()
ArityStyle(::Type) = ArityUnknown()

ArityStyle(::O) where {O<:Operator} = ArityStyle(O)


# Nullary operator should implement eltype and axes

const Nullary = Operator{Nullarity}
const Unary = Operator{Unarity}
const Ary{N} = Operator{Arity{N}}

# interface

getindex(this::Nullary, args...) =
    _getindex_sparsity(OperatorSparsity(this), this, args...)

