"""

    Jacobian{N}(op)


"""
struct Jacobian{N,S,O<:Operator{S}} <: Operator{S}
    op::O

    Jacobian{N}(op::O) where {N,S,O<:Operator{S}} = new{N,S,O}(op)
    Jacobian(::∂{N}, op::O) where {N,O} = Jacobian{N}(op)
end

const Jac = Jacobian

Base.print_without_params(::Type{<:Jac}) = false

# accessor

∂(::Type{<:Jac{N}}) where {N} = ∂{N}()

operator(this::Jac) = this.op

#

derive(this::Operator) = derive(∂{1}(), this)

derive(::∂, ::Ret) = error("Not differentiable.")

#derive(p::∂, this::AbstractAry{N}) where {N} = Ary{N}(derive(p, this))
#derive(p::∂, this::Ary{N}) where {N} = Ary{N}(derive(p, operator(this)))

derive(::∂{1}, this::Loose{N}) where {N} =
    Loose{N}(derive(∂{N}(), operator(this)), arguments(this))

derive(p::∂, this::Primitive) = Jac(p, this)
