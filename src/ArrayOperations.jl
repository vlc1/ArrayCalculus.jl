module ArrayOperations

import Base: size,
             getindex

export ∂,
       Operator,
       Primitive,
#       AbstractAry,
       HasArity,
       ArityUnknown,
       operator,
       arguments,
       Ret,
       Loose,
       derive,
       Jac,
       Operation

struct WithRespectTo{N} <: Function end

const ∂ = WithRespectTo

Base.print_without_params(::Type{<:∂}) = false

include("aliases.jl")
include("exceptions.jl")
#include("arity.jl")
include("operators.jl")
#include("sparsity.jl")
include("loosened.jl")
include("returned.jl")
include("jacobian.jl")
include("operations.jl")

end
