"""

    Partial{Tuple{N,M...}}

Return a partially evaluated operator when applied to an operator and a `Tuple` of arguments.

!!! note

    `fieldtypes` of `Tuple` type parameter should be sorted (to remain coherent with user-defined fixed arguments).


"""
struct Partial{T<:Tuple} <: Function

    function Partial{T}() where {T<:Tuple}
        all(>(0), fieldtypes(T)) || error("One or more negative type parameter.")
        allunique(fieldtypes(T)) || error("One or more repeated type parameter.")
        issorted(fieldtypes(T)) || error("Type parameters are not sorted.")

        new{T}()
    end
end

const ∂ = Partial

Base.print_without_params(::Type{<:∂}) = false

# accessors

Dim{N}(::∂{T}) where {N,T} = Dim{fieldtype(T, N)}()

Dim(::∂{Tuple{N}}) where {N} = Dim{N}()

# interface

(::∂{Tuple{}})(this::Operator, ::Tuple{}=()) = this
#
#(::∂{Tuple{}})(this::Ret, ::Tuple{}=()) = this
#
#(::∂{NTuple{N,Any}})(this::Ary{N}, args::NTup{N,AArr}) where {N} = Ret(this, args)


"""

    Partially{N}(op, args)

Partially evaluated operator.

Arguments:

- `T` (= `Tuple{N,M...}`): positions of the fixed arguments,
- `args`: values of the fixed arguments.

!!! note

    No need for `Returned` anymore. Make it the alias below.
    ```julia
    const Fully{O,A,T} = Partially{T,O,A,Nullarity}`
    ```


"""
struct Partially{T,O<:Operator,A<:Tup,S} <: Operator{S}
    op::O
    args::A

#    Partially(::∂{T}, op::O, args::A) where {N,M,T<:NTup{N,Any},O<:Ary{M},A<:NTup{N,Any}} =
#        new{T,O,A,Arity{M-N}}(op, args)
    function Partially(::∂{T}, op::O, args::A) where {N,M,T<:NTup{N,Any},O<:Ary{M},A<:NTup{N,Any}}
        P = sum(fieldtypes(A)) do el
            if ArityStyle(el) isa HasArity
                dim(Arity(el))
            else
                0
            end
        end

        new{T,O,A,Arity{M+P-N}}(op, args)
    end
end

Base.print_without_params(::Type{<:Partially}) = false

const Fully{O,A,T} = Partially{T,O,A,Nullarity}

Base.print_without_params(::Type{<:Fully}) = false

# accessors

∂(::Type{<:Partially{T}}) where {T} = ∂{T}()
∂(::O) where {O<:Partially} = ∂(O)

operator(this::Partially) = this.op
arguments(this::Partially) = this.args

# constructors

(partial::∂)(this::Primitive, args...) = Partially(partial, this, args...)

(partial::∂)(this::Partially, args::Tup) = error("Here we go!")

#(this::Ary{N})(args::NTup{N,Any}) where {N} =
(this::Ary{N})(args::Varg{Any,N}) where {N} =
    ∂{Tuple{SOneTo{N}()...}}()(this, args)

# interface

getindex(this::Fully, _...) = error("Needs implementing.")
