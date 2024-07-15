abstract type Stencil end

Stencil(::Type) = error("Not implemented.")

Stencil(::T) where{T} = Stencil(T)


"""

    LocalStencil


"""
struct LocalStencil <: Stencil end

eachneighbor(::LocalStencil, args::TupN{Int}) = LocalHood(args)

# interface

# a little faster than generic implementation
function _getindex_stencil(st::LocalStencil, this, args...)
    left, right = half(args)
    neighbor = only(eachneighbor(st, left))
    ifelse(collocates(neighbor, right), getindex(this, neighbor), zero(eltype(this)))
end


"""

    LinearStencil{D,S,L}


"""
struct LinearStencil{D,S,L} <: Stencil end

eachneighbor(::LinearStencil{D,S,L}, args::TupN{Int}) where {D,S,L} =
    LinearHood{D,S,L}(args)

# interface

# generic implementation
function _getindex_stencil(st::Stencil, this, args...)
    left, right = half(args)
    hood = eachneighbor(st, left)
    _getindex_neighbor(hood, this, right)
end
