module ArrayOperations

using Base: @propagate_inbounds

import Base: eltype,
             size,
             getindex,
             *,
             +,
             -

using Base.Cartesian
#
#import Base.Broadcast: broadcasted

using TupleTools,
      StaticArrays,
      Symbolics

import Symbolics: arguments

export Dim,
       ∇,
#       ∂,
       Arity,
       Operator,
       OperatorSupport,
       NullSupport,
       HasStencil,
       Stencil,
       Singleton,
#       Stencil,
#       PointWise,
#       Primitive,
       Ary,
#       AbstractAry,
#       ArityUnknown,
       operator,
#       arguments,
       Ret,
#       Loose,
#       derive,
       Jac,
       Hess,
#       Partially,
#       Fully,
       Operation,
       Forward,
       Backward,
       ⊙,
#       Broadcasted,
       Scaled

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
#include("loosened.jl")
include("returned.jl")
#include("partials.jl")
include("nablas.jl")
include("jacobians.jl")
include("hessians.jl")
include("operations.jl")
include("primitives.jl")
include("pointwise.jl")
include("scaled.jl")

end
