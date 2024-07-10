"""

    OperatorSupport


"""
abstract type OperatorSupport end

struct SupportUnknown <: OperatorSupport end
struct NullSupport <: OperatorSupport end
struct HasStencil <: OperatorSupport end

OperatorSupport(::Type, dim) = SupportUnknown()

OperatorSupport(::O, dim) where {O} = OperatorSupport(O, dim)
