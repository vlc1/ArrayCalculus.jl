"""

    abstract type Stencil end


"""
abstract type Stencil end

function Stencil(::Type{O}) where {O}
    if OperatorSupport(O) isa HasStencil
        error(lazy"Define Stencil for $O.")
    else
        error(lazy"Stencil not defined for type $O.")
    end
end

Stencil(::O) where{O} = Stencil(O)

struct Singleton{T} <: Stencil end

@inline @propagate_inbounds getindex_support(::HasStencil, this::Nullary, I...) =
    getindex_stencil(Stencil(this), this, I...)

@inline @propagate_inbounds function getindex_stencil(::Singleton{T},
        this::Nullary, K::Varg{Int,N}) where {M,N,T<:NTup{M,Any}}
    I = K[begin:begin+M-1]
    J = K[begin+M:end]

    ifelse(isequal(J .- I, fieldtypes(T)), getindex(this, T, J), zero(eltype(this)))
end

#=
# local
struct PointWise <: Stencil end

# one-dimensional
struct LinearStencil{N,S,L} <: Stencil end

Dim(::LinearStencil{N}) where {N} = Dim{N}()
#
#SURange(::LinearStencil{N,S,L}) where {N,S,L} = SURange{S,L}()
=#
