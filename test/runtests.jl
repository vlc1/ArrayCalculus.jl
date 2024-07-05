using ArrayOperations
using Test

@testset "Binary" begin
    struct BinOp <: Operator end

    (::BinOp)((x, y)::NTuple{2,AbstractVector}, i::Int) = x[i] * y[i-1]

    n = 2
    x, y = rand(n), rand(n)

    # binary operator
    f = BinOp()

    # fix all arguments
    h = Ret(f, (x, y))

    # fix all arguments but the first, then fix first
    g₁ = Fix{1}(f, (y,))
    h′ = Ret(g₁, (x,))

    @test isequal(h, h′)

    # fix all arguments but the second, then fix second
    g₂ = Fix{2}(f, (x,))
    h″ = Ret(g₂, (y,))

    @test isequal(h, h″)

    rng = 2:n

    @test isequal(h[rng], x[rng] .* y[rng .- 1])
end

@testset "Ternary" begin
    struct TerOp <: Operator end

    (::TerOp)((x, y, z)::NTuple{3,AbstractVector}, i::Int) = x[i] * y[i-1] .- z[i+1]

    n = 2
    x, y, z = rand(n), rand(n), rand(n)

    # binary operator
    f = TerOp()

    # fix all arguments
    h = Ret(f, (x, y, z))

    # fix all arguments but the first, then fix it
    g₁ = Fix{1}(f, (y, z))
    h′ = Ret(g₁, (x,))

    @test isequal(h, h′)

    # fix all arguments but the second, then fix it
    g₂ = Fix{2}(f, (x, z))
    h″ = Ret(g₂, (y,))

    @test isequal(h, h″)

    # fix all arguments but the third, then fix it
    g₃ = Fix{3}(f, (x, y))
    h‴ = Ret(g₃, (z,))

    @test isequal(h, h‴)

    rng = 2:n-1

    @test isequal(h[rng], x[rng] .* y[rng .- 1] .- z[rng .+ 1])
end
