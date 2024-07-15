"""

    Forward

Application of a binary function (`f`) on a forward stencil.

!!! note

    Factor this and `Backward` into any type of stencil by introducing a `StencilOperator` once a clearly idea of the implementation.


"""
struct Forward{N,F<:Function} <: Ary{1}
    f::F

    Forward{N}(f::F) where {N,F<:Function} = new{N,F}(f)
    Forward(::Dim{N}, f) where {N} = Forward{N}(f)
end

# accessors

Dim(::Forward{N}) where {N} = Dim{N}()

handle(this::Forward) = this.f

# interface

@inline @propagate_inbounds function getindex(this::Ret{O}, I::Varg{Any,N}) where {N,M,O<:Forward{M}}
    op = operator(this)
    x = only(arguments(this))
    f = handle(op)

    J = ntuple(d -> ifelse(isequal(d, M), I[d]+1, I[d]), Val(N))

    f(x[I...], x[J...])
end
#
## jacobian
#
#OperatorSparsity(::Type{<:Jac{1,<:Forward}}) = HasStencil()
#Stencil(::Type{<:Jac{1,,<:Forward{N}}}) where {N} = LinearStencil{N,0,2}()


"""

    Backward

Application of a binary function (`f`) on a backward stencil.

!!! note

    Factor this with `Forward` for arbitrary stencil.


"""
struct Backward{N,F<:Function} <: Ary{1}
    f::F

    Backward{N}(f::F) where {N,F<:Function} = new{N,F}(f)
    Backward(::Dim{N}, f) where {N} = Backward{N}(f)
end

# accessors

Dim(::Backward{N}) where {N} = Dim{N}()

handle(this::Backward) = this.f

# interface

@inline @propagate_inbounds function getindex(this::Ret{O}, I::Varg{Any,N}) where {N,M,O<:Backward{M}}
    op = operator(this)
    x = only(arguments(this))
    f = handle(op)

    J = ntuple(d -> ifelse(isequal(d, M), I[d]-1, I[d]), Val(N))

    f(x[I...], x[J...])
end
