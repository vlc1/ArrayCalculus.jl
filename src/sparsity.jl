"""

    OperatorSparsity


"""
abstract type OperatorSparsity end

struct IsDense <: OperatorSparsity end
struct NullOperator <: OperatorSparsity end
struct HasStencil <: OperatorSparsity end

# by default, assume operator is dense
OperatorSparsity(::Type) = IsDense()

OperatorSparsity(::T) where {T} = OperatorSparsity(T)

# interface

_getindex_sparsity(::IsDense, _...) = error("Not implemented.")
_getindex_sparsity(::NullOperator, this, _...) = zero(eltype(this))
_getindex_sparsity(::HasStencil, this, args...) =
    _getindex_stencil(Stencil(this), this, args...)
