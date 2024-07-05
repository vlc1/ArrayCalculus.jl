module ArrayOperations

import Base: size,
             getindex

using TupleTools

export Dim,
       ∇,
       ∂,
       Arity,
       Operator,
       Primitive,
#       AbstractAry,
#       ArityUnknown,
       operator,
       arguments,
       Ret,
       Loose,
#       derive,
       Jac,
       Hess,
       Operation

# Dim?
#struct WithRespectTo{N} <: Function end
struct Dim{N} end
#
#const ∂ = WithRespectTo
#
#Base.print_without_params(::Type{<:∂}) = false

include("aliases.jl")
include("exceptions.jl")
#include("arity.jl")
include("operators.jl")
#include("sparsity.jl")
include("returned.jl")
include("loosened.jl")
include("derivatives.jl")
include("operations.jl")

end
