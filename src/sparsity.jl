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
