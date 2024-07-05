"""

    Loosened{N}(op, args)

Fixes all but one of the arguments to yield a unary operator.

Arguments:

- `P`: position of the variable argument,
- `args`: values of the fixed arguments.


"""
struct Loosened{N,O<:Operator,A<:TupN{AArr}} <: Unary
    op::O
    args::A

    Loosened{N}(op::O, args::A) where {N,O<:Operator,A<:TupN{AArr}} =
        new{N,O,A}(op, args)
end

const Loose = Loosened

Base.print_without_params(::Type{<:Loose}) = false

# accessor

∂(::Type{<:Loose{N}}) where {N} = ∂{N}()

operator(this::Loose) = this.op
arguments(this::Loose) = this.args

# interface

function (this::Loose{N})((arg,)::Tup{AArr}, I::Int...) where {N}
    op = operator(this)
    args = arguments(this)

    op((args[begin:begin+N-2]..., arg, args[begin+N-1:end]...), I...)
end
