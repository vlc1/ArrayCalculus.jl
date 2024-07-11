"""

    Operation(op, rngs)

Lazy representation of the application of a `Nullary` operator to a ranges.

!!! note

    `Operation` indexing is **one-based**.


"""
struct Operation{T,N,O<:Nullary,R<:NTuple{N,AURange}} <: AArr{T,N}
    op::O
    rngs::R

    function Operation(op::O, rngs::R) where {N,O<:Nullary,R<:NTuple{N,AURange}}
#        all(issubset.(rngs, axes(op))) || error("Invalid ranges.")

        T = Base._return_type(getindex, Tuple{O,Vararg{Int,N}})
        new{T,N,O,R}(op, rngs)
    end
end

# accessors

operator(this::Operation) = this.op
ranges(this::Operation) = this.rngs

# constructor

getindex(op::Nullary, rngs::AURange...) = Operation(op, rngs)

getindex(op::Nullary, ::Colon...) = Operation(op, axes(op))

# array interface

size(this::Operation) = length.(ranges(this))

function getindex(this::Operation{T,N}, I::Varg{Int,N}) where {T,N}
    J = getindex.(ranges(this), I)
    getindex(operator(this), J...)
end

# broadcasting interface

broadcastable(this::Nullary) = getindex(this, axes(this)...)
