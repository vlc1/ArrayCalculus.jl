module ArrayOperations

import Base: size,
             getindex

export Axis,
       Operator,
       operator,
       arguments,
       Ret,
       Fix,
       Operation

struct Axis{N} end

include("aliases.jl")
include("exceptions.jl")
include("operators.jl")
include("fixed.jl")
include("returned.jl")
include("operations.jl")

end
