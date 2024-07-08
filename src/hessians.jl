"""

    Hessian


"""
const Hessian{M,N} = Diff{Tup{M,N}}

const Hess = Hessian

Base.print_without_params(::Type{<:Hess}) = false
