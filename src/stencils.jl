abstract type Stencil end

Stencil(::Type, dim) = error("Not implemented.")

Stencil(::O, dim) where{O} = Stencil(O, dim)


"""

    Singleton{NTuple{N,::Int}}


"""
struct Singleton{T} <: Stencil end

(::Singleton{T})(args::NTup{N,Int}) where {N,T<:NTup{N,Any}} = Ref(Neighbor{T}(args))

#

function trim_stencil(::Singleton{T}, args::NTup{N,AURange}) where {N,T<:NTup{N,Any}}
    map(fieldtypes(T), args) do i, arg
        range(first(arg) - min(i, 0), last(arg) - max(i, 0))
    end
end


"""

    LocalStencil


"""
struct LocalStencil <: Stencil end

eachneighbor(::LocalStencil, args::TupN{Int}) = LocalHood(args)

trim_stencil(::LocalStencil, args) = args


"""

    LinearStencil{D,S,L}


"""
struct LinearStencil{D,S,L} <: Stencil end

eachneighbor(::LinearStencil{D,S,L}, args::TupN{Int}) where {D,S,L} =
    LinearHood{D,S,L}(args)

function trim_stencil(::LinearStencil{D,S,L}, args::NTup{N,AURange}) where {D,S,L,N}
    map(ntuple(identity, Val(N)), args) do d, arg
        ifelse(isequal(D, d),
            range(first(arg) - min(S, 0), last(arg) - max(S+L, 0)),
            range(first(arg), last(arg)))
    end
end
