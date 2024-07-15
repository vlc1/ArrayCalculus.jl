"""

    Jacobian


"""
const Jacobian{N,O,S} = Diff{Tup{N},S,O}

const Jac = Jacobian

Base.print_without_params(::Type{<:Jac}) = false

# interface
#
#trim(::Type{<:Jac{N,O}}, dim, args) where {N,O} =
#    trim(O, dim, args)..., trim(O, Dim{N}(), args)...
#
#getindex(this::Ret{<:Jac{N,O}}, ind::Int...) where {N,O} =
#    getindex_jac(OperatorSupport(O, Dim{N}()), this, ind...)

#

#getindex_jac(::NullSupport, this, ::Int...) = zero(eltype(this))
#
#getindex_jac(::HasStencil, this::Ret{<:Jac{N,O}}, ind::Int...) where {N,O} =
#    getindex_jac(Stencil(O, Dim{N}()), this, ind...)
#
#function getindex_jac(f::Singleton{T}, this, ind::Int...) where {N,T<:NTup{N,Any}}
#    is = ind[begin:begin+N-1]
#    js = ind[begin+N:end]
#
#    neighbor = only(f(is))
#
#    ifelse(collocates(neighbor, js), getindex(this, neighbor), zero(eltype(this)))
#end

#=
# a little faster than generic implementation
function getindex_jac(st::LocalStencil, this, indices::Int...)
    is, js = half(indices)
    neighbor = only(eachneighbor(st, is))
    ifelse(collocates(neighbor, js), getindex(this, neighbor), zero(eltype(this)))
end

function getindex_jac(st::Stencil, this, indices::Int...)
    is, js = half(indices)
    hood = eachneighbor(st, is)
    getindex_neighbors(hood, this, js)
end

function getindex_neighbors(hood::Neighborhood, this, indices)
    res = iterate(hood)
    isnothing(res) && return zero(eltype(this))
    neighbor, state = res

    collocates(neighbor, indices) && return getindex(this, neighbor)

    getindex_neighbors(hood, this, indices, state)
end

function getindex_neighbors(hood::Neighborhood, this, indices, state)
    res = iterate(hood, state)
    isnothing(res) && return zero(eltype(this))
    neighbor, state = res

    collocates(neighbor, indices) && return getindex(this, neighbor)

    getindex_neighbors(hood, this, indices, state)
end
=#
