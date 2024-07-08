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

@inline @propagate_inbounds function getindex(this::⊙, I...)
    f = handle(this)

    args = map(arguments(this)) do el
        getindex(el, I...)
    end

    f(args...)
end
