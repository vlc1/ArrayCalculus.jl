"""

    OperatorSupport


"""
abstract type OperatorSupport end

struct SupportUnknown <: OperatorSupport end
struct NullSupport <: OperatorSupport end
struct HasStencil <: OperatorSupport end

OperatorSupport(::Type, dim) = SupportUnknown()

OperatorSupport(::O, dim) where {O} = OperatorSupport(O, dim)

#

trim(this, dim, args) =
    trim_support(OperatorSupport(this, dim), this, dim, args)

trim_support(::NullSupport, _, _, args) = args

trim_support(::HasStencil, this, dim, args) =
    trim_stencil(stencil(this, dim), args)
