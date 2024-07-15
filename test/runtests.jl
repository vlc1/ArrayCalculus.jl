using Symbolics # ArrayOperations imports arguments
using ArrayOperations
using Test

import Base: getindex,
             @propagate_inbounds

import ArrayOperations: OperatorSparsity,
                        Stencil

const ∇₁ = ∇{Tuple{1}}()
const ∇₂ = ∇{Tuple{2}}()
const ∇₃ = ∇{Tuple{3}}()

struct TerOp <: Ary{3} end

@inline @propagate_inbounds function getindex(this::Ret{TerOp}, i::Int)
    op = operator(this)
    x, y, _ = arguments(this)

    x[i] * y[i-1]
end

# local dependence w.r.t. to 1st argument

OperatorSparsity(::Type{<:Jac{1,TerOp}}) = HasStencil()
Stencil(::Type{<:Jac{1,TerOp}}) = LocalStencil()

@inline @propagate_inbounds function getindex(this::Ret{<:Jac{1, TerOp}}, arg::Neighbor{1,Tuple{0}})
    i, = origin(arg)
    _, y, _ = arguments(this)

    y[i-1]
end

# local dependence w.r.t. to 2nd argument

OperatorSparsity(::Type{<:Jac{2,TerOp}}) = HasStencil()
Stencil(::Type{<:Jac{2,TerOp}}) = LinearStencil{1,-1,1}()

@inline @propagate_inbounds function getindex(this::Ret{<:Jac{2, TerOp}}, arg::Neighbor{1,Tuple{-1}})
    i, = origin(arg)
    x, _, _ = arguments(this)

    x[i]
end

# no dependence w.r.t. 3rd argument

OperatorSparsity(::Type{<:Jac{3,TerOp}}) = NullOperator()

@testset "Ternary" begin
    n = 8
    x, y, z = rand(n), rand(n), rand(n)

    # ternay operators
    f₃ = TerOp()

    d₁f₃ = ∇₁(f₃)
    d₂f₃ = ∇₂(f₃)
    d₃f₃ = ∇₃(f₃)

    # nullary operators
    f₀ = f₃(x, y, z)

    d₁f₀ = d₁f₃(x, y, z)
    d₂f₀ = d₂f₃(x, y, z)
    d₃f₀ = d₃f₃(x, y, z)

    rng = 2:n

    @test isequal(f₀[rng], x[rng] .* y[rng .- 1])

    i = 4

    @test isequal(f₀[i], x[i] * y[i-1])
    @test isequal(d₁f₀[i, i-1], zero(y[i-1]))
    @test isequal(d₁f₀[i, i], y[i-1])
    @test isequal(d₁f₀[i, i+1], zero(y[i-1]))
    @test isequal(d₂f₀[i, i-1], x[i])
    @test isequal(d₂f₀[i, i], zero(x[i]))
    @test isequal(d₂f₀[i, i+1], zero(x[i]))
end
#=
@testset "Ternary" begin
    struct TerOp <: Primitive{Arity{3}} end

    (::TerOp)((x, y, z)::NTuple{3,AbstractVector}, i::Int) = x[i] * y[i-1] .- z[i+1]

    n = 2
    x, y, z = rand(n), rand(n), rand(n)

    # binary operator
    f = TerOp()

    # fix all arguments
    h = f((x, y, z))

    # fix all arguments but the first, then fix it
    g₁ = ∂₁(f, (y, z))
    h′ = g₁((x,))

    @test isequal(h, h′)

    # fix all arguments but the second, then fix it
    g₂ = ∂₂(f, (x, z))
    h″ = g₂((y,))

    @test isequal(h, h″)

    # fix all arguments but the third, then fix it
    g₃ = ∂₃(f, (x, y))
    h‴ = g₃((z,))

    @test isequal(h, h‴)

    rng = 2:n-1

    @test isequal(h[rng], x[rng] .* y[rng .- 1] .- z[rng .+ 1])
end

=#
