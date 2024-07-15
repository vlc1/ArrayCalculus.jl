abstract type OperatorDependence end

struct DependenceUnknown <: OperatorDependence end
struct IsIndependent <: OperatorDependence end
struct HasDependence <: OperatorDependence end

OperatorDependence(::Type, _...) = DependenceUnknown()

OperatorDependence(::T, args...) where {T} = OperatorDependence(T, args...)

dependence(::Type, _...) = error("Not implemented.")

dependence(::T, args...) where {T} = dependence(T, args...)

function trim(op, dim, args)
    ntuple(length(args)) do n
        trim(op, dim, Dim{n}(), args[n])
    end
end

function trim(op, dim, dim′, arg)
    style = OperatorDependence(op, dim, dim′) 
    _trim(style, op, dim, dim′, arg)
end

_trim(::IsIndependent, args...) = last(args)

function _trim(::HasDependence, op, dim, dim′, arg)
    indices = dependence(op, dim, dim′) 
    __trim(indices, arg)
end

__trim(::SUnitRange{S,L}, arg::AURange) where {S,L} =
    range(first(arg) - min(S, 0), last(arg) - max(S+L, 0))

#=

abstract type OperatorSparsity end

struct SparsityUnknown <: OperatorSparsity end
struct IsDense <: OperatorSparsity end
struct HasStencil <: OperatorSparsity end

OperatorSparsity(::Type, _...) = SparsityUnknown()

OperatorSparsity(::T, args...) where {T} = OperatorSparsity(T, args...)
=#
