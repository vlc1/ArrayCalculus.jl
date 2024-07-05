"""

    Nabla{Tuple{N,M...}}

When applied to an operator, returns another operator that corresponds to the derivative with respect to `N`, `M`...


"""
struct Nabla{T} <: Function

    # sort parameters to limit higher-order cases
    Nabla{T}() where {T} = new{Tuple{TupleTools.sort(fieldtypes(T))...}}()
end

const ∇ = Nabla

Base.print_without_params(::Type{<:∇}) = false

(::∇)(::Ret) = error("Not differentiable.")

(::∇{NTup{P,1}})(this::Loose{N}) where {P,N} =
    Loose{N}(∇{NTup{P,N}}()(operator(this)), arguments(this))


"""

    Derivative{N}(op)


"""
struct Derivative{T,S,O<:Operator{S}} <: Operator{S}
    op::O

    Derivative(::∇{T}, op::O) where {T,S,O<:Operator{S}} = new{T,S,O}(op)
end

const Der = Derivative

# accessor

∇(::Type{<:Der{T}}) where {T} = ∇{T}()

operator(this::Der) = this.op

(::Der)(::TupN{AArr}, args...) = error("Needs implementing.")


"""

    Jacobian


"""
const Jacobian{N} = Der{Tup{N}}

const Jac = Jacobian

Base.print_without_params(::Type{<:Jac}) = false

#

(nabla::∇)(this::Primitive) = Der(nabla, this)


"""

    Hessian


"""
const Hessian{M,N} = Der{Tup{M,N}}

const Hess = Hessian

Base.print_without_params(::Type{<:Hess}) = false
