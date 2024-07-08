"""

    Nabla{Tuple{N,M...}}

When applied to an operator, returns another operator that corresponds to the derivative with respect to `N`, `M`...


"""
struct Nabla{T<:Tuple} <: Function

    # sort parameters to limit higher-order cases
    Nabla{T}() where {T<:Tuple} = new{Tuple{TupleTools.sort(fieldtypes(T))...}}()
end

const ∇ = Nabla

Base.print_without_params(::Type{<:∇}) = false

# accessors

Dim{N}(::∇{T}) where {N,T} = Dim{fieldtype(T, N)}()

Dim(::∇{Tuple{N}}) where {N} = Dim{N}()

# interface

(::∇{Tuple{}})(this::Operator) = this

(::∇{Tuple{}})(this::Nullary) = this
(::∇)(this::Nullary) = error("Not differentiable.")
#
#(::∇{NTup{P,1}})(this::Loose{N}) where {P,N} =
#    Loose{N}(∇{NTup{P,N}}()(operator(this)), arguments(this))


"""

    Differentiated{N}(op)


"""
struct Differentiated{T,S,O<:Operator{S}} <: Operator{S}
    op::O

    Differentiated(::∇{T}, op::O) where {T,S,O<:Operator{S}} = new{T,S,O}(op)
end

const Diff = Differentiated

# accessors

∇(::Type{<:Diff{T}}) where {T} = ∇{T}()
∇(::O) where {O<:Diff} = ∇(O)

operator(this::Diff) = this.op

# constructors

(nabla::∇)(this::Operator) = Diff(nabla, this)

# interface

# (::Diff)(::TupN{AArr}, args...) = error("Needs implementing.")
# getindex(this::Fully{<:Diff}, ...) = error("Needs implementing.")
