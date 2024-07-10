"""

    Jacobian


"""
const Jacobian{N,O,S} = Diff{Tup{N},S,O}

const Jac = Jacobian

Base.print_without_params(::Type{<:Jac}) = false

# interface

getindex(this::Ret{<:Jac{N,O}}, ind::Int...) where {N,O} =
    getindex_jac(OperatorSupport(O, Dim{N}()), this, ind...)

#

getindex_jac(::NullSupport, this, ::Int...) = zero(eltype(this))

getindex_jac(::HasStencil, this::Ret{<:Jac{N,O}}, ind::Int...) where {N,O} =
    getindex_jac(stencil(O, Dim{N}()), this, ind...)

#

function getindex_jac(f::Singleton{T}, this, ind::Int...) where {N,T<:NTup{N,Any}}
    is = ind[begin:begin+N-1]
    js = ind[begin+N:end]

    neighbor = only(f(is))

    ifelse(collocates(neighbor, js), getindex(this, neighbor), zero(eltype(this)))
end
