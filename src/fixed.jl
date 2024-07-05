"""

    Fixed{N}(op, args)

Fixes all but one of the arguments to yield a unary operator.

Arguments:

- `P`: position of the variable argument,
- `args`: values of the fixed arguments.


"""
struct Fixed{N,O<:Operator,A<:TupN{AArr}} <: Unary
    op::O
    args::A

    Fixed{N}(op::O, args::A) where {N,O<:Operator,A<:TupN{AArr}} =
        new{N,O,A}(op, args)
end

const Fix = Fixed

Base.print_without_params(::Type{<:Fix}) = false

# accessor

Axis(::Type{<:Fix{N}}) where {N} = Axis{N}()

operator(this::Fix) = this.op
arguments(this::Fix) = this.args

# interface

function (this::Fix{N})((arg,)::Tup{AArr}, I::Int...) where {N}
    op = operator(this)
    args = arguments(this)

    op((args[begin:begin+N-2]..., arg, args[begin+N-1:end]), I...)
end
