struct Scaled{T<:Number,S,O<:Operator{S}} <: Operator{S}
    op::O
    val::T
end

# accessors

operator(this::Scaled) = this.op

value(this::Scaled) = this.val

# constructors

(*)(val::Number, this::Operator) = Scaled(this, val)
(*)(this::Operator, val::Number) = Scaled(this, val)

(*)(val::Number, this::Scaled) = Scaled(operator(this), val * value(this))
(*)(this::Scaled, val::Number) = Scaled(operator(this), val * value(this))

#

@inline @propagate_inbounds getindex(this::Scaled{T,Nullarity}, I...) where {T} =
    value(this) * getindex(operator(this), I...)
