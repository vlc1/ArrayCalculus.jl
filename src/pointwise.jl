#struct Pointwise{F<:Function,A<:TupN{Union{Nullary,AArr}}} <: Nullary
#    f::F
#    args::A
#end
struct Pointwise{F<:Function,N} <: Ary{N}
    f::F

#    Pointwise{F,N}(f) where {F<:Function,N} = new{F,N}(f)
#    Pointwise{N}(f::F) where {F<:Function,N} = new{F,N}(f)
end

const ⊙ = Pointwise

Base.print_without_params(::Type{<:⊙}) = false

# accessors

handle(this::⊙) = this.f
#
#arguments(this::⊙) = this.args

# constructor

⊙(f::F, args::NTup{N,Union{Nullary,AArr}}) where {F,N} = ⊙{F,N}(f)(args...)

# interface

@inline @propagate_inbounds function getindex(this::Ret{<:⊙}, I...)
    op = operator(this)
    f = handle(op)

    args = map(arguments(this)) do el
        getindex(el, I...)
    end

    f(args...)
end

getindex(op::Ret{<:⊙}, rngs::AURange...) = Operation(op, rngs)

# ambiguity resolution
# getindex(this::⊙, ::Colon...) = Operation(this, axes(this))
#getindex(op::Nullary, rngs::AURange...) = Operation(op, rngs)

# https://docs.julialang.org/en/v1/manual/methods/#Output-type-computation
function eltype(this::Ret{<:⊙})
    op = operator(this)
    f = handle(op)
    args = arguments(this)

#    Base._return_type(f, Tuple{eltype.(args)...})
    Base.promote_op(f, eltype.(args)...)
end
#
#function axes(this::⊙)
#    args = arguments(this)
#    f = Broadcast.BroadcastFunction(intersect)
#    mapreduce(axes, f, args)
#end

(+)(args::Union{Nullary,AArr}...) = ⊙(+, args)
(*)(args::Union{Nullary,AArr}...) = ⊙(*, args)
(-)(args::Varg{Union{Nullary,AArr},2}) = ⊙(-, args)
