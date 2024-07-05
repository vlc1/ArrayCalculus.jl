module ArrayOperations

using Base.Cartesian

import Base: size,
             getindex

using TupleTools

export Dim,
       ∇,
       ∂,
       Arity,
       Operator,
       OperatorSupport,
       NullSupport,
       HasStencil,
       Stencil,
       PointWise,
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
include("supports.jl")
include("stencils.jl")
include("returned.jl")
include("loosened.jl")
include("derivatives.jl")
include("jacobians.jl")
include("hessians.jl")
include("operations.jl")

end
