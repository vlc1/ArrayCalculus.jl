struct Returned{O<:Operator,A<:TupN{Union{Nullary,AArr}}} <: Nullary
    op::O
    args::A

    Returned(op::O, args::A) where {N,O<:Ary{N},A<:NTup{N,Union{Nullary,AArr}}} =
        new{O,A}(op, args)
end

const Ret = Returned

Base.print_without_params(::Type{<:Ret}) = false

# accessors

operator(this::Ret) = this.op
arguments(this::Ret) = this.args

# constructor

(this::Ary{N})(args::Varg{Any,N}) where {N} = Returned(this, args)

(this::Nullary)() = this

# traits

OperatorSparsity(::Type{<:Ret{O}}) where {O} = OperatorSparsity(O)

Stencil(::Type{<:Ret{O}}) where {O} = Stencil(O)

#

eltype(this::Ret) = Base.promote_eltype(arguments(this)...)
#
#function axes(this::Ret{O,A}) where {O,N,A<:NTup{N,Any}}
#    args = arguments(this)
#    f = Broadcast.BroadcastFunction(intersect)
#
#    mapreduce(f, eachindex(args), args) do n, arg
#        trim(O, Dim{n}(), axes(arg))
#    end
#end

# move somewhere else

getindex(this::Nullary, args...) =
    _getindex_sparsity(OperatorSparsity(this), this, args...)

_getindex_sparsity(::IsDense, _...) = error("Not implemented.")
_getindex_sparsity(::NullOperator, this, _...) = zero(eltype(this))
_getindex_sparsity(::HasStencil, this, args...) =
    _getindex_stencil(Stencil(this), this, args...)

# a little faster than generic implementation
function _getindex_stencil(st::LocalStencil, this, args...)
    left, right = half(args)
    neighbor = only(eachneighbor(st, left))
    ifelse(collocates(neighbor, right), getindex(this, neighbor), zero(eltype(this)))
end

# generic implementation
function _getindex_stencil(st::Stencil, this, args...)
    left, right = half(args)
    hood = eachneighbor(st, left)
    _getindex_neighbor(hood, this, right)
end

function _getindex_neighbor(hood::Neighborhood, this, arg)
    res = iterate(hood)
    isnothing(res) && return zero(eltype(this))
    neighbor, state = res

    collocates(neighbor, arg) && return getindex(this, neighbor)

    _getindex_neighbor(hood, this, arg, state)
end

function _getindex_neighbor(hood::Neighborhood, this, arg, state)
    res = iterate(hood, state)
    isnothing(res) && return zero(eltype(this))
    neighbor, state = res

    collocates(neighbor, arg) && return getindex(this, neighbor)

    _getindex_neighbor(hood, this, arg, state)
end
