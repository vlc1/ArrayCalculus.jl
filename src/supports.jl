"""

    OperatorSupport


"""
abstract type OperatorSupport end

struct SupportUnknown <: OperatorSupport end
struct NullSupport <: OperatorSupport end
struct HasStencil <: OperatorSupport end

OperatorSupport(::O, args::Dim...) where {O<:Operator} =
    OperatorSupport(O, args...)

# default
OperatorSupport(::Type{<:Operator}, ::Dim...) = SupportUnknown()
