struct Returned{O<:Operator,A<:TupN{Union{Nullary,AArr}}} <: Nullary
    op::O
    args::A

    Returned(op::O, args::A) where {N,O<:Ary{N},A<:NTup{N,Union{Nullary,AArr}}} =
        new{O,A}(op, args)
end

const Ret = Returned

Base.print_without_params(::Type{<:Ret}) = false

# accessors

operator(this::Ret) = this.op
arguments(this::Ret) = this.args

# constructor

(this::Ary{N})(args::Varg{Any,N}) where {N} = Returned(this, args)

(this::Nullary)() = this

#

eltype(this::Ret) = Base.promote_eltype(arguments(this)...)

@inline @propagate_inbounds getindex_support(::NullSupport, this::Ret, I...) =
    zero(Base.promote_eltype(arguments(this)...))

#=

"""

    Returned(op, args)

Fully evaluated operator.


"""
struct Returned{N,O<:Ary{N},A<:NTup{N,AArr}} <: Nullary
    op::O
    args::A
end

const Ret = Returned

Base.print_without_params(::Type{<:Ret}) = false

# constructors
#
## replaced by Fully
#(this::Operator)(args::TupN{AArr}) =
#    _returned(Arity(this), this, args)

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

=#
