struct Pointwise{F<:Function,A<:TupN{Union{Nullary,AArr}}} <: Nullary
    f::F
    args::A
end

const ⊙ = Pointwise

Base.print_without_params(::Type{<:⊙}) = false

# accessors

handle(this::⊙) = this.f

arguments(this::⊙) = this.args

# constructor

⊙(f, args::Union{Nullary,AArr}...) = ⊙(f, args)

# interface

@inline @propagate_inbounds function getindex(this::⊙, I::Int...)
    f = handle(this)

    args = map(arguments(this)) do el
        getindex(el, I...)
    end

    f(args...)
end

function eltype(this::⊙)
    f = handle(this)
    args = arguments(this)

    Base._return_type(f, Tuple{eltype.(args)...})
end

function axes(this::⊙)
    args = arguments(this)
    f = Broadcast.BroadcastFunction(intersect)
    mapreduce(axes, f, args)
end

(+)(args::Union{Nullary,AArr}...) = ⊙(+, args)
(*)(args::Union{Nullary,AArr}...) = ⊙(*, args)
(-)(args::Varg{Union{Nullary,AArr},2}) = ⊙(-, args)
