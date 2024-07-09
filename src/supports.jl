"""

    OperatorSupport


"""
abstract type OperatorSupport end

struct SupportUnknown <: OperatorSupport end
struct NullSupport <: OperatorSupport end
struct HasStencil <: OperatorSupport end

OperatorSupport(::Type) = SupportUnknown()

OperatorSupport(::O) where {O} = OperatorSupport(O)

#

@inline @propagate_inbounds getindex(this::Nullary, I...) =
    getindex_support(OperatorSupport(this), this, I...)

# if operator vanishes, define getindex(this::O, ::Type{Tuple{}})
@inline @propagate_inbounds getindex_support(::NullSupport, this::Nullary, I...) =
    getindex(this, Tuple{})
