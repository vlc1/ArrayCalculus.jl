"""

    Jacobian


"""
const Jacobian{N} = Diff{Tup{N}}

const Jac = Jacobian

Base.print_without_params(::Type{<:Jac}) = false

#
#
#getindex(this::Fully{<:Jac}, _...) = error("Implement using stencils.")
#function (this::Jac)(args::TupN{AArr}, I...)
#    op = operator(this)
#    dim = Dim(∇(this))
#
#    scalarize(OperatorSupport(op, dim), this, args, I...)
#end

#
#
#scalarize(::SupportUnknown, _...) = throw(UndefinedMethod())
#
#scalarize(::NullSupport, ::Jac, args::TupN{AArr}, _...) =
#    zero(Base.promote_eltype(args...))
#
#function scalarize(::HasStencil, this::Jac, args::TupN{AArr}, I...)
#    op = operator(this)
#    dim = Dim(∇(this))
#
#    scalarize(Stencil(op, dim), this, args, I...)
##    scalarize(this, args, I...)
#end
#
#scalarize(::PointWise, this::Jac, args::TupN, I...) =
#    this(args, CartInd(I), ())
