stencil(::Type, dim) = error("Not implemented.")

stencil(::O, dim) where{O} = stencil(O, dim)

"""

    Singleton{NTuple{M,::Int}}


"""
struct Singleton{T} end

(::Singleton{T})(row::Varg{Int,N}) where {N,T<:NTup{N,Any}} = Ref(row .+ fieldtypes(T))
