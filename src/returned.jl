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

# traits

OperatorSparsity(::Type{<:Ret{O}}) where {O} = OperatorSparsity(O)

Stencil(::Type{<:Ret{O}}) where {O} = Stencil(O)

#

eltype(this::Ret) = Base.promote_eltype(arguments(this)...)
#
#function axes(this::Ret{O,A}) where {O,N,A<:NTup{N,Any}}
#    args = arguments(this)
#    f = Broadcast.BroadcastFunction(intersect)
#
#    mapreduce(f, eachindex(args), args) do n, arg
#        trim(O, Dim{n}(), axes(arg))
#    end
#end
