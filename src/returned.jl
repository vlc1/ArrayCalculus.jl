struct Returned{O,A<:TupN{AArr}} <: Nullary
    op::O
    args::A
end

const Ret = Returned

Base.print_without_params(::Type{<:Ret}) = false

# constructors

(this::Operator)(args::TupN{AArr}) =
    _returned(OperatorStyle(this), this, args)

_returned(::HasArity{N}, this::Operator, args::NTup{N,AArr}) where {N} = Ret(this, args)
_returned(::OperatorStyle, this::Operator, args::TupN{AArr}) = throw("Not defined.")

function Ret(this::Loose{N}, (arg,)::Tup{AArr}) where {N}
    op = operator(this)
    args = arguments(this)

    Ret(op, (args[begin:begin+N-2]..., arg, args[begin+N-1:end]...))
end

# accessors

operator(this::Ret) = this.op
arguments(this::Ret) = this.args

# interface

(this::Ret)(I::Int...) = operator(this)(arguments(this), I...)
