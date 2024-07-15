module ArrayOperations

using Base: @propagate_inbounds,
            tail

import Base: eltype,
             length,
             iterate,
             first,
             tail,
             isdone,
#             length,
             size,
#             axes,
             getindex,
             *,
             +,
             -
#
#import Base.Broadcast: broadcastable

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
       Neighbor,
       collocates,
       origin,
       eachneighbor,
       LocalNeighborhood,
       LinearNeighborhood,
#       OperatorSupport,
#       NullSupport,
       OperatorSparsity,
       NullOperator,
       HasStencil,
       Stencil,
#       Singleton,
       LocalStencil,
       LinearStencil,
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
include("utils.jl")
include("exceptions.jl")
#include("arity.jl")
include("operators.jl")
include("neighbors.jl")
#include("supports.jl")
include("sparsity.jl")
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
