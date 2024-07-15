module ArrayOperations

using Base: @propagate_inbounds,
            tail

import Base: eltype,
             length,
             iterate,
             first,
             tail,
             isdone,
             size,
             getindex,
             *,
             +,
             -

using Base.Cartesian

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
       OperatorSparsity,
       NullOperator,
       HasStencil,
       Stencil,
       LocalStencil,
       LinearStencil,
       Ary,
       operator,
       Ret,
       Jac,
       Hess,
       Operation,
       Forward,
       Backward,
       ⊙,
       Scaled

struct Dim{N} end
#
#struct WithRespectTo{N} <: Function end
#
#const ∂ = WithRespectTo
#
#Base.print_without_params(::Type{<:∂}) = false

include("aliases.jl")
include("utils.jl")
include("exceptions.jl")
include("operators.jl")
include("neighbors.jl")
include("sparsity.jl")
include("stencils.jl")
include("returned.jl")
include("nablas.jl")
include("operations.jl")
include("primitives.jl")
include("pointwise.jl")
include("scaled.jl")

end
