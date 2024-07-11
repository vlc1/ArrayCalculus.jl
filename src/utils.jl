"""


Splits an `NTuple` into two `NTuple`s of equal length.


"""
@inline function half(args::NTup{N}) where {N}
    @assert iseven(N)
    args[begin:begin+div(N,2)-1], args[begin+div(N,2):end]
end
