"""

    abstract type Stencil end


"""
abstract type Stencil end

# local
struct PointWise <: Stencil end

# one-dimensional
struct LinearStencil{N,S,L} <: Stencil end

Dim(::LinearStencil{N}) where {N} = Dim{N}()
#
#SURange(::LinearStencil{N,S,L}) where {N,S,L} = SURange{S,L}()
