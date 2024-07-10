stencil(::Type, dim) = error("Not implemented.")

stencil(::O, dim) where{O} = stencil(O, dim)

#

struct Neighbor{N,T<:Tup}
    I::NTup{N,Int}

    Neighbor{T}(args::NTup{N,Int}) where {N,T<:NTup{N,Any}} = new{N,T}(args)
end

# accessors

origin(this::Neighbor) = this.I

# interface
#
#getindex(this::Neighbor{T}, i::Int) where {T} =
#    getindex(Tuple(this), i) + fieldtype(T, i)
#
#iterate(::Neighbor{0,Tuple{}}) = nothing
#
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

collocates(this::Neighbor{0}, ::Tuple{}) = true

# leverages the fact that `state <: Neighbor`
function collocates(prev::Neighbor{N}, (x, args...)::NTup{N,Int}) where {N}
    el, next = iterate(prev)
    isequal(el, x) && collocates(next, args)
end

# row(this) .+ fieldtypes(T)

"""

    Singleton{NTuple{M,::Int}}


"""
struct Singleton{T} end

(::Singleton{T})(args::NTup{N,Int}) where {N,T<:NTup{N,Any}} = Ref(Neighbor{T}(args))

#

function trim_stencil(::Singleton{T}, args::NTup{N,AURange}) where {N,T<:NTup{N,Any}}
    map(fieldtypes(T), args) do i, arg
        range(first(arg) - min(i, 0), last(arg) - max(i, 0))
    end
end
