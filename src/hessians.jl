"""

    Hessian


"""
const Hessian{M,N,O,S} = Diff{Tup{M,N},S,O}

const Hess = Hessian

Base.print_without_params(::Type{<:Hess}) = false
