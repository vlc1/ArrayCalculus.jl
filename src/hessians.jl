"""

    Hessian


"""
const Hessian{M,N} = Der{Tup{M,N}}

const Hess = Hessian

Base.print_without_params(::Type{<:Hess}) = false
