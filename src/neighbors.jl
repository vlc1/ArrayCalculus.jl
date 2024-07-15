"""

    Neighbor{N,NTuple{N,::Int}}


"""
struct Neighbor{N,T<:Tup}
    I::NTup{N,Int}

    Neighbor{T}(args::NTup{N,Int}) where {N,T<:NTup{N,Any}} = new{N,T}(args)
end

# accessors

origin(this::Neighbor) = this.I

Tuple(this::Neighbor{N,T}) where {N,T} = origin(this) .+ fieldtypes(T)

# interface

getindex(this::Neighbor{N,T}, i::Int) where {N,T} =
    getindex(Tuple(this), i) + fieldtype(T, i)

Base.IteratorSize(::Neighbor) = Base.HasLength()

Base.IteratorEltype(::Neighbor) = Base.HasEltype()

eltype(::Type{<:Neighbor}) = Int

length(::Neighbor{N}) where {N} = N

isdone(this::Neighbor, state::Neighbor=this) =iszero(length(state))

iterate(::Neighbor, ::Neighbor{0,Tuple{}}) = nothing

function iterate(this::Neighbor, state::Neighbor{N,T}=this) where {N,T}
    el, args... = origin(state)
    el + fieldtype(T, 1), Neighbor{Tuple{tail(fieldtypes(T))...}}(args)
end

collocates(this::Neighbor{N}, indices::NTup{N,Int}) where {N} =
    isequal(Tuple(this), indices)


"""

    Neighborbood


"""
abstract type Neighborhood{N} end

const Hood = Neighborhood

"""

    LocalNeighborhood


"""
struct LocalNeighborhood{N} <: Hood{N}
    args::NTup{N,Int}
end

const LocalHood = LocalNeighborhood

#

origin(this::LocalHood) = this.args

#

Base.IteratorSize(::LocalHood) = Base.HasLength()

Base.IteratorEltype(::LocalHood) = Base.HasEltype()

eltype(::Type{<:LocalHood{N}}) where {N} = Neighbor{N,NTup{N,0}}

length(::LocalHood) = 1

isdone(::LocalHood) = false
isdone(::LocalHood, ::Nothing) = true

iterate(this::LocalHood{N}) where {N} = Neighbor{NTup{N,0}}(origin(this)), nothing

iterate(::LocalHood, ::Nothing) = nothing


"""

    LinearNeighborhood


"""
struct LinearNeighborhood{D,S,L,N} <: Hood{N}
    args::NTup{N,Int}

    function LinearNeighborhood{D,S,L}(args::NTup{N,Int}) where {D,S,L,N}
        L < 0 && error("Length parameter is non-positive.")
        D < 1 && error("Dimension parameter is negative.")

        new{D,S,L,N}(args)
    end
end

const LinearHood = LinearNeighborhood

#

origin(this::LinearHood) = this.args

#

first(this::LinearHood{D,S,0}) where {D,S} =
    error("LinearNeighborhood is empty.")

function first(this::LinearHood{D,S,L,N}) where {D,S,L,N}
    T = Tuple{ntuple(d -> ifelse(isequal(D, d), S, 0), Val(N))...}
    Neighbor{T}(origin(this))
end

tail(this::LinearHood{D,S,0}) where {D,S} =
    error("LinearNeighborhood is empty.")

tail(this::LinearHood{D,S,L}) where {D,S,L} =
    LinearHood{D,S+1,L-1}(origin(this))

# iteration interface

Base.IteratorSize(::LinearHood) = Base.HasLength()

Base.IteratorEltype(::LinearHood) = Base.HasEltype()

length(::LinearHood{D,S,L}) where {D,S,L} = L

eltype(::Type{<:LinearHood{D,S,0}}) where {D,S} = Union{}

function eltype(::Type{LinearHood{D,S,L,N}}) where {D,S,L,N}
    T = Tuple{ntuple(d -> ifelse(isequal(D, d), S, 0), Val(N))...}
    Union{Neighbor{N,T}, eltype(LinearHood{D,S+1,L-1,N})}
end

isdone(::LinearHood{D,S,0}) where {D,S} = true
isdone(::LinearHood) = false
isdone(::LinearHood, ::LinearHood{D,S,0}) where {D,S} = true
isdone(::LinearHood, ::LinearHood) = false

iterate(::LinearHood, ::LinearHood{D,S,0}) where {D,S} = nothing

iterate(this::LinearHood, state::LinearHood=this) =
    first(state), Base.tail(state)

# getindex

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
