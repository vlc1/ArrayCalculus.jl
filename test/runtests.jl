using ArrayOperations
using Test

const ∇₁ = ∇{Tuple{1}}()
const ∇₂ = ∇{Tuple{2}}()
const ∇₃ = ∇{Tuple{3}}()

const ∂₁ = ∂{1}()
const ∂₂ = ∂{2}()
const ∂₃ = ∂{3}()

@testset "Binary" begin
    struct BinOp <: Primitive{Arity{2}} end

    (::BinOp)((x, y)::NTuple{2,AbstractVector}, i::Int) = x[i] * y[i-1]

    n = 2
    x, y = rand(n), rand(n)

    # binary operator
    f = BinOp()

    # fix all arguments
    h = f((x, y))

    # fix all arguments but the first, then fix first
    g₁ = ∂₁(f, (y,))
    h′ = g₁((x,))

    @test isequal(h, h′)

    # fix all arguments but the second, then fix second
    g₂ = ∂₂(f, (x,))
    h″ = g₂((y,))

    @test isequal(h, h″)

    rng = 2:n

    @test isequal(h[rng], x[rng] .* y[rng .- 1])
end

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
