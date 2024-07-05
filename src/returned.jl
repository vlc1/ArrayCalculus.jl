struct Returned{O,A<:TupN{AArr}} <: Nullary
    op::O
    args::A
end

const Ret = Returned

Base.print_without_params(::Type{<:Ret}) = false

# constructors

function Ret(this::Fix{N}, (arg,)::Tup{AArr}) where {N}
    op = operator(this)
    args = arguments(this)

    Ret(op, (args[begin:begin+N-2]..., arg, args[begin+N-1:end]...))
end

# accessors

operator(this::Ret) = this.op
arguments(this::Ret) = this.args

# interface

(this::Ret)(I::Int...) = operator(this)(arguments(this), I...)
