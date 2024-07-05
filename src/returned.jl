struct Returned{O,A<:TupN{AArr}} <: Nullary
    op::O
    args::A
end

const Ret = Returned

Base.print_without_params(::Type{<:Ret}) = false

# constructors

(this::Operator)(args::TupN{AArr}) =
    _returned(Arity(this), this, args)

_returned(::Arity{N}, this::Operator, args::NTup{N,AArr}) where {N} = Ret(this, args)
_returned(::Arity, this::Operator, args::TupN{AArr}) = throw("Input mismatch.")
#
#function Ret(this::Loose{N}, (arg,)::Tup{AArr}) where {N}
#    op = operator(this)
#    args = arguments(this)
#
#    Ret(op, (args[begin:begin+N-2]..., arg, args[begin+N-1:end]...))
#end

# accessors

operator(this::Ret) = this.op
arguments(this::Ret) = this.args

# interface

(this::Ret)(I::Int...) = operator(this)(arguments(this), I...)
